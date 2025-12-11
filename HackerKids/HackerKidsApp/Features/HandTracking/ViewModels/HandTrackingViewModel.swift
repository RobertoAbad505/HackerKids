//
//  HandTrackingViewModel.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 12/8/25.
//

import Foundation
import SwiftUI
import AVFoundation

import SwiftUI

@MainActor
final class HandTrackingViewModel: ObservableObject {
    @Published var hands: [HandPoints] = []
    @Published var gesture: String = ""
    @Published var showCameraView: Bool = false
    @Published var flipCamera: Bool = false

    let cameraAuth = CameraAuthorizationManager()

    init() {
        updateAuthorization()
    }
    
    @Published var cameraAuthorized: Bool = false

    func updateAuthorization() {
       cameraAuthorized = (cameraAuth.status == .authorized)
   }

   func requestCameraAccess() {
       cameraAuth.requestPermission()
       DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
           self.updateAuthorization()
       }
   }

   func openCameraIfAuthorized() {
       if cameraAuthorized {
           showCameraView = true
       } else {
           requestCameraAccess()
       }
   }

   func exitCamera() {
       showCameraView = false
       gesture = "—"
       hands = []
   }
}
struct HandPoints {
    let isLeft: Bool
    let points: [CGPoint]
}
