//
//  AboutAppViewModel.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 1/26/25.
//
import Combine
import MessageUI
import Foundation

class AboutAppViewModel: ObservableObject {
    @Published var isShowingMessageCompose: Bool = false
    @Published var showMailView: Bool = false
    @Published var gitHubUser: GitHubUser?
    @Published var errorMessage: String?
    @Published var isShowingMailView: Bool = false
    let services: AboutDeveloperServices = AboutDeveloperServices()
    let developerEmailAddress = "roberto.rmzabad@gmail.com"
    private var cancellables = Set<AnyCancellable>()
    @Published var isLoading = false
    
    func fetchGitHubUser() {
        if let gitHubUser = gitHubUser {
            return
        }
        guard let url = URL(string: "https://api.github.com/users/RobertoAbad505") else {
            errorMessage = "URL inválida"
            return
        }
        print("Fetching GIT contact card . . . ")
        services.fetchQuery(url: url)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                        self?.errorMessage = error.localizedDescription
                case .finished:
                    print("GIT card fetched successfully . . . ")
                    return
                }
            }, receiveValue: { [weak self] response in
                self?.gitHubUser = response
            })
            .store(in: &cancellables)
    }

    func canSendEmailToDeveloper() -> Bool {
        MFMailComposeViewController.canSendMail()
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
            if canSendEmailToDeveloper() {
                showMailView = true
            }
            return
        case .phone:
            url = URL(string: "tel:+524423330132")
        case .text:
            isShowingMessageCompose = true
            return
        case .whatsApp:
            sendMessageOnWhatsApp(phoneNumber: "+524423330132",
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
