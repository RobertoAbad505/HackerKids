//
//  CameraView.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 12/8/25.
//

import SwiftUI
import AVFoundation
import Vision

struct CameraView: UIViewControllerRepresentable {
    @ObservedObject var viewModel: HandTrackingViewModel

    func makeUIViewController(context: Context) -> CameraViewController {
        let controller = CameraViewController()
        controller.viewModel = viewModel
        controller.setupCamera()
        return controller
    }

    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {
        if viewModel.flipCamera {
            uiViewController.flipCamera()
            viewModel.flipCamera = false
        }
    }
}
