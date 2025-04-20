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
    let sprites: PokemonSprites?
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
struct PokemonSprites: Decodable, Hashable {
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
struct OtherSprites: Decodable, Hashable {
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
struct DreamWorld: Decodable, Hashable {
    let front_default: String?
    let front_female: String?
}

struct Home: Decodable, Hashable {
    let front_default: String?
    let front_female: String?
    let front_shiny: String?
    let front_shiny_female: String?
}

struct OfficialArtwork: Decodable, Hashable {
    let front_default: String?
    let front_shiny: String?
}
struct PokemonSpritesShowdown: Decodable, Hashable {
    let back_default: String?
    let back_female: String?
    let back_shiny: String?
    let back_shiny_female: String?
    let front_default: String?
    let front_female: String?
    let front_shiny: String?
    let front_shiny_female: String?
}


