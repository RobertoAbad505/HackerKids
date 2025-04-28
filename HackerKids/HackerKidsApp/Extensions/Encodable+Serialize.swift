//
//  Encodable+Serialize.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 4/27/25.
//

import Foundation

extension Encodable {

    /// Converting object to postable dictionary
    func toJSON(_ encoder: JSONEncoder = JSONEncoder()) -> String {
        print("🔎INSPECT JSON:")
        do {
            encoder.outputFormatting = [.prettyPrinted]
            let jsonData = try encoder.encode(self)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print(jsonString)
                return jsonString
            }
        } catch let error {
            print("❌Error decoding JSON: \(error)")
        }
        return ""
    }
}
