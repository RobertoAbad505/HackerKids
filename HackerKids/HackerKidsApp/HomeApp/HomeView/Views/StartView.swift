//
//  StartView.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 4/24/25.
//
import MessageUI
import SwiftData
import Foundation
import SwiftUI
import Kingfisher

struct StartView: View {
    //Environment objects
    @EnvironmentObject var audioManager: AudioManager
    @EnvironmentObject var appState: AppState
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) var colorScheme
    
    //SHEET PRESENTATION FLAGS
    @State var infoView: Bool = false
    @State var loginView: Bool = false
    @State private var result: Result<MessageComposeResult, Error>? = nil
    @State var contactView: Bool = false
    
    //Presentation
    @State var firstRotation: Bool = false
    
    //Demos controls
    @State var selectedFeature: FeatureModel?
    @State var navigate: Bool = false
    
    //background variables
    @State private var scrollOffset: CGFloat = 0
    // Colores para la gradiente (personaliza según tu estilo)
    let colors: [Color] = [.blue,
                           .black,
                           .orange,
                           .black,
                           .green,
                           .white,
                           .red,
                           .white,
                           .yellow,
                           .white,
                           .purple]
    
    @State private var rotationAngle: Angle = .degrees(0) // Ángulo de rotación
    @State private var lastDragValue: CGFloat = 0 // Última posición del arrastre
    
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                ScrollView {
                    VStack(alignment: .center, spacing: 30) {
                        titleView
                        gitHubPicture
                        greetings
                        demoSlideShow
                        contactoView
                        portfolioView
                        aboutMe
                        resummeView
                        Spacer()
                        versionView
                    }
                    .padding(.top, 48)
                    .modifier(ScrollViewOffset(offset: $scrollOffset))
                }
                .coordinateSpace(name: "scroll") // Necesario para el GeometryReader
                .background(
                    // Gradiente dinámica basada en el scroll
                    LinearGradient(
                        gradient: Gradient(colors: interpolatedColors),
                        startPoint: startPoint,
                        endPoint: endPoint
                    )
                    .ignoresSafeArea()
                )
            }
            .padding(.vertical)
            .background(colorScheme == .dark ? .black : .white)
            .edgesIgnoringSafeArea(.all)
            .navigationBarHidden(true)
            .onAppear {
                selectedFeature = nil
                navigate = false
                self.appState.aboutViewModel.fetchGitHubUser()
//                SessionManager.shared.fetchLastSession(modelContext)
                MyiOSCard().writeLocal()
                if !firstRotation { DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) { self.rotate(); self.firstRotation = true }}
            }
            .sheet(isPresented: $appState.aboutViewModel.showMailView) {
                MailView(
                    recipients: [appState.aboutViewModel.developerEmailAddress],
                    subject: "Consulta desde la app",
                    body: "Dejame un mensaje..."
                )
            }
            .sheet(isPresented: $appState.aboutViewModel.isShowingMessageCompose) {
                MessageComposeView(result: $result) { controller in
                    // Configura el mensaje aquí
                    controller.recipients = ["+52 442 333 0132"] // Número de teléfono
                    controller.body = "Dejame un mensaje..." // Texto del mensaje
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    var titleView: some View {
        HStack {
            Text(localized: LangKey.StartView.appTitle)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Spacer()
            //settings button
            Menu {
                Menu("Language") {
                    Button(action: {LocalizationManager.shared.changeLanguage(.english)}) {
                          HStack {
                              Text("English 🇺🇸")
                              if LocalizationManager.shared.currentLanguage == .english {
                                  Image(systemName: "checkmark")
                              }
                          }
                      }

                      Button(action: { LocalizationManager.shared.changeLanguage(.spanish)}) {
                          HStack {
                              Text("Spanish 🇲🇽")
                              if LocalizationManager.shared.currentLanguage == .spanish {
                                  Image(systemName: "checkmark")
                              }
                          }
                      }

                  }
            } label: {
                //gear icon
                Image(systemName: "gearshape.fill")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(Color(colorScheme != .dark ? .black : .white))
            }
        }
        .padding(.horizontal)
    }
    
    var gitHubPicture: some View {
        HStack {
            Spacer()
            KFImage(URL(string: self.appState.aboutViewModel.gitHubUser?.avatarUrl ?? ""))
                .placeholder {
                    ProgressView()
                }
                .retry(maxCount: 3, interval: .seconds(2))
                .cacheOriginalImage()
                .fade(duration: 0.25)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(Circle())
                .frame(width: 140, height: 140)
                .padding(5)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: pictureColors),
                        startPoint: startPoint,
                        endPoint: endPoint
                    )
                    .ignoresSafeArea()
                )
                .clipShape(Circle())
                .shadow(color: Color.black.opacity(0.8), radius: 10, x: 5, y: 5)
                .rotation3DEffect(
                    rotationAngle,
                    axis: (x: 0, y: 1, z: 0) // Rotación en el eje Y para efecto de moneda
                )
                .gesture(
                    TapGesture()
                        .onEnded {
                            self.rotate()
                        }
                )
            Spacer()
        }
    }
    func rotate() {
        audioManager.playSoundEffect(named: "coinFx")
        // Animación para girar 3 veces (1080 grados) en 1.5 segundos
        withAnimation(.bouncy(duration: 1.2)) {
            rotationAngle = .degrees(rotationAngle.degrees + 1080)
        }
    }
    var greetings: some View {
        VStack(alignment: .center, spacing: 10) {
            Text("Hi! I'm Roberto Ramirez - iOS Dev")
                .font(.title3)
                .bold()
            Text("Explore my live SwiftUI demos.")
                .multilineTextAlignment(.center)
                .font(.subheadline)
                .fontWeight(.bold)
            tryRandomDemo
        }
    }
    var tryRandomDemo: some View {
        HStack {
            Spacer()
            Button(action: {
                audioManager.playSoundEffect(named: "coinFx")
                selectedFeature = appState.demosViewModel.features.randomElement()!
                navigate = true
            }, label: {
                HStack {
                    Text("🔥Try a Demo!")
                        .font(.body)
                        .fontWeight(.bold)
                }
            })
            .padding()
            .padding(.horizontal, 30)
            .foregroundStyle(colorScheme == .dark ? .white : .primary)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: Color.black, radius: 10, x: 10, y: 10)
            Spacer()
        }
        .padding(.top, 10)
    }
    var demoSlideShow: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: [GridItem(.flexible())], spacing: 0) {
                ForEach(Array(appState.demosViewModel.features.enumerated()), id: \.offset) { index, feature in
                    DemoItemView(feature: feature, index % 2 == 0)
                        .padding()
                        .padding(.bottom)
                    .onTapGesture(perform: {
                        audioManager.playSelectionSound()
                        // Delay para permitir que el sonido suene antes de navegar
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            selectedFeature = feature
                            navigate = true
                        }
                    })
                }
    //            .padding(.horizontal, isIpad ? 60:0)
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
            PokemonAPIView()
        case .rickAndMorty:
            RickAndMortyHome()
        case .soupChallenge:
            SoupChallengeView(onExit: {})
        case .weather:
            WeatherAppView(appState)
        case .movies:
            MovieBrowserView()
        case .flipCoin:
            FlipCoinView()
        }
    }
    var contactoView: some View {
        VStack {
            VStack(alignment: .center) {
                Text("📲 Leave a message! ;)")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(.bottom)
                HStack {
                    getButton(.linkedIn)
                    getButton(.github)
                    getButton(.whatsApp)
                    getButton(.ig)
                }
                .padding(.bottom)
                HStack {
                    Spacer()
                    getButton(.mail)
                    getButton(.phone)
                    getButton(.text)
                    Spacer()
                }
                if FeatureManager.scheduleACall {
                    Text("or")
                        .font(.title3)
                        .fontWeight(.bold)
                        .frame(alignment: .center)
                    HStack {
                        Button(action: {
                            audioManager.playSelectionSound()
                            UIApplication.shared.open(URL(string: "https://calendly.com/roberto-rmzabad/30min")!)
                        }, label: {
                            HStack {
                                Spacer()
                                Text("🗓️📞 Schedule a call")
                                    .font(.callout)
                                    .fontWeight(.bold)
                                    .fontDesign(.monospaced)
                                    .foregroundStyle(.white)
                                Spacer()
                            }
                            .padding()
                            .background(Color.clear)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke((.white), lineWidth: 3)
                            )
                        })
                    }
                }
            }
            .padding(30)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 45))
            .shadow(color: Color.black.opacity(0.6), radius: 10, x: 5, y: 5)
        }
        .padding(.horizontal)
    }
    
    var portfolioView: some View {
        VStack(alignment: .center, spacing: 25) {
            Text("📲 Portafolio")
                .font(.title2)
                .fontWeight(.bold)
            HStack(alignment: .center, spacing: 30){
                Image(systemName: "apple.logo")
                    .resizable()
                    .frame(width: 55, height: 62)
                    .shadow(color: Color.black.opacity(0.6), radius: 10, x: 5, y: 5)
                Image("gitIcon")
                    .resizable()
                    .frame(width: 52, height: 52)
                    .padding(5)
                    .background(Color(red: 27 / 255, green: 31 / 255, blue: 35 / 255))
                    .clipShape(Circle())
                    .shadow(color: Color.black.opacity(0.6), radius: 10, x: 5, y: 5)
                    .padding(.top, 5)
            }
            Text(LangKey.StartView.portfolioDescription)
                .font(.body)
            NavigationLink(destination: PortafolioView() , label: {
                HStack {
                    Spacer()
                    Text("🍎📱 Apps y prototipos")
                        .font(.callout)
                        .fontWeight(.bold)
                        .fontDesign(.monospaced)
                        .foregroundStyle(.white) // Color dinámico
                    Spacer()
                }
                .padding()
                .background(Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke((.white), lineWidth: 3)
                )
            })
        }
        .padding(20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 45))
        .shadow(color: Color.black.opacity(0.6), radius: 10, x: 5, y: 5)
        .padding(.horizontal)
    }
    var aboutMe: some View {
        VStack(alignment: .center, spacing: 20) {
            Text("📲 About me . . .")
                .font(.title2)
                .fontWeight(.bold)
            Text("""
                Software Engineer with 7+ years of experience in the tech industry, collaborating across different sectors and business complexities.

                Specialized in developing and enhancing iOS applications, with strong expertise in software architecture, performance optimization, and accessibility. I have had the opportunity to work with companies in both Mexico and the United States, including my last two-year project as a Senior iOS Engineer for Wells Fargo, contributing to large-scale digital banking solutions.

                Currently open to new opportunities where to collaborate and keep learning.
                """)
            .font(.body)
        }
        .padding(20)
        .padding(.bottom, 20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 45))
        .shadow(color: Color.black.opacity(0.6), radius: 10, x: 5, y: 5)
        .padding(.horizontal)
    }
    var resummeView: some View {
        VStack(alignment: .center) {
            Text("start.resume.title")
                .font(.title2)
                .fontWeight(.bold)
            Button(action: {
                appState.aboutViewModel.getResume()
            }, label: {
                HStack {
                    Spacer()
                    Image(systemName: "link").font(.system(size: 28))
                    Text("start.resume.option")
                        .font(.headline)
                        .fontWeight(.bold)
                        .fontDesign(.monospaced)
                    Spacer()
                }
                .foregroundStyle(.white) // Color dinámico
                .padding()
                .background(Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke((.white), lineWidth: 3)
                )
            })
        }
        .padding(20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 45))
        .shadow(color: Color.black.opacity(0.6), radius: 10, x: 5, y: 5)
        .padding(.bottom, 20)
        .padding(.horizontal)
    }
    var versionView: some View {
        HStack {
            Text("Lang \(Locale.current.languageCode?.uppercased() ?? "EN")")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .monospaced()
                .fontWeight(.bold)
                .shadow(color: Color.white, radius: 0.5, x: 1, y: 1)
            Spacer()
        }
        .padding()
    }
    // Interpola colores según el offset
    private var interpolatedColors: [Color] {
        let progress = scrollOffset / 1500 // Ajusta el divisor para velocidad de cambio
        let colorCount = CGFloat(colors.count - 1)
        let index = min(colorCount - 1, max(0, progress * colorCount))
        
        let currentIndex = Int(index)
        let nextIndex = min(currentIndex + 1, Int(colorCount))
        let blend = index - CGFloat(currentIndex)
        
        return [
            Color.blendColor(colors[currentIndex], colors[nextIndex], blend: blend),
            Color.blendColor(colors[nextIndex], colors[currentIndex], blend: blend)
        ]
    }
    // Interpola colores según el offset
    private var pictureColors: [Color] {
//        let colors: [Color] = [.white, .blue, .white, .black, .white, .blue]
        let progress = scrollOffset / 1000 // Ajusta el divisor para velocidad de cambio
        let colorCount = CGFloat(colors.count - 1)
        let index = min(colorCount - 1, max(0, progress * colorCount))
        
        let currentIndex = Int(index)
        let nextIndex = min(currentIndex + 1, Int(colorCount))
        let blend = index - CGFloat(currentIndex)
        
        return [
            Color.blendColor(colors[currentIndex], colors[nextIndex], blend: blend),
            Color.blendColor(colors[nextIndex], colors[currentIndex], blend: blend)
        ]
    }
    
    // Puntos dinámicos (ejemplo: movimiento diagonal)
    private var startPoint: UnitPoint {
        UnitPoint(x: scrollOffset * 0.0005, y: 0) // Ajusta el multiplicador
    }
    
    private var endPoint: UnitPoint {
        UnitPoint(x: scrollOffset * 0.0005 + 0.5, y: 1)
    }
    
    func getButton(_ source: ContactSource) -> some View {
        var img = Image("igIcon")
        var color: Color = .pink
        switch source {
        case .ig:
            img = Image("igIcon")
            color = .pink
        case .github:
            img = Image("gitIcon")
            color = Color(red: 27 / 255, green: 31 / 255, blue: 35 / 255)
        case .mail:
            img = Image(systemName: "envelope")
            color = .blue
        case .phone:
            img = Image(systemName: "phone")
            color = .green
        case .text:
            img = Image(systemName: "bubble.left.and.text.bubble.right.fill")
            color = .yellow
        case .whatsApp:
            color = .green
            img = Image("whatsAppIcon")
        case .linkedIn:
            img = Image("linkedInIcon")
            color = .white
        }
        var iconHeight = 37.0
        var iconWidth = 37.0
        if source == .mail || source == .text || source == .phone {
            iconHeight = 28.0
            iconWidth = 34.0
        }
        return Button(action: {
            appState.aboutViewModel.openUrl(source)
        }, label: {
            img
                .resizable()
                .frame(width: iconWidth, height: iconHeight)
                .padding()
                .background(
                    color.opacity(source == .github ? 1 : 0.8)
                )
                .clipShape(Circle())
                .foregroundStyle(colorScheme == .dark ? Color.white : Color.white)
        })
        .padding(1)
        .background(LinearGradient(colors: [.white, .gray, .white, .gray], startPoint: .bottomLeading, endPoint: .top))
        .clipShape(Circle())
        .shadow(color: Color.black.opacity(0.6), radius: 10, x: 5, y: 5)
    }
}
