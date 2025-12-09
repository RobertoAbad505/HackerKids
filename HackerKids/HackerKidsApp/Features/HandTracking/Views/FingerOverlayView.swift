//
//  FingerOverlayView.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 12/8/25.
//

import SwiftUI

struct FingerOverlayView: View {
    let points: [CGPoint]

    var body: some View {
        GeometryReader { geo in
            ForEach(Array(points.enumerated()), id: \.offset) { index, point in
                Circle()
                    .fill(Color.green.opacity(0.9))
                    .frame(width: 22, height: 22)
                    .position(
                        x: point.x * geo.size.width,
                        y: (1 - point.y) * geo.size.height   // <-- FIX
                    )
            }
        }
        .allowsHitTesting(false)
    }
}
#Preview {
    FingerOverlayView(points: [.zero, .init(x: 0.5, y: 0.5)])
}
