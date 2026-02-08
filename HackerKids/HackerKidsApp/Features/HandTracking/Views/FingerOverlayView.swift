//
//  FingerOverlayView.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 12/8/25.
//

import SwiftUI

struct FingerOverlayView: View {
    let hands: [HandPoints]
    @ObservedObject var viewModel: HandTrackingViewModel

    var body: some View {
        GeometryReader { geo in
            ForEach(0..<hands.count, id: \.self) { idx in
                let hand = hands[idx]
                let color = getColor(hand: hand)
                ForEach(Array(hand.points.enumerated()), id: \.offset) { _, point in
                    Circle()
                        .stroke(Color.white, lineWidth: 5)
                        .fill(color.opacity(0.9))
                        .frame(width: 25, height: 25)
                        .position(
                            x: point.x * geo.size.width,
                            y: point.y * geo.size.height
                        )
                }
            }
        }
        .allowsHitTesting(false)
    }
    
    func getColor(hand: HandPoints) -> Color {
        if viewModel.trackingMode == .drawing { return viewModel.currentColor.swiftUIColor }
        return hand.isLeft ? Color.blue : Color.green
    }
}

#Preview {
    FingerOverlayView(hands: [], viewModel: .init())
}
