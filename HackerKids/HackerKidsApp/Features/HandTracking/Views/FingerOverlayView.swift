//
//  FingerOverlayView.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 12/8/25.
//

import SwiftUI

struct FingerOverlayView: View {
    let hands: [HandPoints]

    var body: some View {
        GeometryReader { geo in
            ForEach(0..<hands.count, id: \.self) { idx in
                let hand = hands[idx]
                let color = hand.isLeft ? Color.blue : Color.green
                ForEach(Array(hand.points.enumerated()), id: \.offset) { _, point in
                    Circle()
                        .stroke(Color.white, lineWidth: 5)
                        .fill(color.opacity(0.9))
                        .frame(width: 25, height: 25)
                        .position(
                            x: point.x * geo.size.width,
                            y: (1 - point.y) * geo.size.height
                        )
                }
            }
        }
        .allowsHitTesting(false)
    }
}

#Preview {
    FingerOverlayView(hands: [])
}
