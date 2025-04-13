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
    
    let service: PokemonServices = PokemonServices()
    let baseUrl: String = "https://pokeapi.co/api/v2/pokemon/?limit=151&offset="
    var cancellables = Set<AnyCancellable>()
    
    init() {
    }

    func fetchData() {
        if pokemonList.count == 0 {
            print("Fetch first pokedex page")
        } else {
            print("Fetching next 151 pokedex page after \(pokemonList.count)")
        }
        guard let url = URL(string: "\(baseUrl)\(pokemonList.count)") else {
            return
        }
        //create api request
        service.fetchData(url)
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
    func processResponse(_ response: PokedexResponse) {
        guard let list = response.results else { return }
        var lastIndex = self.pokemonList.count + 1
        let newList = list.enumerated().map { index, item in
            PokedexItem(id: index + lastIndex, pokemon: item, favorite: Bool.random())
        }
        self.pokemonList.append(contentsOf: newList)
    }
    func setFavorites(pokemon: PokedexItem) {
        var favoriteStatus = true
        
//        if let previousStatus = favoritePokemons.first(where: { $0.id == pokemon.id }) {
//            
//        }
    }
}
