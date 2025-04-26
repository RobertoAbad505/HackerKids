//
//  Double+FormatString.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 4/26/25.
//

import Foundation

extension Double {
    var toStringRounded: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
