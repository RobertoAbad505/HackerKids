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
           var detectedHands: [HandPoints] = []
           var gestureSummary = ""

           for obs in observations {
               guard let points = try? obs.recognizedPoints(.all) else { continue }

               // extract tips (no mirror here; captureOutput orientation handles rotation)
               let fingerTips = extractFingerTipPoints(from: points)

               // detect finger states & gesture per hand
               let state = detectFingerStates(from: points)
               let gesture = detectGesture(from: state)
               print("Gesture detected: \(gesture)")

               // detect left/right
               let isLeft = inferHandSide(from: points)
               detectedHands.append(HandPoints(isLeft: isLeft, points: fingerTips))

               // aggregate gesture for UI (simple strategy)
               gestureSummary = gestureSummary == "" ? gesture : (gestureSummary + " | " + gesture)
           }
           DispatchQueue.main.async {
               viewModel.hands = detectedHands
               viewModel.gesture = gestureSummary
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
            guard let p = points[finger], p.confidence > 0.25 else { return nil }
            return normalizedPoint(p, cameraIsFront: currentCameraIsFront)
        }
    }


    // MARK: - Finger State Detection
    // MARK: - Finger State Detection
    private func detectFingerStates(
        from points: [VNHumanHandPoseObservation.JointName : VNRecognizedPoint]
    ) -> FingerState {

        // Normalize all required points first
        let indexTip   = points[.indexTip].flatMap { normalizedPoint($0, cameraIsFront: currentCameraIsFront) }
        let indexPIP   = points[.indexPIP].flatMap { normalizedPoint($0, cameraIsFront: currentCameraIsFront) }

        let middleTip  = points[.middleTip].flatMap { normalizedPoint($0, cameraIsFront: currentCameraIsFront) }
        let middlePIP  = points[.middlePIP].flatMap { normalizedPoint($0, cameraIsFront: currentCameraIsFront) }

        let ringTip    = points[.ringTip].flatMap { normalizedPoint($0, cameraIsFront: currentCameraIsFront) }
        let ringPIP    = points[.ringPIP].flatMap { normalizedPoint($0, cameraIsFront: currentCameraIsFront) }

        let littleTip  = points[.littleTip].flatMap { normalizedPoint($0, cameraIsFront: currentCameraIsFront) }
        let littlePIP  = points[.littlePIP].flatMap { normalizedPoint($0, cameraIsFront: currentCameraIsFront) }

        let thumbTip   = points[.thumbTip].flatMap { normalizedPoint($0, cameraIsFront: currentCameraIsFront) }
        let thumbIP    = points[.thumbIP].flatMap { normalizedPoint($0, cameraIsFront: currentCameraIsFront) }

        // Detect extension using ONLY normalized Y
        let indexExtended  = isExtended(tip: indexTip, pip: indexPIP)
        let middleExtended = isExtended(tip: middleTip, pip: middlePIP)
        let ringExtended   = isExtended(tip: ringTip, pip: ringPIP)
        let littleExtended = isExtended(tip: littleTip, pip: littlePIP)
        let thumbExtended  = isThumbExtended(tip: thumbTip, ip: thumbIP)

        // ✅ DEBUG CORRECTO
        print("""
        ---- DEBUG FINGER STATES ----
        cameraIsFront = \(currentCameraIsFront)
        Index:  tip=\(String(describing: indexTip))  pip=\(String(describing: indexPIP))  → \(indexExtended)
        Middle: tip=\(String(describing: middleTip)) pip=\(String(describing: middlePIP)) → \(middleExtended)
        Ring:   tip=\(String(describing: ringTip))   pip=\(String(describing: ringPIP))   → \(ringExtended)
        Little: tip=\(String(describing: littleTip)) pip=\(String(describing: littlePIP)) → \(littleExtended)
        Thumb:  tip=\(String(describing: thumbTip))  ip=\(String(describing: thumbIP))    → \(thumbExtended)
        --------------------------------
        """)

        return FingerState(
            thumb: thumbExtended,
            index: indexExtended,
            middle: middleExtended,
            ring: ringExtended,
            little: littleExtended
        )
    }
    private func isExtended(tip: CGPoint?, pip: CGPoint?) -> Bool {
        guard let tip, let pip else { return false }
        return pip.y - tip.y > 0.05
    }

    private func isThumbExtended(tip: CGPoint?, ip: CGPoint?) -> Bool {
        guard let tip, let ip else { return false }
        return abs(tip.x - ip.x) > 0.06
    }

    // MARK: - Normal Fingers (vertical movement)
    private func detectExtended(
        tip: CGPoint?,
        pip: CGPoint?,
        horizontal: Bool
    ) -> Bool {
        guard let tip = tip, let pip = pip else { return false }

        // Horizontal hand (palm roughly left-right on screen) -> compare X
        if horizontal {
            // tip.x further from pip.x than threshold -> extended
            return abs(tip.x - pip.x) > 0.07
        } else {
            // Vertical palm -> compare Y (pip higher than tip)
            return (pip.y - tip.y) > 0.07
        }
    }



    // MARK: - Thumb (horizontal movement)
    private func detectThumbExtended(
        from points: [VNHumanHandPoseObservation.JointName : VNRecognizedPoint],
        cameraIsFront: Bool,
        horizontal: Bool
    ) -> Bool {

        guard
            let rawTip = points[.thumbTip], rawTip.confidence > 0.25,
            let rawPip = points[.thumbIP], rawPip.confidence > 0.25
        else { return false }

        let tip = normalizedPoint(rawTip, cameraIsFront: cameraIsFront)
        let pip = normalizedPoint(rawPip, cameraIsFront: cameraIsFront)

        if horizontal {
            /// Mano horizontal → el pulgar se mueve verticalmente
            return abs(tip.y - pip.y) > 0.07
        } else {
            /// Mano vertical → el pulgar se mueve lateralmente
            return abs(tip.x - pip.x) > 0.07
        }
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
        case (true, true, false, false, true):
            return "🤟 Punk hand"
        case (false, false, true, true, true):
            return "👌 Ok hand"
        case (true, false, false, false, true):
            return "🤙 Chill hand"
        default:
            return ""
        }
    }
    /// Normaliza un punto de Vision para que coincida con el sistema usado en pantalla.
    /// - Invierte Y (Vision: origen abajo → SwiftUI: origen arriba)
    /// - Invierte X si la cámara es frontal
    private func normalizedPoint(_ p: VNRecognizedPoint,
                                 cameraIsFront: Bool) -> CGPoint {

        var x = cameraIsFront ? (1 - p.location.x) : p.location.x
        let y = 1 - p.location.y
        
        // 🔁 Mirror horizontal ONLY for front camera
        if cameraIsFront {
            x = 1 - x
        }
  
        return CGPoint(x: x, y: y)
    }
    private func normalizeAllPoints(
        _ points: [VNHumanHandPoseObservation.JointName : VNRecognizedPoint],
        cameraIsFront: Bool
    ) -> [VNHumanHandPoseObservation.JointName : CGPoint] {

        var result: [VNHumanHandPoseObservation.JointName : CGPoint] = [:]

        for (joint, raw) in points where raw.confidence > 0.25 {
            result[joint] = normalizedPoint(raw, cameraIsFront: cameraIsFront)
        }

        return result
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

