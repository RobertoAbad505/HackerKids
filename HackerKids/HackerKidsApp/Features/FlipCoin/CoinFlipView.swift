//
//  CoinFlipView.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 11/27/25.
//

import SwiftUI
import AVFoundation

struct CoinFlipView: View {

    // MARK: - Public API
    @Binding var results: [Bool]   // true = heads, false = tails

    var frontImage: String = "headsImg"
    var backImage: String = "tailsImg"

    // MARK: - Animation States
    @State private var rotation: Double = 0
    @State private var isFlipping = false
    @State private var blurAmount: CGFloat = 0
    @State private var shineOffset: CGFloat = -1.0
    
    // Score
    @State private var headsCount = 0
    @State private var tailsCount = 0
    
    let onCoinLand: (Bool) -> Void

    init(results: Binding<[Bool]>, onCoinLand: @escaping (Bool) -> Void) {
        self._results = results
        self.onCoinLand = onCoinLand
    }
    var body: some View {
        VStack(spacing: 40) {
            ZStack {
                coinFace(frontImage, isFront: true)
                coinFace(backImage, isFront: false)
            }
            .frame(width: 250, height: 250)
            .onTapGesture { flipCoin() }
            triggerView            
        }
        .onReceive(NotificationCenter.default.publisher(for: .deviceShaken)) { _ in
            flipCoin()
        }
    }
    
    var triggerView: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: flipCoin) {
                    Image(systemName: "iphone.gen1.radiowaves.left.and.right")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.white)
                    Text("Flip the coin!")
                        .font(.headline)
                        .padding(.vertical, 10)
                        .foregroundColor(.white)
                }
                Spacer()
            }
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke((.white), lineWidth: 3)
            )
            .disabled(isFlipping)
            .opacity(isFlipping ? 0.5 : 1)
        }
    }
}

// MARK: - Coin Faces (3D)
private extension CoinFlipView {

    @ViewBuilder
    func coinFace(_ name: String, isFront: Bool) -> some View {
        Image(name)
            .resizable()
            .scaledToFit()
            .blur(radius: blurAmount)
            .overlay(shineOverlay.mask(Circle()))
            .rotation3DEffect(
                .degrees(isFront ? rotation : rotation - 0),
                axis: (0, 1, 0),
                perspective: 0.20
            )
            .opacity(faceOpacity(isFront: isFront))
    }

    func faceOpacity(isFront: Bool) -> Double {
        let angle = normalizedAngle(rotation)

        if isFront {
            return angle < 90 || angle > 270 ? 1 : 0
        } else {
            return angle > 90 && angle < 270 ? 1 : 0
        }
    }

    func normalizedAngle(_ value: Double) -> Double {
        (value.truncatingRemainder(dividingBy: 360) + 360)
            .truncatingRemainder(dividingBy: 360)
    }

    var shineOverlay: some View {
        LinearGradient(
            colors: [.white.opacity(0), .white.opacity(0.55), .white.opacity(0)],
            startPoint: UnitPoint(x: shineOffset - 0.3, y: 0.5),
            endPoint: UnitPoint(x: shineOffset + 0.3, y: 0.5)
        )
        .animation(.easeInOut(duration: 1.8).repeatForever(autoreverses: false), value: shineOffset)
    }
}

// MARK: - Flip Logic + Perfect Landing
private extension CoinFlipView {

    func flipCoin() {
        
        guard !isFlipping else { return }
        HapticManager.shared.flipStart()
        isFlipping = true
        blurAmount = 8
        shineOffset = -1.0

        // Full rotations
        let fullTurns = Double(Int.random(in: 3...7)) * 360
        
        // Random landing between front or back
        let landingFront = Bool.random()
        let landingAngle: Double = landingFront ? 0 : 180   // perfect face position

        // Animate
        withAnimation(.timingCurve(0.1, 0.9, 0.3, 1.0, duration: 1.6)) {
            rotation += fullTurns + landingAngle
        }

        withAnimation(.easeOut(duration: 1.6)) {
            blurAmount = 0
        }

        withAnimation {
            shineOffset = 2.0
        }

        // Finish
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
            
            // Final normalized angle
            let finalAngle = normalizedAngle(rotation)
            let isFrontNow = finalAngle < 90 || finalAngle > 270

            if isFrontNow {
                headsCount += 1
                results.append(true)
                HapticManager.shared.flipLandingHeads()
            } else {
                tailsCount += 1
                results.append(false)
                HapticManager.shared.flipLandingTails()
            }
            self.onCoinLand(isFrontNow)

            // RESET rotation so next flip is clean
            rotation = isFrontNow ? 0 : 180

            isFlipping = false
        }
    }
}



#Preview {
    CoinFlipView(results: .constant(.init()), onCoinLand: { _ in})
}
