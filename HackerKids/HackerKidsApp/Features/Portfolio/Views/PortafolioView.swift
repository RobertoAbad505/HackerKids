//
//  PortafolioView.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 4/24/25.
//

import SwiftUI

struct PortafolioView: View {
    @ObservedObject var viewModel: PortfolioViewModel = .init()
    @Environment(\.presentationMode) private var presentationMode
    @State var selectedFeature: FeatureModel?
    @State var navigate: Bool = false
    
    //Managers
    @State var audioManager: AudioManager = .init()
    
    //viewModels
    @ObservedObject var pokemonViewModel: PokemonApiViewModel = .init()
    @ObservedObject var ricknMortyViewModel: RickAndMortyViewModel = .init()
    @ObservedObject var weatherViewModel: WeatherViewModel = .init()
    
    
    //background variables
    @State private var scrollOffset: CGFloat = 0
    // Colores para la gradiente
    let colors: [Color] = [.indigo, .white, .orange, .red, .blue, .green]
    let onNavigate: () -> Void
    
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    header
                    description
                    listView
                    gitButton
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
        .navigationBarBackButtonHidden(true)
    }
    var gitButton: some View {
        VStack(alignment: .center, spacing: 10) {
            Text("Más de mis proyectos en GitHub:")
                .font(.body)
                .foregroundColor(.white)
                .padding(.horizontal)
            Button(action: {
                onNavigate()
            }, label: {
                HStack {
                    Spacer()
                    Image("gitIcon")
                        .resizable()
                        .frame(width: 42, height: 42)
                    Spacer()
                }
                .foregroundStyle(.white)
            })
            .background(Color(red: 27 / 255, green: 31 / 255, blue: 35 / 255))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke((.white), lineWidth: 3)
            )
            .padding()
        }
        .padding(.vertical, 40)
    }
    var header: some View {
        HStack(alignment: .top) {
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "chevron.backward")
                    .foregroundColor(.white)
                    .font(.system(size: 24))
                    .fontWeight(.bold)
            })
            .padding(.leading)
            Spacer()
            Text("🍎💼 iOS Portafolio")
                .font(.title)
                .fontDesign(.monospaced)
                .padding(.bottom, 50)
                .padding(.horizontal)
                .padding(.top, 30)
            Spacer()
        }
        .padding(.top, 30)
    }
    var description: some View {
        VStack {
            Text("Esta es una pequeña integracion de modulos hechos con SwiftUI, con uso de multiples tecnicas y frameworks. Estare actualizando este portafolio con mas proyectos en el futuro, disfruta de explorarlos!. Puedes encontrar el resto de mis proyectos para iOS en GitHub.")
                .font(.body)
                .foregroundColor(.white)
                .padding(.horizontal)
        }
        .padding()
        .padding(.bottom)
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
            WeatherAppView(viewModel: .init(), locationManager: .init())
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
    PortafolioView(onNavigate: {
        
    })
}
