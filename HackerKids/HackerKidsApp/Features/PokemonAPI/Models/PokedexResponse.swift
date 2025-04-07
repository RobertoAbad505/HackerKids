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
    let results: [PokedexItem]?
}
struct PokedexItem: Decodable, Hashable {
    let name: String?
    let url: String?
    func calcImageUrl(_ index: Int) -> URL {
        return URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(index).png")!
    }
}
