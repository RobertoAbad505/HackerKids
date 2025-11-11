//
//  MoviesViewModel.swift
//  MovieBrowserApp
//
//  Created by Roberto Ramirez on 10/11/25.
//

import Foundation
import Combine

class MoviesViewModel: ObservableObject {
    @Published var presenterState: PresenterState = .loading
    @Published var movies: [MovieModel] = []
    @Published var topTenMovies: [MovieModel] = []
    @Published var popularPlaylist: [MovieModel] = []
    @Published var moviesCatalog: [MovieModel] = []
    
    private let api = MoviesApiServices()
    private var pageIndex = 1
    
    private var cancellables = Set<AnyCancellable>()
    
    //async functions
    func fetchMostPopularMovies() async {
        do {
            let response = try await self.api.fetchMostPopularMoviesAsync(self.pageIndex)
            if let results = response.results {
                let topAmount = results.count > 10 ? 10 : 5
                self.topTenMovies = Array(results.prefix(topAmount))
                self.movies = Array(results.dropFirst(topAmount))
                self.pageIndex += 1
            }
            self.presenterState = .success
        } catch {
            self.presenterState = .failure
        }
    }
    //Combine api Calls
    func fetchNextPage() {
        print("Fetching page number: \(self.pageIndex)")
        api.fetchNextPage(self.pageIndex)
            .receive(on: DispatchQueue.main) //Update on the main thread
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break //just finish the reception of the returned published
                case .failure:
                    self?.presenterState = .failure //Some error happened, Presenter needs to modify user experience
                }
            }, receiveValue: { [weak self] data in
                self?.popularPlaylist.append(contentsOf: data.results ?? [])
                self?.pageIndex += 1
            })
            .store(in: &cancellables)
    }
    func fetchGalleryMovies() {
        print("Fetch Gallery Movies . . .")//filling with pages not requested
        api.fetchNextPage(self.pageIndex)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                    case .finished:
                    break
                case .failure:
                    self?.presenterState = .failure
                }
            }, receiveValue: { [weak self] data in
                self?.moviesCatalog.append(contentsOf: data.results ?? [])
                self?.pageIndex += 1
            })
            .store(in: &cancellables)
    }
}
enum PresenterState {
    case loading
    case success
    case failure
}
