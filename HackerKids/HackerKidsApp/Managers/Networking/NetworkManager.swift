//
//  NetworkManager.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 4/2/25.
//
import Combine
import Foundation

class NetworkManager: NetworkManagerProtocol {
    func fetch<T>(_ url: URL, _ decodeStrategy: JSONDecoder.KeyDecodingStrategy?) -> AnyPublisher<T, NetworkError> where T : Decodable {
        let decoder = JSONDecoder()
        if let strategy = decodeStrategy {
            decoder.keyDecodingStrategy = strategy
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.unknown(underlying: URLError(.badServerResponse))
                }
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    throw NetworkError.badResponse(statusCode: httpResponse.statusCode)
                }
                print("Response:\n\(String(decoding: data, as: UTF8.self))")
                return data
            }
            .decode(type: T.self, decoder: decoder)
            .mapError { error in
                if let urlError = error as? URLError {
                    if urlError.code == .notConnectedToInternet {
                        return NetworkError.noInternetConnection
                    }
                }
                if let decodingError = error as? DecodingError {
                    return NetworkError.decodingError(underlying: decodingError)
                }
                return NetworkError.unknown(underlying: error)
            }
            .eraseToAnyPublisher()
    }
}

