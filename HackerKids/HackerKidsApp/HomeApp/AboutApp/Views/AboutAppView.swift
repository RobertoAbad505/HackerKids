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
    @State private var result: Result<MessageComposeResult, Error>? = nil
    init(_ viewModel: AboutAppViewModel) {
        self.viewModel = viewModel
    }
    var body: some View {
        VStack(spacing: 10) {
            title
            gitHubProfile
            contactButtons
        }
        .background(Color.blue.opacity(0.3).cornerRadius(20))
        .padding()
        .sheet(isPresented: $viewModel.showMailView) {
            MailView(
                recipients: [viewModel.developerEmailAddress],
                subject: "Consulta desde la app",
                body: "Hola, este es un mensaje generado desde la app SwiftSkills."
            )
        }
        .sheet(isPresented: $viewModel.isShowingMessageCompose) {
            MessageComposeView(result: $result) { controller in
                // Configura el mensaje aquí
                controller.recipients = ["+52 442 333 0132"] // Número de teléfono
                controller.body = "Hola, este es un mensaje generado desde la app SwiftSkills." // Texto del mensaje
            }
        }
        .onAppear {
            viewModel.fetchGitHubUser()
        }
    }
    var title: some View {
        VStack(spacing: 0) {
            Text("Hacker Kids")
                .setTitle3D(.largeTitle)
            HStack(spacing: 0) {
                Text("by ")
                Button(action: {
                    viewModel.openGitHub()
                }, label: {
                    Text("\(viewModel.gitHubUser?.login ?? "")")
                        .foregroundStyle(Color.blue)
                })
            }
        }
    }
    var gitHubProfile: some View {
        VStack(spacing: 10) {
            AsyncImage(url: URL(string: viewModel.gitHubUser?.avatarUrl ?? "")) { img in
                img
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
            } placeholder: {
                ProgressView()
            }
            .frame(width: 200, height: 200)
            .padding(5)
            .background(LinearGradient(colors: [.blue, .white, .blue], startPoint: .bottomLeading, endPoint: .top))
            .clipShape(Circle())
            Text(viewModel.gitHubUser?.bio ?? "")
                .font(.body)
                .padding(.horizontal)
        }
        .padding(.horizontal)
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
            viewModel.openUrl(source)
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
