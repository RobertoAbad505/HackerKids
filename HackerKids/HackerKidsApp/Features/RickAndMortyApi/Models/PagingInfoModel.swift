//
//  PagingInfoModel.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 4/2/25.
//

import Foundation

struct PagingInfoModel: Codable {
    let count: Int?
    let pages: Int?
    let next: String?
    let prev: String?
}
