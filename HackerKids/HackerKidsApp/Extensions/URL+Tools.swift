//
//  URL+Tools.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 4/12/25.
//
import UIKit
import Foundation

extension URL {
    func loadImage(completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.main.async {
            guard let data = try? Data(contentsOf: self),
                  let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
    func fetchImageData() async throws -> Data? {
        do {
            let (data, response) = try await URLSession.shared.data(from: self)
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                return nil
            }
            return data
        } catch let error {
            return nil
        }
    }
}
