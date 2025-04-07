//
//  AboutAppView.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 1/26/25.
//

import MessageUI
import SwiftUI

struct AboutAppView: View {
    @ObservedObject var viewModel: AboutAppViewModel
    @State private var showMailView = false
    @State private var isShowingMessageCompose = false
    @State private var result: Result<MessageComposeResult, Error>? = nil
    init(_ viewModel: AboutAppViewModel, showMailView: Bool = false) {
        self.viewModel = viewModel
        self.showMailView = showMailView
    }
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("Sopita challenge")
                .font(.largeTitle)
            HStack(spacing: 0) {
                Text("by ")
                Button(action: {
                    openGitHub()
                }, label: {
                    Text("\(viewModel.gitHubUser?.login ?? "")")
                        .foregroundStyle(Color.blue)
                })
            }
            AsyncImage(url: URL(string: viewModel.gitHubUser?.avatarUrl ?? "")) { img in
                img
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
            } placeholder: {
                ProgressView()
            }
            .frame(width: 140, height: 140)
            .padding(5)
            .background(LinearGradient(colors: [.blue, .white, .blue], startPoint: .bottomLeading, endPoint: .top))
            .clipShape(Circle())
            Text(viewModel.gitHubUser?.bio ?? "")
                .font(.body)
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
            Spacer()
        }
        .padding()
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $showMailView) {
            MailView(
                recipients: [viewModel.developerEmailAddress],
                subject: "Consulta desde la app",
                body: "Hola, este es un mensaje generado desde la app Sopitas."
            )
        }
        .sheet(isPresented: $isShowingMessageCompose) {
            MessageComposeView(result: $result) { controller in
                // Configura el mensaje aquí
                controller.recipients = ["+1 470 965 9798"] // Número de teléfono
                controller.body = "Hola, este es un mensaje generado desde la app Sopitas." // Texto del mensaje
            }
        }
        .onAppear {
            viewModel.fetchGitHubUser()
        }
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
            openUrl(source)
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
    func openGitHub() {
        openUrl(.github)
    }
    func openUrl(_ contactType: ContactSource){
        var url = URL(string: "")
        switch contactType {
        case .github:
            url = URL(string: "https://github.com/RobertoAbad505/")
        case .ig:
            url =  URL(string: "https://www.instagram.com/roberto.abad21/")
        case .mail:
            if viewModel.canSendEmailToDeveloper() {
                showMailView = true
            }
            return
        case .phone:
            url = URL(string: "tel:+14709659798")
        case .text:
            isShowingMessageCompose = true
            return
        case .whatsApp:
            sendMessageOnWhatsApp(phoneNumber: "+14709659798",
                                  message: "Hey let's work together Roberto!")
        case .linkedIn:
            url = URL(string: "https://www.linkedin.com/in/robertoabad95/")
        }
        if let url = url {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    func sendMessageOnWhatsApp(phoneNumber: String, message: String) {
            // Asegúrate de codificar el mensaje y el número de teléfono en la URL
            let encodedMessage = message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let whatsappURLString = "https://wa.me/\(phoneNumber)?text=\(encodedMessage)"

            // Convertir el string a una URL
            guard let whatsappURL = URL(string: whatsappURLString) else {
                print("Invalid WhatsApp URL")
                return
            }

            // Verificar si el dispositivo puede abrir la URL
            if UIApplication.shared.canOpenURL(whatsappURL) {
                UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
            } else {
                print("WhatsApp is not installed on this device.")
            }
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
