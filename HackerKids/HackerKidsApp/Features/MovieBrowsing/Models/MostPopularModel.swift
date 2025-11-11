//
//  MostPopularModel.swift
//  MovieBrowserApp
//
//  Created by Roberto Ramirez on 10/11/25.
//

import Foundation

struct MostPopularModel: Codable {
    let page: Int?
    let results: [MovieModel]?
    let totalPages: Int?
    let totalResults: Int?
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
struct MovieModel: Codable {
    let adult: Bool?
    let backdropPath: String?
    let genreIds: [Int]?
    let id: Int?
    let originalTitle: String?
    let overview: String?
    let releaseDate: String?
    let voteAverage: Double?
    let voteCount: Int?
    let posterPath: String?
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIds = "genre_ids"
        case id
        case originalTitle = "original_title"
        case overview
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case posterPath = "poster_path"
    }
    
    func getPosterURL() -> URL {
        let baseURL = "https://image.tmdb.org/t/p/w500"
        return URL(string: baseURL + (posterPath ?? ""))!
    }
    func getBackdropURL() -> URL {
        let baseURL = "https://image.tmdb.org/t/p/w780"
        return URL(string: baseURL + (backdropPath ?? ""))!
    }
}
