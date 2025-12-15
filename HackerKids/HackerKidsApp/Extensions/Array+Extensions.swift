//
//  Array+Extensions.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 12/14/25.
//

import Foundation

extension Array where Element == String {
    func mostCommon() -> String {
        Dictionary(grouping: self, by: { $0 })
            .max { $0.value.count < $1.value.count }?
            .key ?? ""
    }
}
