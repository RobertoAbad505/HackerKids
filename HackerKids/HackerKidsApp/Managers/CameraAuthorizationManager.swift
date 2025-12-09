//
//  CameraAuthorizationManager.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 12/8/25.
//

import Foundation
import AVFoundation

final class CameraAuthorizationManager: ObservableObject {
    @Published var status: AVAuthorizationStatus = .notDetermined

    init() {
        refreshStatus()
    }

    func refreshStatus() {
        self.status = AVCaptureDevice.authorizationStatus(for: .video)
    }

    func requestPermission() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                self.refreshStatus()
            }
        }
    }
}
