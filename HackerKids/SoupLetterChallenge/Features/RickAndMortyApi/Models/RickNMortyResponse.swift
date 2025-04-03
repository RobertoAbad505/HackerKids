//
//  RickNMortyResponse.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 4/2/25.
//

import Foundation

struct RickNMortyResponse<T: Decodable>: Decodable {
    let info: PagingInfoModel?
    let results: [T]
}
