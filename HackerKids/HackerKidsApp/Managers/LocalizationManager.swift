//
//  LocalizationManager.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 11/16/25.
//

import Foundation
import SwiftUI
import Foundation
import Combine

enum AppLanguage: String, CaseIterable {
    case english = "en"
    case spanish = "es"

    var code: String { rawValue }
}

final class LocalizationManager: ObservableObject {

    static let shared = LocalizationManager()

    @Published private(set) var currentLanguage: AppLanguage = .english
    private var bundle: Bundle = .main

    private let userDefaultsKey = "selectedLanguage"

    private init() {
        // Load stored language OR default to device language
        if let stored = UserDefaults.standard.string(forKey: userDefaultsKey),
           let lang = AppLanguage(rawValue: stored) {
            currentLanguage = lang
        } else {
            // Get device preferred language (first component)
            let deviceCode = Locale.preferredLanguages.first?.prefix(2) ?? "en"
            currentLanguage = AppLanguage(rawValue: String(deviceCode)) ?? .english
        }

        loadBundle(for: currentLanguage)
    }

    // MARK: - Public API

    func changeLanguage(_ language: AppLanguage) {
        guard language != currentLanguage else { return }
        currentLanguage = language
        UserDefaults.standard.set(language.code, forKey: userDefaultsKey)

        loadBundle(for: language)
        objectWillChange.send()   // force SwiftUI view refresh
    }

    func localized(_ key: String) -> String {
        let localizedString = bundle.localizedString(forKey: key, value: nil, table: nil)

        // If the system returns the *same key*, it means it was not found
        if localizedString == key {
            return key   // fallback to plain text
        }

        return localizedString
    }

    // MARK: - Bundle Loader

    private func loadBundle(for language: AppLanguage) {
        if let path = Bundle.main.path(forResource: language.code, ofType: "lproj"),
           let langBundle = Bundle(path: path) {
            bundle = langBundle
        } else {
            bundle = .main // fallback
        }
    }
}


