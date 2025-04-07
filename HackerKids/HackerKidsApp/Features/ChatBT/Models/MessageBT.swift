//
//  MessageBT.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 3/28/25.
//

import Foundation

struct MessageBT: Hashable, Equatable {
    let id: UUID = UUID()
    var text: String
    var sender: BTMessageDirection = .tx
    let timestamp: String
    init(text: String, sender: BTMessageDirection) {
        self.text = text
        self.sender = sender
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm aa"
        timestamp = formatter.string(from: Date())
    }
}
enum BTMessageDirection {
    case tx
    case rx
}
