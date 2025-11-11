//
//  NetworkManagerMock.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 4/2/25.
//
import Combine
import Foundation

class NetworkManagerMock: NetworkManagerProtocol {
    
    private let shouldFail: Bool
    private let errorToThrow: NetworkError?

    init(shouldFail: Bool = false, errorToThrow: NetworkError? = nil) {
        self.shouldFail = shouldFail
        self.errorToThrow = errorToThrow
    }
    
    func fetch<T>(_ url: URL, _ decodeStrategy: JSONDecoder.KeyDecodingStrategy?) -> AnyPublisher<T, NetworkError> where T : Decodable {
        return Future<T, NetworkError> { promise in
            DispatchQueue.global(qos: .background).async {
                if self.shouldFail, let testError = self.errorToThrow {
                    return promise(.failure(testError))
                }
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
                    promise(.failure(.decodingError(underlying: NetworkError.badResponse(statusCode: 6969))))
                    print(error)
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
