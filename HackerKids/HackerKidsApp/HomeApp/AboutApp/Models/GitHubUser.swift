//
//  GitHubUser.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 1/26/25.
//

import Foundation

struct GitHubUser: Codable {
    let login: String?
    let avatarUrl: String?
    let bio: String?
    let name: String?
    let location: String?
    let html_url: String?
}
