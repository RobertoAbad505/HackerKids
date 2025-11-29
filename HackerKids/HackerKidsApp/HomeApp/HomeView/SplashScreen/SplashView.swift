//
//  SplashView.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 11/17/25.
//

import SwiftUI

struct SplashView: View {
    @State private var animate = false
    
    let keywords = [
        ("SwiftUI", "swift"),
        ("APIs", "network"),
        ("Weather", "cloud.sun"),
        ("Technology", "cpu"),
        ("Gaming", "gamecontroller"),
        ("JSON", "doc.text"),
        ("UI/UX", "paintbrush"),
        ("Hackerkids", "person.3.sequence"),
        ("Cloud", "cloud.fill"),
        ("Data", "tray.and.arrow.down"),
        ("Security", "lock.shield"),
        ("Performance", "speedometer"),
        ("Mobile", "iphone"),
        ("Server", "server.rack"),
        ("GraphQL", "chart.xyaxis.line"),
        ("Coding", "chevron.left.slash.chevron.right"),
        ("AI", "brain.head.profile"),
        ("Weather API", "cloud.bolt.rain.fill"),
        ("Design", "paintpalette"),
        ("Localization", "globe"),
        ("Testing", "checkmark.seal"),
        ("Automation", "gearshape.2.fill"),
        ("Innovation", "lightbulb.fill")
    ]
    @State private var start = UnitPoint.topLeading
    @State private var end = UnitPoint.bottomTrailing
    
    var body: some View {
        VStack {
            ZStack {
                VStack {
                    // Multiple scrolling rows filling vertical space
                    ForEach(0..<7) { row in
                        ScrollingRow(
                            items: shuffledItems(for: row),
                            showIcons: row % 2 == 0, // even rows = icons only
                            showText: row % 2 != 0,  // odd rows = text only
                            direction: row % 2 == 0 ? .left : .right
                        )
                    }
                    .padding(.top, 30)
                }
                .overlay {
                    // Title at top
                    VStack(spacing: 50) {
                        HStack {
                            Spacer()
                            Text("HackerKids")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .scaleEffect(animate ? 1.1 : 0.9)
                                .opacity(animate ? 1 : 0.7)
                                .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: animate)
                                .padding()
                            Spacer()
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                    }
                }
            }
        }
        .meshAnimatedBackgroundSimple()
        .animation(.easeOut)
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            animate = true
        }
        .onAppear {
            withAnimation(
                Animation.linear(duration: 4)
                    .repeatForever(autoreverses: true)
            ) {
                start = UnitPoint.bottomTrailing
                end = UnitPoint.topLeading
            }
        }
    }
    
    // Helper: shuffle items differently per row
    func shuffledItems(for row: Int) -> [(String, String)] {
        return keywords.shuffled()
    }
}

// MARK: - Scrolling Row Component
struct ScrollingRow: View {
    let items: [(String, String)]
    let showIcons: Bool
    let showText: Bool
    let direction: ScrollDirection
    
    @State private var offset: CGFloat = -600
    
    @State private var colorIndex = 0
    let colors: [Color] = [
        .white,
//        .orange,
        .yellow,
        .blue,
        Color.blendColor(.purple, .white, blend: 0.5),
        Color.blendColor(.yellow, .black, blend: 0.5),
        Color.blendColor(.yellow, .white, blend: 0.5)
    ]
    @State private var currentColor: Color = .yellow
    
    var body: some View {
        GeometryReader { geo in
            HStack(spacing: 45) {
                ForEach(items, id: \.0) { item in
                    VStack {
                        if showIcons {
                            Image(systemName: item.1)
                                .font(.system(size: 36))
                                .fontWeight(.bold)
                                .foregroundColor(currentColor)
                                .animation(.linear(duration: 4).repeatForever(autoreverses: false), value: offset)
                                .foregroundColor(colors[colorIndex])
                                .onAppear {
                                    // Timer to change color randomly every 0.8 seconds
                                    Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true) { _ in
                                        currentColor = colors.randomElement() ?? .yellow
                                    }
                                }
                        }
                        if showText {
                            Text(item.0)
                                .fontWeight(.bold)
                                .font(Font.title2.monospaced())
//                                .foregroundColor(.white)
                                .scaleEffect(showText ? 1.1 : 1.0)
                                .fixedSize(horizontal: true, vertical: true)
                                .animation(.easeInOut(duration: 4).repeatForever(autoreverses: true), value: offset)
                                .font(.system(size: 48, weight: .bold, design: .rounded))
                                .foregroundColor(colors[colorIndex])
                                .onAppear {
                                    Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true) { _ in
//                                        colorIndex = (colorIndex + 1) % colors.count
                                        colorIndex = Int.random(in: 0...colors.count - 1)
                                    }
                                }
                        }
                    }
                }
            }
            .offset(x: offset)
            .onAppear {
                // Animate offset depending on direction
                if direction == .left {
                    offset = geo.size.width
                    withAnimation(.linear(duration: 15).repeatForever(autoreverses: false)) {
                        offset = -geo.size.width
                    }
                } else {
                    offset = -geo.size.width
                    withAnimation(.linear(duration: 15).repeatForever(autoreverses: false)) {
                        offset = geo.size.width
                    }
                }
            }
        }
    }
}

// MARK: - Direction Enum
enum ScrollDirection {
    case left, right
}

#Preview {
    SplashView()
}
