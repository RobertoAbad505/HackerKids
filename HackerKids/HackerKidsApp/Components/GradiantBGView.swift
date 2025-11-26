//
//  GradiantBGView.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 11/25/25.
//

import SwiftUI

@available(iOS 17.0, macOS 14.0, *)
struct AnimatedMeshGradientModifierSimple: ViewModifier {
    @State private var colorToggle = false

    func body(content: Content) -> some View {
        ZStack {
            MeshGradient(
                width: 2, height: 2,
                points: [
                   .init(x: 0, y: 0),
                   .init(x: 1, y: 0),
                   .init(x: 0, y: 1),
                   .init(x: 1, y: 1)
                ],
                colors: colorToggle ? colorSetA : colorSetB
            )
            .ignoresSafeArea()
            content
        }
        .ignoresSafeArea(.all)
        .onAppear {
            withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
                colorToggle.toggle()
            }
        }
    }

    private var colorSetA: [Color] {
        [
            Color(red: 0.06, green: 0.98, blue: 0.6),
            Color(red: 0.05, green: 0.6, blue: 0.9),
            Color(red: 0.5, green: 0.2, blue: 0.9),
            Color(red: 0.95, green: 0.35, blue: 0.6),
            Color(red: 0.98, green: 0.7, blue: 0.2),
            Color(red: 0.06, green: 0.98, blue: 0.6),
            Color(red: 0.06, green: 0.98, blue: 0.6),
            Color(red: 0.06, green: 0.98, blue: 0.6),
        ]
    }

    private var colorSetB: [Color] {
        [ Color(red: 0.0, green: 0.8, blue: 0.7),
          Color(red: 0.0, green: 0.65, blue: 0.95),
          Color(red: 0.65, green: 0.15, blue: 0.9),
          Color(red: 0.98, green: 0.45, blue: 0.25) ]
    }
}

@available(iOS 17.0, macOS 14.0, *)
extension View {
    func meshAnimatedBackgroundSimple() -> some View {
        modifier(AnimatedMeshGradientModifierSimple())
    }
}
