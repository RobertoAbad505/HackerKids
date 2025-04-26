//
//  View+Extensions.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 4/24/25.
//
import SwiftUI
import Foundation

extension View {
    public func addRoundBorder(_ radius: CGFloat, _ colorScheme: ColorScheme) -> some View {
        return self
            .padding(20)
            .background((colorScheme != .dark ? Color.white: Color.black).opacity(0.1))
            .background(.thinMaterial.opacity(0.8))
            .clipShape(RoundedRectangle(cornerRadius: 45))
            .padding(5)
            .background(colorScheme == .dark ? Color.white: Color.black)
            .clipShape(RoundedRectangle(cornerRadius: 45))
    }
    func leftRoundedBorder<S: ShapeStyle>(
            radius: CGFloat,
            lineWidth: CGFloat = 3,
            borderStyle: S,
            corners: UIRectCorner
        ) -> some View {
            self.modifier(LeftRoundedBorder(radius: radius, lineWidth: lineWidth, borderStyle: borderStyle, corners: corners))
        }
}
// Modificador para obtener el offset del ScrollView
struct ScrollViewOffset: ViewModifier {
    @Binding var offset: CGFloat
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .preference(
                            key: ScrollOffsetKey.self,
                            value: -proxy.frame(in: .named("scroll")).origin.y
                        )
                }
            )
            .onPreferenceChange(ScrollOffsetKey.self) { value in
                offset = value
            }
    }
}

// PreferenceKey para el offset
struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

struct LeftRoundedBorder<S: ShapeStyle>: ViewModifier {
    var radius: CGFloat
    var lineWidth: CGFloat
    var borderStyle: S
    var corners: UIRectCorner

    func body(content: Content) -> some View {
        content
            .clipShape(RoundedCorners(radius: radius, corners: corners))
            .overlay(
                RoundedCorners(radius: radius, corners: corners)
                    .stroke(borderStyle, lineWidth: lineWidth)
            )
    }
}
struct RoundedCorners: Shape {
    var radius: CGFloat = 16
    var corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
