//
//  MoviesApiServices.swift
//  MovieBrowserApp
//
//  Created by Roberto Ramirez on 10/9/25.
//

import Foundation
import Combine

class MoviesApiServices {
    
    let lang = "language=en-US"
    let apiKey = "api_key=bf37f9a4b4c70dfd3cd0b33655fcec82"
    let baseUrl = "https://api.themoviedb.org/3/"
    
    //endpoints
    let mostPopular = "movie/popular?"
    
    
    //async calls
    func fetchMostPopularMoviesAsync(_ page: Int) async throws -> MostPopularModel {
        guard let url = URL(string: "\(baseUrl)\(mostPopular)\(apiKey)&\(lang)&page=1") else {
            print("URL error at MostPopularMovies")
            throw URLError(.badServerResponse)
        }
        print("Fetching most popular movies: \(url)")
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse,
                    (200...299).contains(httpResponse.statusCode) else {
                //error throw
                throw URLError(.badServerResponse)
            }
            // Convert to a string and print
            if let JSONString = String(data: data, encoding: String.Encoding.utf8) {
               print(JSONString)
            }
            
            let decoder = JSONDecoder()
            return try decoder.decode(MostPopularModel.self, from: data)
        } catch let error {
            print(error.localizedDescription)
            throw URLError(.badServerResponse)
        }
    }
    
    //combine calls
    func fetchNextPage(_ page: Int) -> AnyPublisher<MostPopularModel, Error> {
        let url = URL(string: "\(baseUrl)\(mostPopular)\(apiKey)&\(lang)&page=\(page)")!
//        guard let url = URL(string: "\(baseUrl)\(mostPopular)\(apiKey)&\(lang)&page=\(page)")! else {
//            print("Url error at fetching next page")
//            throw URLError(.badURL)
//        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { (data, response) in
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                // Convert to a string and print
                if let JSONString = String(data: data, encoding: String.Encoding.utf8) {
                   print(JSONString)
                }
                return data
            }
            .decode(type: MostPopularModel.self, decoder: JSONDecoder())
            .map { $0 }
            .eraseToAnyPublisher()
    }
    
    //App based pattern request
    private var network: NetworkManagerProtocol {
        #if ISDEBUG
        return NetworkManagerMock()
        #else
        return NetworkManager()
        #endif
    }
    func fetchMoviesPage(_ page: Int) -> AnyPublisher<MostPopularModel, NetworkError> {
        let url = URL(string: "\(baseUrl)\(mostPopular)\(apiKey)&\(lang)&page=\(page)")!
        return network.fetch<MostPopularModel>(url)
    }
}
