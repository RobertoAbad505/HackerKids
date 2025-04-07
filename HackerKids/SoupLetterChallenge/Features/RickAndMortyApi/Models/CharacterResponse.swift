//
//  CharacterResponse.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 4/2/25.
//

import Foundation

struct CharactersResponse: Decodable {
    let info: PagingInfoModel?
    let results: [RnMCharacter]?
}
struct PagingInfo: Codable {
    let count: Int?
    let pages: Int?
    let next: String?
    let prev: String?
}
struct RnMCharacter: Codable {
    let id: Int?
    let name: String?
    let status: String?
    let species: String?
    let type: String?
    let gender: String?
    let image: String?
    let episode: [String]?
    let url: String?
    let created: String?
    let origin: CharacterOrigin?
    let location: CharacterLocation?
}
struct CharacterOrigin: Codable {
    let name: String?
    let url: String?
}
struct CharacterLocation: Codable {
    let name: String?
    let url: String?
}
