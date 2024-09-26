//
//  Item.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 9/25/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
