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
    @Published var gitHubUser: GitHubUser?
    @Published var errorMessage: String?
    @Published var isShowingMailView = false
    let developerEmailAddress = "roberto.rmzabad@gmail.com"
    private var cancellables = Set<AnyCancellable>()
    
    init() {
//        getGitUser()
    }
    
    func getGitUser() {
        // URL del API
        guard let url = URL(string: "https://api.github.com/users/RobertoAbad505") else {
            errorMessage = "URL inválida"
            return
        }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        print("Fetching GIT contact card . . . ")
        // Realiza la solicitud de red
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data) // Extrae solo los datos del resultado
            .decode(type: GitHubUser.self, decoder: decoder) // Decodifica los datos en el modelo GitHubUser
            .receive(on: DispatchQueue.main) // Asegura que se actualice en el hilo principal
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break // Todo salió bien
                case .failure(let error):
                    // Diagnose and print the error
                    DispatchQueue.main.async {
                        self?.errorMessage = "Failed to load user: \(error.localizedDescription)"
                    }
                    self?.logErrorDetails(error as! NetworkError)
                }
            }, receiveValue: { [weak self] user in
                // Actualiza el usuario en la propiedad publicada
                self?.gitHubUser = user
                print(user)
            })
            .store(in: &cancellables)
    }
    private func logErrorDetails(_ error: NetworkError) {
        print("⚠️ API Error: \(error.localizedDescription)")
        
        if let urlError = error as? URLError {
            print("➡️ URLError Code: \(urlError.code.rawValue)")
            print("➡️ URLError Description: \(urlError.localizedDescription)")
        } else if let decodingError = error as? DecodingError {
            switch decodingError {
            case .typeMismatch(let type, let context):
                print("➡️ Type mismatch for type \(type): \(context.debugDescription)")
            case .valueNotFound(let type, let context):
                print("➡️ Value not found for type \(type): \(context.debugDescription)")
            case .keyNotFound(let key, let context):
                print("➡️ Key '\(key)' not found: \(context.debugDescription)")
            case .dataCorrupted(let context):
                print("➡️ Data corrupted: \(context.debugDescription)")
            @unknown default:
                print("➡️ Unknown decoding error: \(error)")
            }
        } else {
            print("➡️ Unknown error type: \(error)")
        }
    }

    func canSendEmailToDeveloper() -> Bool {
        MFMailComposeViewController.canSendMail()
    }
    
}
