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
    var favorite: Bool = false
    
    func calcImageUrl() -> URL {
        URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png")!
    }
}
