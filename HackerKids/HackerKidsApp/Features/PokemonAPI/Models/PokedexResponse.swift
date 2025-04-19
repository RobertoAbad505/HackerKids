//
//  PokedexResponse.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 4/7/25.
//

import Foundation

struct PokedexResponse: Decodable {
    let count: Int?
    let next: String?
    let previous: String?
    let results: [PokemonItem]?
}
struct PokemonItem: Decodable, Hashable {
    let name: String?
    let url: String?
}
struct PokedexItem: Identifiable, Hashable {
    let id: Int
    let pokemon: PokemonItem
    var pokedexDetail: PokedexDetail? = nil
    var favorite: Bool = false
    
    func calcImageUrl() -> URL {
        URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png")!
    }
    mutating func setDetails(_ detail: PokedexDetail) {
        self.pokedexDetail = detail
    }
}

struct PokedexDetail: Decodable, Identifiable, Hashable {
    let id: Int?
    let name: String?
    let height: Int?
    let species: PokemonSpecies?
    let stats: [PokemonBaseStats]?
    let types: [PokemonType]?
    let moves: [PokemonMove]?
    let weight: Int?
}
struct PokemonMove: Decodable, Hashable {
    let move: PokeMove?
    struct PokeMove: Decodable, Hashable {
        let name: String?
        let url: String?
    }
}
struct PokemonType: Decodable, Hashable {
    let slot: Int?
    let type: PokeType?
    struct PokeType: Decodable, Hashable {
        let name: String?
        let url: String?
    }
}
struct PokemonSpecies: Decodable, Hashable {
    let name: String?
    let url: String?
}
struct PokemonBaseStats: Decodable, Hashable {
    let base_stat: Int?
    let effort: Int?
    let stat: PokeStat?
    struct PokeStat: Decodable, Hashable {
        let name: String?
        let url: String?
    }
}
