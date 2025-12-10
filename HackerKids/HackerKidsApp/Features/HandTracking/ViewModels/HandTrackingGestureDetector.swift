//
//  HandTrackingGestureDetector.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 12/8/25.
//

import Foundation
import Vision
import CoreGraphics

/// Responsible for analyzing Vision hand pose data and producing:
/// - Finger extension states
/// - Detected gestures
/// - Finger tip screen positions
final class HandTrackingGestureDetector {

    var currentCameraIsFront: Bool = true
    // MARK: - Public API
    func analyzeObservations(
        _ observations: [VNHumanHandPoseObservation],
        viewModel: HandTrackingViewModel
    ) {
        // debug
           print(">>> analyzeObservations called with \(observations.count) observations")

           var detectedHands: [HandPoints] = []
           var gestureSummary = "-"

           for obs in observations {
               guard let points = try? obs.recognizedPoints(.all) else { continue }

               // extract tips (no mirror here; captureOutput orientation handles rotation)
               let fingerTips = extractFingerTipPoints(from: points)
               print(">>> extracted tips:", fingerTips.map { String(format: "(%.3f,%.3f)", $0.x, $0.y) })

               // detect finger states & gesture per hand
               let state = detectFingerStates(from: points)
               let gesture = detectGesture(from: state)
               print(">>> per-hand gesture:", gesture, "state:", state)

               // detect left/right
               let isLeft = inferHandSide(from: points)
               detectedHands.append(HandPoints(isLeft: isLeft, points: fingerTips))

               // aggregate gesture for UI (simple strategy)
               gestureSummary = gestureSummary == "-" ? gesture : (gestureSummary + " | " + gesture)
           }

           DispatchQueue.main.async {
               viewModel.hands = detectedHands
               viewModel.gesture = gestureSummary
               print(">>> DETECTOR updated viewModel.hands.count=\(detectedHands.count) gesture=\(gestureSummary)")
           }
    }
    
    private func inferHandSide(from points: [VNHumanHandPoseObservation.JointName : VNRecognizedPoint]) -> Bool {
        // returns true if left hand
        guard let thumb = points[.thumbTip], let index = points[.indexTip] else { return false }
        return thumb.location.x < index.location.x
    }

    // MARK: - Finger Tip Extraction
    private func extractFingerTipPoints(
        from points: [VNHumanHandPoseObservation.JointName : VNRecognizedPoint]
    ) -> [CGPoint] {

        let fingers: [VNHumanHandPoseObservation.JointName] = [
            .thumbTip, .indexTip, .middleTip, .ringTip, .littleTip
        ]

        return fingers.compactMap { finger in
            guard let point = points[finger], point.confidence > 0.3 else { return nil }

            // Mirror X so movement is natural on screen
            //RETURN THE POIINT ACCORDING TO THE SELECTED CAMERA
            return CGPoint(
                x: point.location.x,
                y: point.location.y
            )
        }
    }


    // MARK: - Finger State Detection
    private func detectFingerStates(
        from points: [VNHumanHandPoseObservation.JointName : VNRecognizedPoint]
    ) -> FingerState {

        let thumbExtended = detectThumbExtended(from: points)

        let indexExtended = detectExtended(
            tip: points[.indexTip],
            pip: points[.indexPIP]
        )
        let middleExtended = detectExtended(
            tip: points[.middleTip],
            pip: points[.middlePIP]
        )
        let ringExtended = detectExtended(
            tip: points[.ringTip],
            pip: points[.ringPIP]
        )
        let littleExtended = detectExtended(
            tip: points[.littleTip],
            pip: points[.littlePIP]
        )

        return FingerState(
            thumb: thumbExtended,
            index: indexExtended,
            middle: middleExtended,
            ring: ringExtended,
            little: littleExtended
        )
    }


    // MARK: - Normal Fingers (vertical movement)
    private func detectExtended(
        tip: VNRecognizedPoint?,
        pip: VNRecognizedPoint?
    ) -> Bool {

        guard
            let tip = tip, tip.confidence > 0.3,
            let pip = pip, pip.confidence > 0.3
        else { return false }

        // If the tip is "higher" (lower Y on camera) than the PIP → extended
        return (pip.location.y - tip.location.y) > 0.08
    }


    // MARK: - Thumb (horizontal movement)
    private func detectThumbExtended(
        from points: [VNHumanHandPoseObservation.JointName : VNRecognizedPoint]
    ) -> Bool {

        guard
            let tip = points[.thumbTip], tip.confidence > 0.3,
            let pip = points[.thumbIP], pip.confidence > 0.3
        else { return false }

        // Thumb moves laterally → compare X-axis
        let dx = abs(tip.location.x - pip.location.x)

        // Tunable threshold (0.07–0.12 depending on distance)
        return dx > 0.08
    }


    // MARK: - Gesture Recognition
    private func detectGesture(from state: FingerState) -> String {

        let s = state

        switch (s.thumb, s.index, s.middle, s.ring, s.little) {

        case (true, false, false, false, false):
            return "👍 Thumbs Up"

        case (false, true, false, false, false):
            return "☝️ Pointing"

        case (false, true, true, false, false):
            return "✌️ Victory"

        case (false, false, false, false, false):
            return "✊ Fist"

        case (true, true, true, true, true):
            return "🖐️ Open Hand"

        default:
            return "-"
        }
    }
}


// MARK: - Finger State Model
struct FingerState {
    let thumb: Bool
    let index: Bool
    let middle: Bool
    let ring: Bool
    let little: Bool
}

