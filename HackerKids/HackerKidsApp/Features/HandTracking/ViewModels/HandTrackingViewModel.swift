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
    
    //Countdown
    @Published var ringProgress: CGFloat = 0
    @Published var ringRotation: Double = 0
    
    //show hint
    @Published var showHint: Bool = false
    @Published var hintMessage: String = ""
    var audioManager: AudioManager = .init()
    
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
        rpsPhase = .countdown
        
        ringProgress = 0
        ringRotation = 0
        animateScale = false
        
        self.audioManager.playSoundEffect(named: "gameCountdown", "wav")
        startRingCountdown(step: 0)
    }
    
    
    private func startRingCountdown(step: Int) {
        let values = ["3", "2", "1"]

        // Cuando termina el conteo numérico
        guard step < values.count else {
            showGoAndWaitForGesture()
            return
        }

        // Texto actual
        rspButton = values[step]

        // Animación del anillo (1 vuelta por número)
        ringProgress = 0
        withAnimation(.linear(duration: 1)) {
            ringProgress = 1
            ringRotation += 360
        }

        // Pequeña animación de escala del texto (opcional)
        withAnimation(.spring()) {
            animateScale.toggle()
        }
        // Siguiente paso después de 1 segundo
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            HapticManager.shared.alert()
            self.startRingCountdown(step: step + 1)
        }
    }
    private func showGoAndWaitForGesture() {
        rspButton = "Go!"

        withAnimation(.easeInOut(duration: 0.3)) {
            animateScale.toggle()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            withAnimation {
                // Aquí termina el round
                self.rpsPhase = .waitingForGesture
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
                self.audioManager.playSoundEffect(named: "gameError", "wav")
                self.showTemporaryHint("Too slow! Show up your hand steady before countdown ends!\n No worries AI is not watching👀")
                self.rpsPhase = .result
                self.rspButton = "Press to start!"
                return
            }
            self.frozenGesture = move.rawValue
            self.evaluateRPS(userMove: move)
            HapticManager.shared.alert()
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
            self.audioManager.playSoundEffect(named: "gameDraw")
        case (.rock, .scissors),
             (.paper, .rock),
             (.scissors, .paper):
            result = "🎉 YOU WIN! 🎉"
            self.audioManager.playSoundEffect(named: "gameWin")
        default:
            self.audioManager.playSoundEffect(named: "gameLoose2", "wav")
            result = "You Lose 😅"
        }

        self.rpsResult = result
        self.rpsPhase = .result
        self.isRspOn = true
        self.rspButton = "Press to start!"
    }
    func showTemporaryHint(_ message: String, duration: Double = 5) {
        hintMessage = message

        withAnimation(.easeInOut) {
            showHint = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            withAnimation(.easeInOut) {
                self.showHint = false
            }
        }
    }
}
enum HandTrackerMode: String, CaseIterable, Identifiable {
    case gestures = "Gestures🤟"
    case rps = "RPS🪨📃✂️"
    case drawing = "Air drawing✍️"
    
    var id: Self { self }
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
        case "👍 Thumbs Up": self = .rock
        case "✊ Fist": self = .rock
        case "✋ Stop": self = .paper
        case "✌️ Victory": self = .scissors
        default: return nil
        }
    }
}
