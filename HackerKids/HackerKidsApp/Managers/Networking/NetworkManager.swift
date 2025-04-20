//
//  NetworkManager.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 4/2/25.
//
import Combine
import Foundation

class NetworkManager: NetworkManagerProtocol {
    private var responseCache: [URL: Data] = [:]
    private let lock = NSLock()


    func fetch<T>(_ url: URL, _ decodeStrategy: JSONDecoder.KeyDecodingStrategy?) -> AnyPublisher<T, NetworkError> where T : Decodable {
        let cacheKey = url.absoluteString
        let decoder = JSONDecoder()
        if let strategy = decodeStrategy {
            decoder.keyDecodingStrategy = strategy
        }
        // Verifica cache primero
        if let cachedData = ResponseCacheManager.shared.get(forKey: cacheKey) {
            print("Response from cache for \(url.absoluteString)")
            return Just(cachedData)
                .decode(type: T.self, decoder: decoder)
                .mapError { NetworkError.decodingError(underlying: $0) }
                .eraseToAnyPublisher()
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

    private func decodePublisher<T: Decodable>(from data: Data, strategy: JSONDecoder.KeyDecodingStrategy?) -> AnyPublisher<T, NetworkError> {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = strategy ?? .useDefaultKeys
        return Just(data)
            .decode(type: T.self, decoder: decoder)
            .mapError { .decodingError(underlying: $0) }
            .eraseToAnyPublisher()
    }

    private func cache(data: Data, for url: URL) {
        lock.lock()
        defer { lock.unlock() }
        responseCache[url] = data
    }

    private func getCachedData(for url: URL) -> Data? {
        lock.lock()
        defer { lock.unlock() }
        return responseCache[url]
    }
}

