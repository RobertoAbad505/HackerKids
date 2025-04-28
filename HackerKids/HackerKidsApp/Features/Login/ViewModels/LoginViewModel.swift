//
//  File.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 2/2/25.
//
import GoogleSignIn
import SwiftUI
import SwiftData
import Combine

class LoginViewModel: ObservableObject {
    //form variables
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var player: PlayerUser?
    
    //control variables
    @Published var userSession: Bool = false
    @Published var playerImg: Image?
    @Published var googleSignIn: Bool = false
    @Published var googleResult: GIDSignInResult?
    
    //func related to LoginView only
    func startLoginView(_ modelContext: ModelContext) {
        guard let userDefault = SessionManager.shared.signedInUser else {
            print("No local/signed in user")
            return
        }
        self.player = userDefault.getPlayerBadge()
        self.userSession = true
    }
    func createUserAccount(_ modelContext: ModelContext, _ player: PlayerUser) {
        self.player = player
        //START SESSION FOR THIS USER & SET PERSITANCE
        SessionManager.shared.signIn(modelContext, user: player)
        self.playerImg = player.getPlayerImage()
        self.userSession = true
    }
    func signOff(_ modelContext: ModelContext) {
        player = nil
        userSession = false
        
        //google signOff
        if googleSignIn {
            GIDSignIn.sharedInstance.signOut()
            googleResult = nil
            googleSignIn = false
        }
        
        //UserPersistance signOff
        SessionManager.shared.signOff(modelContext)
    }
    func successGoogleSignIn(_ googleUser: GIDGoogleUser,_ modelContext: ModelContext) {
        //Get GOOGLE image
        guard let imageURL = googleUser.profile?.imageURL(withDimension: 350) else { return }
        Task {
            do {
                if let imageData = try await imageURL.fetchImageData(),
                    let uiImage = UIImage(data: imageData) {
                    //Convert GoogleData to UserLocal
                    if let newPlayer = PlayerUser(googleUser: googleUser, imageData) {
                        await MainActor.run {
                            self.playerImg = Image(uiImage: uiImage)
                            self.player = newPlayer
                            SessionManager.shared.signIn(modelContext, user: newPlayer)
                            self.userSession = true
                            self.googleSignIn = true
                        }
                    }
                }
            } catch let error {
                print("Error recovering Google signIn: \(error)")
            }
        }
    }
}
