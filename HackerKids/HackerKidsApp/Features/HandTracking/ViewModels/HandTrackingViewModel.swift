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
    
    //AIR DRAWING
    // MARK: - Air Drawing CTRL
    @Published var drawingStrokes: [DrawingStroke] = []
    @Published var currentDrawingPath: [CGPoint] = []
    @Published var isDrawing: Bool = false
    private var lastSmoothedPoint: CGPoint?
    @Published var currentColor: DrawingColor = .blue
    private var lastPoint: CGPoint?
    private var lastTimestamp: TimeInterval?
    @Published var currentLineWidth: CGFloat = 6
    
    //RSP GAME
    @Published var rpsPhase: RPSPhase = .idle
    @Published var frozenGesture: String?          // snapshot del usuario
    @Published var appMove: RPSMove?
    @Published var rpsResult: String = ""
    @Published var rspButton: String = "Press to start!!"
    @Published var isRspOn: Bool = false
    @Published var playerMove: RPSMove?
    @Published var rpsPlayerScore: Int = 0
    @Published var rpsCPUScore: Int = 0    
    
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
            self.rpsPlayerScore += 1
        default:
            self.audioManager.playSoundEffect(named: "gameLoose2", "wav")
            self.rpsCPUScore += 1
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
    private func smoothPoint(_ point: CGPoint) -> CGPoint {
        guard let last = lastSmoothedPoint else {
            lastSmoothedPoint = point
            return point
        }

        let alpha: CGFloat = 0.25
        let smoothed = CGPoint(
            x: last.x + (point.x - last.x) * alpha,
            y: last.y + (point.y - last.y) * alpha
        )

        lastSmoothedPoint = smoothed
        return smoothed
    }
    
    func startDrawing() {
        isDrawing = true
        currentDrawingPath = []
        lastSmoothedPoint = nil
    }

    func stopDrawing() {
        guard !currentDrawingPath.isEmpty else { return }

        drawingStrokes.append(
            DrawingStroke(
                points: currentDrawingPath,
                color: currentColor,
                baseLineWidth: currentLineWidth
            )
        )

        currentDrawingPath = []
        isDrawing = false
        lastPoint = nil
        lastTimestamp = nil
    }

    func addDrawingPoint(_ point: CGPoint) {
        guard isDrawing else { return }

        let smoothed = smoothPoint(point)
        let now = CACurrentMediaTime()

        currentLineWidth = dynamicLineWidth(
            currentPoint: smoothed,
            timestamp: now
        )

        currentDrawingPath.append(smoothed)
    }

    func clearDrawing() {
        drawingStrokes.removeAll()
        currentDrawingPath.removeAll()
    }
    func nextColor() {
        let all = DrawingColor.allCases
        if let index = all.firstIndex(of: currentColor) {
            currentColor = all[(index + 1) % all.count]
            markColorChanged()
        }
    }
    func setColor(_ color: DrawingColor) {
        currentColor = color
    }
    func previousColor() {
        let all = DrawingColor.allCases
        if let index = all.firstIndex(of: currentColor) {
            currentColor = all[(index - 1 + all.count) % all.count]
        }
    }

    func resetColor() {
        currentColor = .blue
    }
    private var lastColorChange = Date.distantPast

    func canChangeColor() -> Bool {
        Date().timeIntervalSince(lastColorChange) > 0.6
    }

    func markColorChanged() {
        lastColorChange = Date()
    }
    private func dynamicLineWidth(
        currentPoint: CGPoint,
        timestamp: TimeInterval
    ) -> CGFloat {

        guard
            let lastPoint = lastPoint,
            let lastTime = lastTimestamp
        else {
            self.lastPoint = currentPoint
            self.lastTimestamp = timestamp
            return 6 // valor inicial
        }

        let distance = hypot(
            currentPoint.x - lastPoint.x,
            currentPoint.y - lastPoint.y
        )

        let deltaTime = max(timestamp - lastTime, 0.016)
        let velocity = distance / CGFloat(deltaTime)

        // 🎯 Ajusta estos valores a tu gusto
        let minWidth: CGFloat = 2
        let maxWidth: CGFloat = 10
        let maxVelocity: CGFloat = 3.5

        let normalized = min(velocity / maxVelocity, 1)
        let width = maxWidth - normalized * (maxWidth - minWidth)

        self.lastPoint = currentPoint
        self.lastTimestamp = timestamp

        return width
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
struct DrawingStroke {
    let points: [CGPoint]
    let color: DrawingColor
    let baseLineWidth: CGFloat
}
enum DrawingColor: CaseIterable, Identifiable {
    case black
    case blue
    case red
    case green
    case orange
    case yellow
    case purple
    case pink
    case cyan
    case brown
    case gray

    var id: Self { self }

    var swiftUIColor: Color {
        switch self {
        case .black: return .black
        case .blue: return .blue
        case .red: return .red
        case .green: return .green
        case .orange: return .orange
        case .yellow: return .yellow
        case .purple: return .purple
        case .pink: return .pink
        case .cyan: return .cyan
        case .brown: return .brown
        case .gray: return .gray
        }
    }

    /// Nombre opcional para debug / accesibilidad
    var name: String {
        String(describing: self).capitalized
    }
}


