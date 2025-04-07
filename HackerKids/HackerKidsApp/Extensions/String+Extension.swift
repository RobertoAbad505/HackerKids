//
//  String+Extension.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 4/7/25.
//

extension String {
    func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
      self = self.capitalizingFirstLetter()
    }
}
