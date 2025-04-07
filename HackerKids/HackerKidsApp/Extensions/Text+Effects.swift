//
//  Text+Effects.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 4/7/25.
//
import SwiftUI
import Foundation

extension Text {
    public func setTitle3D(_ font: Font = .largeTitle) -> some View {
        self.padding()
            .font(font)
            .fontWeight(.bold)
            .rotation3DEffect(
                .degrees(20), // Ángulo de rotación
                axis: (x: 1, y: 0, z: 0)
            )
            .foregroundColor(.blue)
            .shadow(color: .gray, radius: 10, x: 5, y: 5)
    }
}
