//
//  NetworkProtocol.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 4/2/25.
//
import Combine
import Foundation

protocol NetworkManagerProtocol {
    func fetch<T: Decodable>(_ url: URL, _ decodeStrategy: JSONDecoder.KeyDecodingStrategy?) -> AnyPublisher<T, NetworkError>
}
extension NetworkManagerProtocol {
    func fetch<T: Decodable>(_ url: URL) -> AnyPublisher<T, NetworkError> {
        fetch(url, .useDefaultKeys)
    }
}
enum NetworkError: Error, LocalizedError {
    case noInternetConnection
    case timeout
    case invalidURL
    case badResponse(statusCode: Int)
    case decodingError(underlying: Error)
    case unknown(underlying: Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL is invalid."
        case .noInternetConnection:
            return "No internet connection. Please check your network settings."
        case .badResponse(let statusCode):
            return "Bad response from server (HTTP \(statusCode))."
        case .decodingError(let underlying):
            return "Failed to decode the response: \(underlying.localizedDescription)"
        case .unknown(let underlying):
            return "An unknown error occurred: \(underlying.localizedDescription)"
        case .timeout:
            return "Network request timed out."
        }
    }
}
