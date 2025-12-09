//
//  CameraViewController.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 12/8/25.
//

import Foundation
import UIKit
import AVFoundation
import Vision

final class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    private let gestureDetector = HandTrackingGestureDetector()

    var viewModel: HandTrackingViewModel!
    private let captureSession = AVCaptureSession()
    private let videoOutput = AVCaptureVideoDataOutput()

    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var handPoseRequest = VNDetectHumanHandPoseRequest()

    var currentPosition: AVCaptureDevice.Position = .front


    override func viewDidLoad() {
        super.viewDidLoad()
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        // Forzar orientación del preview (portrait normalmente)
        if let connection = previewLayer.connection {
            connection.videoOrientation = .portrait
            // Mirror only for front camera preview, not in the data
            connection.automaticallyAdjustsVideoMirroring = false
            connection.isVideoMirrored = (currentPosition == .front)
        }
        view.layer.addSublayer(previewLayer)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
    }

    func setupCamera() {
        captureSession.beginConfiguration()
        captureSession.sessionPreset = .high

        let desiredPosition: AVCaptureDevice.Position =
            (currentPosition == .front) ? .front : .back
        
        if currentPosition == .front {
            previewLayer?.connection?.automaticallyAdjustsVideoMirroring = false
            previewLayer?.connection?.isVideoMirrored = true
        }

        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                   for: .video,
                                                   position: desiredPosition)
        else {
            print("❌ No camera found for position: \(desiredPosition)")
            return
        }

        guard let input = try? AVCaptureDeviceInput(device: camera) else {
            print("❌ Cannot create input")
            return
        }

        if captureSession.canAddInput(input) {
            captureSession.addInput(input)
        }

        let queue = DispatchQueue(label: "cameraQueue")

        videoOutput.setSampleBufferDelegate(self, queue: queue)
        videoOutput.alwaysDiscardsLateVideoFrames = true

        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        }

        captureSession.commitConfiguration()
        captureSession.startRunning()
    }

    // MARK: - Processing Frames
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection)
    {
        // 1. Prepare orientation based on camera used
        let orientation: CGImagePropertyOrientation = .up

        // 2. Convert sample buffer to pixel buffer
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

        let handler = VNImageRequestHandler(
            cvPixelBuffer: pixelBuffer,
            orientation: orientation,
            options: [:]
        )

        do {
            // 3. Perform request
            try handler.perform([handPoseRequest])

            // 4. Extract only one observation
            guard let observation = handPoseRequest.results?.first else {
                DispatchQueue.main.async {
                    self.viewModel.fingerPoints = []
                    self.viewModel.gesture = "-"
                }
                return
            }

            // 5. Delegate everything to the gesture detector
            gestureDetector.analyzeObservation(observation, viewModel: viewModel)

        } catch {
            print("Vision error: \(error)")
        }
    }

    func flipCamera() {
        captureSession.beginConfiguration()

        // Remove current inputs
        captureSession.inputs.forEach { captureSession.removeInput($0) }

        // Toggle position
        currentPosition = (currentPosition == .front) ? .back : .front

        // Add new input
        let newPosition: AVCaptureDevice.Position =
            (currentPosition == .front) ? .front : .back

        if let newDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                   for: .video,
                                                   position: newPosition),
           let newInput = try? AVCaptureDeviceInput(device: newDevice),
           captureSession.canAddInput(newInput) {
            captureSession.addInput(newInput)
        }

        captureSession.commitConfiguration()
    }
    func isFingerExtended(_ tip: CGPoint, _ pip: CGPoint) -> Bool {
        // Simple rule:
        // TIP y PIP deben tener suficiente separación vertical (mano vertical)
        return abs(tip.y - pip.y) > 0.1
    }
}
enum CameraPosition {
    case front
    case back
}
