//
//  PokedexResponse.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 4/7/25.
//

import Foundation

struct PokedexResponse: Codable {
    let count: Int?
    let next: String?
    let previous: String?
    let results: [PokemonItem]?
}
struct PokemonItem: Codable, Hashable {
    let name: String?
    let url: String?
}
struct PokedexItem: Codable, Identifiable, Hashable {
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

struct PokedexDetail: Codable, Identifiable, Hashable {
    let id: Int?
    let name: String?
    let height: Int?
    let species: PokemonSpecies?
    let sprites: PokemonSprites?
    let stats: [PokemonBaseStats]?
    let types: [PokemonType]?
    let moves: [PokemonMove]?
    let weight: Int?
}
struct PokemonMove: Codable, Hashable {
    let move: PokeMove?
    struct PokeMove: Codable, Hashable {
        let name: String?
        let url: String?
    }
}
struct PokemonType: Codable, Hashable {
    let slot: Int?
    let type: PokeType?
    struct PokeType: Codable, Hashable {
        let name: String?
        let url: String?
    }
}
struct PokemonSpecies: Codable, Hashable {
    let name: String?
    let url: String?
}
struct PokemonBaseStats: Codable, Hashable {
    let base_stat: Int?
    let effort: Int?
    let stat: PokeStat?
    struct PokeStat: Codable, Hashable {
        let name: String?
        let url: String?
    }
}
struct PokemonSprites: Codable, Hashable {
    let back_default: String?
    let back_female: String?
    let back_shiny: String?
    let back_shiny_female: String?
    let front_default: String?
    let front_female: String?
    let front_shiny: String?
    let front_shiny_female: String?
    let other: OtherSprites?
}
struct OtherSprites: Codable, Hashable {
    let dream_world: DreamWorld?
    let home: Home?
    let official_artwork: OfficialArtwork?
    let showdown: PokemonSpritesShowdown?
    var codingKeys: [CodingKey] {
        return [
            CodingKeys(stringValue: "dream_world")!,
            CodingKeys(stringValue: "home")!,
            CodingKeys(stringValue: "official-artwork")!,
            CodingKeys(stringValue: "showdown")!
        ]
    }
}
struct DreamWorld: Codable, Hashable {
    let front_default: String?
    let front_female: String?
}

struct Home: Codable, Hashable {
    let front_default: String?
    let front_female: String?
    let front_shiny: String?
    let front_shiny_female: String?
}

struct OfficialArtwork: Codable, Hashable {
    let front_default: String?
    let front_shiny: String?
}
struct PokemonSpritesShowdown: Codable, Hashable {
    let back_default: String?
    let back_female: String?
    let back_shiny: String?
    let back_shiny_female: String?
    let front_default: String?
    let front_female: String?
    let front_shiny: String?
    let front_shiny_female: String?
}


