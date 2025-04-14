//
//  URLMapper.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 4/13/25.
//
import Foundation

final class URLMapper {
    static let shared = URLMapper()

    private var map: URLMapping = .init(mapping: [:])

    private init() {
        self.loadMapping()
    }

    private func loadMapping() {
        if let url = Bundle.main.url(forResource: "urlMapping", withExtension: "json"),
           let data = try? Data(contentsOf: url) {
            do {
                let mapping = try JSONDecoder().decode(URLMapping.self, from: data)
                self.map = mapping
            } catch let error  {
                if let decodingError = error as? DecodingError {
                    print("❌ Failed to decode URL mapping: \(decodingError)")
                }
                print("❌ Failed to load URL mapping: \(error)")
                return
             }
        } else {
            print("❌ Failed to load URL mapping.")
            return
        }
    }

    /// Devuelve el nombre del archivo JSON mapeado para una URL dada
    func filename(for url: URL) -> String? {
        guard let fullName = map.mapping[url.strippedBaseURL] else {
            return nil
        }
        return (fullName as NSString).deletingPathExtension
    }
}
struct URLMapping: Decodable {
    let mapping: [String: String]
}
