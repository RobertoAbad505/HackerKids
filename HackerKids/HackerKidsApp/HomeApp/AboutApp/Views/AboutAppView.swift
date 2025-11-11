//
//  AboutAppView.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 1/26/25.
//

import MessageUI
import SwiftUI
import Kingfisher

struct AboutAppView: View {
    @EnvironmentObject var appState: AppState
    @StateObject var audioManager: AudioManager = AudioManager()
    @State private var result: Result<MessageComposeResult, Error>? = nil
    
    @State private var rotationAngle: Angle = .degrees(0) // Ángulo de rotación
    @State private var lastDragValue: CGFloat = 0 // Última posición del arrastre
    

    var body: some View {
        VStack(spacing: 10) {
            ScrollView {
                title
                gitHubPicture
                mainDescription
                contactButtons
            }
        }
        .background(Color.blue.opacity(0.3).cornerRadius(20))
//        .padding()
        .sheet(isPresented: $appState.aboutViewModel.showMailView) {//ERROR HERE
            MailView(
                recipients: [appState.aboutViewModel.developerEmailAddress],
                subject: "Consulta desde la app",
                body: "Hola, este es un mensaje generado desde la app SwiftSkills."
            )
        }
        .sheet(isPresented: $appState.aboutViewModel.isShowingMessageCompose) {
            MessageComposeView(result: $result) { controller in
                // Configura el mensaje aquí
                controller.recipients = ["+52 442 333 0132"] // Número de teléfono
                controller.body = "Hola, este es un mensaje generado desde la app SwiftSkills." // Texto del mensaje
            }
        }
        .onAppear {
            appState.aboutViewModel.fetchGitHubUser()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
                self.rotate()
            }
        }
    }
    var title: some View {
        VStack(spacing: 0) {
            Text("Hacker Kids")
                .setTitle3D(.largeTitle)
            HStack(spacing: 0) {
                Text("by ")
                Button(action: {
                    appState.aboutViewModel.openGitHub()
                }, label: {
                    Text("\(appState.aboutViewModel.gitHubUser?.login ?? "")")
                        .foregroundStyle(Color.blue)
                })
            }
        }
    }
    var gitHubPicture: some View {
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
            .frame(width: 230, height: 230)
            .padding(5)
            .background(
//                LinearGradient(
//                    gradient: Gradient(colors: pictureColors),
//                    startPoint: startPoint,
//                    endPoint: endPoint
//                )
//                .ignoresSafeArea()
                .blue
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
                        rotate()
                    }
            )
    }
    var mainDescription: some View {
        VStack(alignment: .center, spacing: 10) {
            HStack {
                Spacer()
                Text("Roberto Ramirez")
                    .font(.title)
                    .bold()
                Spacer()
            }
            Text("iOS Dev • SwiftUI • GraphQL • APIs integrations • Clean Architecture")
                .multilineTextAlignment(.center)
                .font(.title3)
                .foregroundColor(.secondary)
                .fontWeight(.bold)
            if let location = self.appState.aboutViewModel.gitHubUser?.location {
                Text("📍\(location) | Always on the move ✈️")
                    .multilineTextAlignment(.center)
                    .font(.headline)
                    .fontWeight(.bold)
                .foregroundColor(.secondary)
            }
            Text(self.appState.aboutViewModel.gitHubUser?.bio ?? "")
                .multilineTextAlignment(.center)
                .font(.headline)
        }
        .padding(20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 45))
        .shadow(color: Color.black.opacity(0.6), radius: 10, x: 5, y: 5)
    }
    func rotate() {
        audioManager.playSoundEffect(named: "coinFx")
        // Animación para girar 3 veces (1080 grados) en 1.5 segundos
        withAnimation(.bouncy(duration: 1.2)) {
            rotationAngle = .degrees(rotationAngle.degrees + 1080)
        }
    }
    var contactButtons: some View {
        VStack {
            Text("Contact me:")
            HStack {
                getButton(.linkedIn)
                getButton(.github)
                getButton(.whatsApp)
                getButton(.ig)
            }
            HStack {
                Spacer()
                getButton(.mail)
                getButton(.phone)
                getButton(.text)
                Spacer()
            }
        }
        .padding(.vertical)
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
                    color
                )
                .foregroundStyle(Color.white)
                .clipShape(Circle())
        })
        .padding(1)
        .background(LinearGradient(colors: [.white, .gray, .white, .gray], startPoint: .bottomLeading, endPoint: .top))
        .clipShape(Circle())
        .shadow(color: Color.purple.opacity(0.5), radius: 10, x: 5, y: 5)
    }
}
enum ContactSource {
    case ig
    case github
    case mail
    case phone
    case text
    case whatsApp
    case linkedIn
}
