//
//  Bundle+Localization.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 11/16/25.
//

import Foundation

private var bundleKey: UInt8 = 0

class LocalizedBundle: Bundle {
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        return super.localizedString(forKey: key, value: value, table: tableName)
    }
}

extension Bundle {
    static var localized: Bundle = .main
    
    static func setLanguage(_ lang: String) {
        guard let path = Bundle.main.path(forResource: lang, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            localized = .main
            return
        }
        localized = bundle
    }
}
