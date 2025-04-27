//
//  Color.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 4/26/25.
//
import SwiftUI
import Foundation

extension Color {
    var light: Self {
        var environment = EnvironmentValues()
        environment.colorScheme = .light
        return Color(resolve(in: environment))
    }

    var dark: Self {
        var environment = EnvironmentValues()
        environment.colorScheme = .dark
        return Color(resolve(in: environment))
    }
}
