//
//  SessionManager.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 2/7/25.
//

import SwiftUI
import SwiftData
import Foundation

final class SessionManager: ObservableObject {
    static let shared = SessionManager()

    @Published var signedInUser: LocalUser? = nil
    @Published var sessionAlive: Bool = false

    private init() {}

    // MARK: - Fetch
    func fetchLastSession(_ context: ModelContext) {
        if let user = try? SwiftDataManager.shared.fetchLast(ofType: LocalUser.self, in: context) {
            signedInUser = user
            sessionAlive = true
        } else {
            signedInUser = nil
            sessionAlive = false
        }
    }
    func signIn(_ modelContext: ModelContext, user: PlayerUser) {
        let newUserDefault = LocalUser(userName: user.name,
                                       email: user.email,
                                       signInType: user.signOnType ?? .account,
                                       picture: user.picture)
        do {
            try SwiftDataManager.shared.insert(newUserDefault, in: modelContext)
            signedInUser = newUserDefault
            sessionAlive = true
        } catch let error {
            print("Error saving user: \(error)")
        }
    }
    func signOff(_ modelContext: ModelContext) {
        guard let signedInUser = self.signedInUser else {
            print("Error signing off, no user previously signed in")
            return
        }
        do {
            try SwiftDataManager.shared.deleteAll(LocalUser.self, in: modelContext)
            self.sessionAlive = false
            self.signedInUser = nil
        } catch let error {
            print("Error deleting user: \(error)")
        }
    }
}
