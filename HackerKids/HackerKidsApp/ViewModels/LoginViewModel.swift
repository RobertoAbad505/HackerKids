//
//  File.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 2/2/25.
//

import GoogleSignIn
import SwiftUI
import SwiftData

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var player: PlayerUser?
    @Published var userSession: Bool = false
    @Published var playerImg: Image?
    @Published var googleSignIn: Bool = false

    func startLogin(_ modelContext: ModelContext) {
        if let localPlayer = readLocalData(){
            self.player = localPlayer
            createSession(modelContext, localPlayer)
            userSession = true
        }
    }
    func readLocalData() -> PlayerUser? {
        let userDefault = SessionManager.shared.getCurrentUser()
        return PlayerUser(id: userDefault.id ?? UUID().uuidString,
                          name: userDefault.userName,
                          email: userDefault.email,
                          password: "********",
                          picture: userDefault.picture)
    }
    func createSession(_ modelContext: ModelContext, _ player: PlayerUser) {
        self.playerImg = player.getPlayerImage()
        let newSessionUser = LocalUser(userName: player.name,
                                   email: player.email,
                                       picture: player.picture
        )
        let user = SwiftDataManager.shared.create(modelContext, newSessionUser)
        self.player = PlayerUser(id: user.id ?? "", name: user.userName, email: user.email, password: "")
        self.userSession = true
    }
    func signOff(_ modelContext: ModelContext) {
        player = nil
        userSession = false
        SessionManager.shared.signOff(modelContext)
        if googleSignIn {
            GIDSignIn.sharedInstance.signOut()
        }
    }
    func handleGoogleSignIn() {
        guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else { return }

        GIDSignIn.sharedInstance.signIn(
            withPresenting: rootViewController
        ) { signInResult, error in
            if let error = error {
                print("Error al iniciar sesión:", error.localizedDescription)
                self.googleSignIn = false
                return
            }

            if let user = signInResult {
                self.player = PlayerUser(googleResult: signInResult)
                self.googleSignIn = true
                print("✅ Usuario autenticado: \(user.user.profile?.email ?? "No Email")")
            }
        }
    }
}
