//
//  RickAndMortyViewModel.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 4/2/25.
//
import AVFoundation
import Combine
import Foundation

class RickAndMortyViewModel: ObservableObject {
    @Published var queryObject: RickAndMortyQueryObject = .character
//    @Published var charactersData: CharactersResponse?
    private var pageIndex: Int = 1
    @Published var paginationInfo: PagingInfoModel?
    @Published var charactersCatalog: [RnMCharacter] = []
    @Published var errorLoading: Bool = false
    var requestedPages: [String] = []
    
    private var service: RickAndMortyServiceAPI = RickAndMortyServiceAPI()
    private var baseUrl: String = "https://rickandmortyapi.com/api/"
    private var cancellables = Set<AnyCancellable>()
    
    //api CALLLS
    func fetchData(_ getNextPage: Bool = false) {
        guard let url = URL(string: buildQuery(getNextPage)) else {
            print("URL error")
            return
        }
        if !requestedPages.contains(url.absoluteString) {
            requestedPages.append(url.absoluteString)
        } else {
            print("page already fetch")
            return
        }
        print("Fetch next page: \(url.absoluteString)")
        //call the service
        //sink the request
        //manage the publisher error or success
        //error then manage error scenarios
        //success = fill the result objects
        service.fetchQuery(url: url)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    return
                case .failure(let failure):
                    print("Error: \(failure)")
                    self?.errorLoading = true
                }
            }, receiveValue: { [weak self] response in
                self?.handleResponse(response)
            })
            .store(in: &cancellables)
    }
    func handleResponse(_ response: CharactersResponse) {
        self.paginationInfo = response.info
        self.charactersCatalog.append(contentsOf: response.results ?? [])
    }
    //FUNCTIONS
    private func buildQuery(_ nextPage: Bool = false) -> String {
        if nextPage, let nextPage = paginationInfo?.next {
            return nextPage
        }
        var querySearch: String = ""
        switch queryObject {
        case .character:
            querySearch = "character"
        case .episode:
            querySearch = "episode"
        case .location:
            querySearch = "location"
        }
        let query = baseUrl + querySearch + "/?page=\(pageIndex)"
        pageIndex += 1
        return query
    }
    private func expectedResultObject() -> Any.Type {
        switch queryObject {
        case .character:
            return CharactersResponse.self
        case .episode:
            return EpisodeResponse.self
        case .location:
            return LocationResponse.self
        }
    }
    func playSelectionSound() {
        AudioServicesPlaySystemSound(1104) // "Tock" como el de los botones del teclado
    }
}
enum RickAndMortyQueryObject: String, Identifiable, CaseIterable, Equatable {
    case character = "Characters"
    case episode = "Episodes"
    case location = "Locations"
    var id: String { self.rawValue }
}
