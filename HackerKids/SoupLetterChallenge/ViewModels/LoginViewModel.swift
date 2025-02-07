//
//  File.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 2/2/25.
//

import GoogleSignIn
import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var player: PlayerUser?
    @Published var userSession: Bool = false
    @Published var playerImg: Image?
    @Published var googleSignIn: Bool = false

    func startLogin() {
        if let localPlayer = readLocalData(){
            self.player = localPlayer
            createSession()
            userSession = true
        }
    }
    func readLocalData() -> PlayerUser? {
        return PlayerUser(id: "12334555", name: "Roberto Abad", email: "roberto.rmzabad@gmail.com", password: "********", picture: nil)
    }
    func createSession() {
        self.playerImg = player?.getPlayerImage()
    }
    func signOff() {
        player = nil
        userSession = false
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
