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
    @Published var animateScale: Bool = false
    @Published var rspButton: String = "Press to start!!"
    @Published var isRspOn: Bool = false
    @Published var trackingMode: HandTrackerMode = .gestures
    @Published var hands: [HandPoints] = []
    @Published var gesture: String = "-" {
        didSet {
            if gesture == oldValue { return }
        }
    }
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
    func startRPS() {
        countdown()
    }
    
    private func countdown() {
        let values = ["3", "2", "1"]
        
        for (index, value) in values.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index)) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    self.rspButton = value
                    self.animateScale.toggle() // dispara la animación
                }
            }
        }
        
        // Mostrar "Go!" y luego desaparecer
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(values.count)) {
            withAnimation(.easeInOut(duration: 0.3)) {
                self.rspButton = "Go!"
                self.animateScale.toggle()
            }
        }
        
        // Desaparecer el botón después de 1 segundo de "Go!"
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(values.count) + 1) {
            withAnimation {
                self.isRspOn = true
                self.rspButton = "Press to start!"
            }
        }
    }
}
enum HandTrackerMode: String, CaseIterable {
    case gestures = "Gestures"
    case rps = "Rock, Paper, Scissors"
}
struct HandPoints {
    let isLeft: Bool
    let points: [CGPoint]
}
