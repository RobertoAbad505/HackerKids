//
//  LocationResponse.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 4/2/25.
//

import Foundation

struct LocationResponse: Decodable {
    let info: PagingInfoModel?
    let results: [RnMCharacter]?
}
