//
//  NetworkManagerMock.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 4/2/25.
//
import Combine
import Foundation

class NetworkManagerMock: NetworkManagerProtocol {
    func fetch<T>(_ url: URL, _ decodeStrategy: JSONDecoder.KeyDecodingStrategy?) -> AnyPublisher<T, NetworkError> where T : Decodable {
        return Future<T, NetworkError> { promise in
            DispatchQueue.global(qos: .background).async {
                do {
                    guard let filename = URLMapper.shared.filename(for: url),
                          let fileURL = Bundle.main.url(forResource: filename,
                                                        withExtension: "json") else {
                        return promise(.failure(.invalidURL))
                    }
                    let data = try Data(contentsOf: fileURL)
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = decodeStrategy ?? .useDefaultKeys
                    let decoded = try decoder.decode(T.self, from: data)
                    promise(.success(decoded))
                } catch let error {
                    print(error)
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
