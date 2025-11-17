// LocalizationKeys.swift
// Defines safe, typed keys for localization.
//
//  Created by Roberto Ramirez on 11/16/25.
//

import Foundation

enum LangKey {
    enum StartView {
        static let appTitle = "app.title"
        static let portfolioDescription = "portfolio.pokemon.description"
    }

    enum GenericError {
        static let unexpected = "generic.error.unexpected"
        static let unknown = "generic.error.unknown"
        static let fetch = "generic.error.fetch"
    }

    enum Format {
        static let single = "format.single"
        static let two = "format.two"
        static let lf = "format.lf"
        static let lld = "format.lld"
        static let pounds = "format.pounds"
        static let inches = "format.inches"
        static let ratio = "format.ratio"
    }

    enum Action {
        static let ok = "action.ok"
        static let cancel = "action.cancel"
        static let retry = "action.retry"
        static let error = "action.error"
        static let done = "action.done"
        static let back = "action.back"
        static let confirm = "action.confirm"
    }

    enum Time {
        static let hour = "time.hour"
        static let minute = "time.minute"
        static let seconds = "time.seconds"
    }

    enum Weather {
        enum Permission {
            static let title = "weather.permission.title"
            static let message = "weather.permission.message"
        }
        enum Api {
            static let errorTitle = "weather.api.error.title"
            static let errorMessage = "weather.api.error.message"
        }
    }

    enum Game {
        static let player1Prompt = "game.player1.prompt"
        static let win = "game.win"
    }
}
// L10n.swift
struct L10n {

    static func tr(_ key: String, _ args: CVarArg...) -> String {
        let format = NSLocalizedString(key, comment: "")
        return String(format: format, locale: Locale.current, arguments: args)
    }
}


