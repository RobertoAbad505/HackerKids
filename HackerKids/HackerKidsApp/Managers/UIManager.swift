//
//  UIManager.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 2/7/25.
//

import SwiftUI
import Foundation

final class UIManager {
    static let shared: UIManager = UIManager()
    private init() {} //Singleton patter
    let backgroundGradient: LinearGradient = LinearGradient(
        gradient: Gradient(colors: [Color.blue, Color.purple]),
        startPoint: .leading,
        endPoint: .trailing
    )
}
