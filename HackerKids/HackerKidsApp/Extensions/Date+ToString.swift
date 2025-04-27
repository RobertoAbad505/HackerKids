//
//  Date+ToString.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 4/26/25.
//

import Foundation

extension Date {
    
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "es_MX") // O "es_US", "en_US", depende del idioma que quieras
        formatter.dateFormat = "MMMM dd, yyyy, hh:mm a"
        let dateString = formatter.string(from: self)
        return dateString
    }
}
