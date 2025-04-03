//
//  SessionManager.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 2/7/25.
//

import SwiftUI
import SwiftData
import Foundation

final class SessionManager {
    var signedInUser: LocalUser?
    private var blankUser: LocalUser = LocalUser(userName: "Invited",
                                                    email: "Player 1")
    static let shared: SessionManager = .init()
    private init() {}
    
    func fetchLastSession(_ modelContext: ModelContext) {
        let persistentUserSigned = SwiftDataManager.shared.fetchOrCreate(modelContext, defaultValue: blankUser)
        if blankUser.email != persistentUserSigned.email {
            self.signedInUser = persistentUserSigned
        }
        if signedInUser == nil {
            self.signedInUser = blankUser
        }
    }
    func signIn(_ modelContext: ModelContext, user: PlayerUser) {
        withAnimation {
            let newUserDefault = LocalUser(userName: user.name,
                                           email: user.email,
                                           picture: user.picture
            )
            self.signedInUser = SwiftDataManager.shared.create(modelContext,
                                                               newUserDefault)
        }
    }
    func signOff(_ modelContext: ModelContext) {
        guard let signedInUser = self.signedInUser else {
            return
        }
        withAnimation {
            SwiftDataManager.shared.delete(modelContext, signedInUser)
        }
    }
    func getCurrentUser() -> LocalUser {
        return signedInUser ?? blankUser
    }
}
