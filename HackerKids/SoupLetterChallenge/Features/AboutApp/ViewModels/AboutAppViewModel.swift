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
    let services: AboutDeveloperServices = AboutDeveloperServices()
    let developerEmailAddress = "roberto.rmzabad@gmail.com"
    private var cancellables = Set<AnyCancellable>()
    @Published var isLoading = false
    
    func fetchGitHubUser() {
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
    
}
