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
    @Published var trackingMode: HandTrackerMode = .gestures
    @Published var hands: [HandPoints] = []
    @Published var gesture: String = "-" {
        didSet {
            if gesture == oldValue { return }
        }
    }
    @Published var showCameraView: Bool = false
    @Published var flipCamera: Bool = false
    
    
    //RSP GAME
    @Published var rpsPhase: RPSPhase = .idle
    @Published var frozenGesture: String?          // snapshot del usuario
    @Published var appMove: RPSMove?
    @Published var rpsResult: String = ""
    @Published var rspButton: String = "Press to start!!"
    @Published var isRspOn: Bool = false
    @Published var playerMove: RPSMove?
    
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
        self.rpsPhase = .countdown
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
                //aqui termina el round
                //cambiamos el estatus hasta que el usuario mantenga un gesto "estable"
                self.rpsPhase = .waitingForGesture
                //capturtar el gesto una vez que sea estable
                self.captureUserGesture()
            }
        }
    }
    
    private func captureUserGesture() {
        // Espera corta para permitir estabilidad
        print("captureUserGesture()")
        print(">>>> RPS GESTURE DETECTED: \(self.gesture)")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            guard let move = RPSMove(from: self.gesture) else {
                //No se detecto gesto, reiniciar el flujo
                self.rpsResult = "No gesture detected"
                self.rpsPhase = .result
                self.rspButton = "Press to start!"
                return
            }
            self.frozenGesture = move.rawValue
            self.evaluateRPS(userMove: move)
        }
    }
    private func evaluateRPS(userMove: RPSMove) {
        self.appMove = RPSMove.allCases.randomElement()!
        self.appMove = appMove
        self.playerMove = userMove
        
        let result: String
        
        switch (userMove, appMove) {
        case let (u, a) where u == a:
            result = "Draw 🤝"
        case (.rock, .scissors),
             (.paper, .rock),
             (.scissors, .paper):
            result = "YOU WIN!!! 🎉"
        default:
            result = "You Lose 😅"
        }

        self.rpsResult = result
        self.rpsPhase = .result
        self.isRspOn = true
        self.rspButton = "Press to start!"
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
enum RPSPhase {
    case idle
    case countdown
    case waitingForGesture
    case result
}
enum RPSMove: String, CaseIterable {
    case rock = "✊"
    case paper = "✋"
    case scissors = "✌️"

    init?(from gesture: String) {
        switch gesture {
        case "✊ Fist": self = .rock
        case "✋ Stop": self = .paper
        case "✌️ Victory": self = .scissors
        default: return nil
        }
    }
}
