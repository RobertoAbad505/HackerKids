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

        // Forzar orientation del preview (portrait)
        if let connection = previewLayer.connection {
            connection.videoOrientation = .portrait
            connection.automaticallyAdjustsVideoMirroring = false
            // Mirror only for front camera preview
            connection.isVideoMirrored = (currentPosition == .front)
        }
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
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

        // CORRECCIÓN CLAVE
        let orientation: CGImagePropertyOrientation = {
            if currentPosition == .front {
                return .leftMirrored
            } else {
                return .right
            }
        }()

        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer,
                                            orientation: orientation,
                                            options: [:])

        // DEBUG: report number of observations
        
        do {
            try handler.perform([handPoseRequest])
            if let results = handPoseRequest.results {
                print(">>> captureOutput: observations count = \(results.count)")
            } else {
                print(">>> captureOutput: observations is nil")
            }
            let observations = handPoseRequest.results ?? []
            gestureDetector.analyzeObservations(observations, viewModel: viewModel)
        } catch {
            print("Vision error: \(error)")
        }
    }
    func flipCamera() {
        captureSession.beginConfiguration()

        // Remove existing inputs
        captureSession.inputs.forEach { captureSession.removeInput($0) }

        // Toggle position
        currentPosition = (currentPosition == .front) ? .back : .front

        let newPosition = currentPosition

        if let device = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                for: .video,
                                                position: newPosition),
           let input = try? AVCaptureDeviceInput(device: device),
           captureSession.canAddInput(input) {
            captureSession.addInput(input)
        }

        // FIX: Update preview mirroring
        if let conn = previewLayer.connection {
            conn.isVideoMirrored = (currentPosition == .front)
            conn.automaticallyAdjustsVideoMirroring = false
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
