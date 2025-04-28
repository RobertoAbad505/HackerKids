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
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var viewModel: LoginViewModel
    @ObservedObject var aboutViewModel: AboutAppViewModel = AboutAppViewModel()
    //SHEET PRESENTATION FLAGS
    @State var infoView: Bool = false
    @State var loginView: Bool = false
    @State private var result: Result<MessageComposeResult, Error>? = nil
    
    @State var contactView: Bool = false
    
    //background variables
    @State private var scrollOffset: CGFloat = 0
    // Colores para la gradiente (personaliza según tu estilo)
    let colors: [Color] = [.blue,
                           .black,
                           .white,
                           .green,
                           .white,
                           .purple]
    
    @State private var rotationAngle: Angle = .degrees(0) // Ángulo de rotación
    @State private var lastDragValue: CGFloat = 0 // Última posición del arrastre
    
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                ScrollView {
                    VStack(alignment: .center, spacing: 40) {
                        activeProfile
                        gitHubPicture
                        mainDescription
                        contactoView
                        portfolioView
                        aboutMe
                        Spacer()
                        versionView
                    }
                    .padding(.top, 48)
                    .padding(.horizontal)
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
                aboutViewModel.fetchGitHubUser()
                SessionManager.shared.fetchLastSession(modelContext)
            }
            .sheet(isPresented: $aboutViewModel.showMailView) {
                MailView(
                    recipients: [aboutViewModel.developerEmailAddress],
                    subject: "Consulta desde la app",
                    body: "Dejame un mensaje..."
                )
            }
            .sheet(isPresented: $aboutViewModel.isShowingMessageCompose) {
                MessageComposeView(result: $result) { controller in
                    // Configura el mensaje aquí
                    controller.recipients = ["+52 442 333 0132"] // Número de teléfono
                    controller.body = "Dejame un mensaje..." // Texto del mensaje
                }
            }
        }
    }
    var activeProfile: some View {
        HStack {
            Spacer()
            if let user = SessionManager.shared.signedInUser {
                VStack(alignment: .trailing) {
                    Text("Hi! \(user.userName)")
                        .font(.footnote)
                        .onAppear {
                            print("Usuario \(SessionManager.shared.signedInUser?.email ?? "")")
                        }
                }
                if let img = SessionManager.shared.signedInUser?.picture?.createImage() {
                    img
                        .resizable()
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                        .padding(4)
                        .background(UIManager.shared.backgroundGradient)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.fill")
                        .frame(width: 30, height: 30)
                        .padding(3)
                        .background(UIManager.shared.backgroundGradient)
                        .clipShape(Circle())
                }
            }
        }
        .padding()
        .padding(.bottom, 50)
        .onTapGesture {
//            loginView.toggle()
        }
    }
    
    var gitHubPicture: some View {
        KFImage(URL(string: aboutViewModel.gitHubUser?.avatarUrl ?? ""))
            .placeholder {
                ProgressView()
            }
            .retry(maxCount: 3, interval: .seconds(2))
            .cacheOriginalImage()
            .fade(duration: 0.25)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .clipShape(Circle())
            .frame(width: 230, height: 230)
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
            .shadow(color: Color.black.opacity(0.6), radius: 10, x: 5, y: 5)
            .rotation3DEffect(
                rotationAngle,
                axis: (x: 0, y: 1, z: 0) // Rotación en el eje Y para efecto de moneda
            )
            .gesture(
                TapGesture()
                    .onEnded {
                        // Animación para girar 3 veces (1080 grados) en 1.5 segundos
                        withAnimation(.bouncy(duration: 1.2)) {
                            rotationAngle = .degrees(rotationAngle.degrees + 1080)
                        }
                    }
            )
    }
    var mainDescription: some View {
        VStack(alignment: .center, spacing: 10) {
            Text("Roberto Ramirez")
                .font(.title)
                .bold()
            Text("iOS Dev • SwiftUI • GraphQL • APIs integrations • Clean Architecture")
                .multilineTextAlignment(.center)
                .font(.title3)
                .foregroundColor(.secondary)
                .fontWeight(.bold)
            if let location = aboutViewModel.gitHubUser?.location {
                Text("📍\(location) | Always on the move ✈️")
                    .multilineTextAlignment(.center)
                    .font(.headline)
                    .fontWeight(.bold)
                .foregroundColor(.secondary)
            }
            Text(aboutViewModel.gitHubUser?.bio ?? "")
                .multilineTextAlignment(.center)
                .font(.headline)
        }
        .padding(20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 45))
        .shadow(color: Color.black.opacity(0.6), radius: 10, x: 5, y: 5)
    }
    var contactoView: some View {
        VStack(alignment: .center) {
            Text("📲 Leave a message! ;)")
                .font(.title2)
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
        }
        .padding(30)
        .padding(.vertical)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 45))
        .shadow(color: Color.black.opacity(0.6), radius: 10, x: 5, y: 5)
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
            Text("Una pequeña muestra de los proyectos que he desarrollado personalmente con SwiftUI. En estos prototipos encontrarás distintas técnicas, componentes personalizados, integración con APIs, llamadas HTTP, diseño de interfaces y más.")
                .font(.body)
            NavigationLink(destination: PortafolioView(onNavigate: {
                aboutViewModel.openUrl(.github)
            }), label: {
                HStack {
                    Text("🍎📱 Apps y prototipos")
                        .font(.callout)
                        .fontWeight(.bold)
                        .fontDesign(.monospaced)
                        .foregroundStyle(.white) // Color dinámico
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
        .padding(.bottom, 20)
    }
    var versionView: some View {
        HStack {
            Spacer()
            Text("release v0.1")
                .font(.body)
                .fontWeight(.bold)
                .fontDesign(.monospaced)
        }
        .padding()
    }
    // Interpola colores según el offset
    private var interpolatedColors: [Color] {
        let progress = scrollOffset / 900 // Ajusta el divisor para velocidad de cambio
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
    // Interpola colores según el offset
    private var pictureColors: [Color] {
        let colors: [Color] = [.white, .blue, .white, .black, .white, .blue]
        let progress = scrollOffset / 550 // Ajusta el divisor para velocidad de cambio
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
            aboutViewModel.openUrl(source)
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
