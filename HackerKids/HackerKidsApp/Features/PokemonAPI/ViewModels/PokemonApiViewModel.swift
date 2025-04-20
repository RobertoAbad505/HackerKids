//
//  PokemonApiViewModel.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 4/7/25.
//

import Foundation
import Combine
import SwiftUICore
import SwiftData

class PokemonApiViewModel: ObservableObject {
    @Published var navigateDetail: Bool = false
    @Published var pokemonList: [PokedexItem] = []
    @Published var selectedPokemon: PokedexItem = PokedexItem(id: 1, pokemon: PokemonItem(name: "unkonwn", url: ""))
    @Published var errorFetch: Bool = false
    @Environment(\.modelContext) private var modelContext
    @Published var pokemonsDetail: [PokedexDetail] = []
    
    let service: PokemonServices = PokemonServices()
    let baseUrl: String = "https://pokeapi.co/api/v2/pokemon/?limit=151&offset="
    let debugUrl = URL(string: "https://pokeapi.co/api/v2/pokemon/25/")!
    var cancellables = Set<AnyCancellable>()
    
    init() {
    }

    func fetchPokedexPage() {
        if pokemonList.count == 0 {
            print("Fetch first pokedex page")
        } else {
            print("Fetching next 151 pokedex page after \(pokemonList.count)")
        }
        guard let url = URL(string: "\(baseUrl)\(pokemonList.count)") else {
            return
        }
        //create api request
        service.fetchPokedexPage(url)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    print("Error: \(error)")
                    self?.errorFetch = true
                case .finished:
                    return
                }
            }, receiveValue: { [weak self] response in
                self?.processResponse(response)
            })
            .store(in: &cancellables)
    }
    func fetchPokemonDetail() {
        if let previousFetched = pokemonsDetail.first(where: { $0.id == self.selectedPokemon.id }) {
            print("Pokemon detail already fetched for \(selectedPokemon.pokemon.name ?? "")")
            processDetailsResponse(previousFetched, true)
            return
        }
        guard var urlString = URL(string: selectedPokemon.pokemon.url ?? "") else {
            print("Pokedex detail URL for \(selectedPokemon.pokemon.name ?? "") not found")
            return
        }
        #if ISDEBUG
        urlString = debugUrl
        #endif

        service.fetchPokedexDetail(urlString)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print(completion)
                    return
                case .failure(let error):
                    print(error)
                    print("Pokemon detail completion FAILED")
                    return
                }
            }, receiveValue: { [weak self] response in
                self?.processDetailsResponse(response, false)
            })
            .store(in: &cancellables)
    }
    func processResponse(_ response: PokedexResponse) {
        guard let list = response.results else { return }
        var lastIndex = self.pokemonList.count + 1
        let newList = list.enumerated().map { index, item in
            PokedexItem(id: index + lastIndex, pokemon: item, favorite: Bool.random())
        }
        self.pokemonList.append(contentsOf: newList)
    }
    func processDetailsResponse(_ response: PokedexDetail, _ fromPreviousRequest: Bool = false) {
        if !fromPreviousRequest {
            self.pokemonsDetail.append(response)
        }
        self.selectedPokemon.pokedexDetail = response
    }
    func setFavorites(pokemon: PokedexItem) {
        return
    }
}
