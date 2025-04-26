//
//  PortafolioView.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 4/24/25.
//

import SwiftUI

struct PortafolioView: View {
    @ObservedObject var viewModel: PortfolioViewModel = .init()
    @State var audioManager: AudioManager = .init()
    @State var selectedFeature: FeatureModel?
    @State var navigate: Bool = false
    
    //viewModels
    @ObservedObject var pokemonViewModel: PokemonApiViewModel = .init()
    @ObservedObject var ricknMortyViewModel: RickAndMortyViewModel = .init()
    @ObservedObject var weatherViewModel: WeatherViewModel = .init()
    
    
    //background variables
    @State private var scrollOffset: CGFloat = 0
    // Colores para la gradiente
    let colors: [Color] = [.indigo, .white, .orange, .red, .blue, .green]
    
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    Text("🍎💼 iOS Portafolio")
                        .font(.title)
                        .fontDesign(.monospaced)
                        .padding(.bottom, 50)
                        .padding(.horizontal)
                    listView
                }
                .padding(.bottom, 50)
                .modifier(ScrollViewOffset(offset: $scrollOffset))
            }
            .coordinateSpace(name: "scroll") // Necesario para el GeometryReader
            .background(
                LinearGradient(
                    gradient: Gradient(colors: interpolatedColors),
                    startPoint: startPoint,
                    endPoint: endPoint
                )
                .ignoresSafeArea()
            )
        }
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
    }
    var listView: some View {
        LazyVGrid(columns: [GridItem(.flexible())], spacing: 25) {
            ForEach(Array(viewModel.features.enumerated()), id: \.offset) { index, feature in
                PortafolioCardView(feature: feature, index % 2 == 0)
                .onTapGesture(perform: {
                    audioManager.playSoundEffect(named: "coinFx")
                    // Delay para permitir que el sonido suene antes de navegar
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        selectedFeature = feature
                        navigate = true
                    }
                })
            }
        }
        .background(
            NavigationLink(
                destination: navigationDestination,
                isActive: $navigate,
                label: { EmptyView() }
            )
            .hidden()
        )
    }
    private var navigationDestination: some View {
        Group {
            if let feature = selectedFeature {
                destinationView(for: feature)
            } else {
                EmptyView()
            }
        }
    }

    @ViewBuilder
    func destinationView(for feature: FeatureModel) -> some View {
        switch feature.type {
        case .pokemon:
            PokemonAPIView(viewModel: self.pokemonViewModel)
        case .rickAndMorty:
            RickAndMortyHome(viewModel: self.ricknMortyViewModel)
        case .soupChallenge:
            SoupChallengeView(onExit: {})
        case .weather:
            WeatherAppView(viewModel: self.weatherViewModel)
        }
    }
    // Interpola colores según el offset
    private var interpolatedColors: [Color] {
        let progress = scrollOffset / 1000 // Ajusta el divisor para velocidad de cambio
        let colorCount = CGFloat(colors.count - 1)
        let index = min(colorCount - 1, max(0, progress * colorCount))
        
        let currentIndex = Int(index)
        let nextIndex = min(currentIndex + 1, Int(colorCount))
        let blend = index - CGFloat(currentIndex)
        
        return [
            blendColor(colors[currentIndex], colors[nextIndex], blend: blend),
            blendColor(colors[nextIndex], colors[currentIndex], blend: blend)
        ]
    }
    // Puntos dinámicos (ejemplo: movimiento diagonal)
    private var startPoint: UnitPoint {
        UnitPoint(x: scrollOffset * 0.0005, y: 0) // Ajusta el multiplicador
    }
    
    private var endPoint: UnitPoint {
        UnitPoint(x: scrollOffset * 0.0005 + 0.5, y: 1)
    }
    // Función para mezclar colores
    private func blendColor(_ color1: Color, _ color2: Color, blend: CGFloat) -> Color {
        let uiColor1 = UIColor(color1)
        let uiColor2 = UIColor(color2)
        
        var (r1, g1, b1, a1): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        var (r2, g2, b2, a2): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        
        uiColor1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        uiColor2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        
        return Color(
            red: r1 + (r2 - r1) * blend,
            green: g1 + (g2 - g1) * blend,
            blue: b1 + (b2 - b1) * blend
        )
    }
}

#Preview {
    PortafolioView()
}
