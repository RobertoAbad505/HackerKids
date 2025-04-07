//
//  PlayerUser.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 2/2/25.
//
import GoogleSignIn
import SwiftUI
import Foundation

struct PlayerUser: Identifiable, Codable {
    var id: String
    var name: String
    var email: String
    var password: String
    var picture: Data?
    var hasImage: Bool?
    var signOnType: SignOnType? = .account
    
    init(id: String, name: String, email: String, password: String, picture: Data? = nil) {
        self.id = id
        self.name = name
        self.email = email
        self.password = password
        self.picture = picture
    }
    init?(googleResult: GIDSignInResult?) {
        if let result = googleResult {
            self.id = result.user.userID ?? ""
            self.email = result.user.profile?.email ?? ""
            self.name = result.user.profile?.name ?? ""
            self.password = ""
            self.hasImage = result.user.profile?.hasImage ?? false
            self.signOnType = .google
//            self.picture = getPlayerImage(googleResult)
        } else {
            return nil
        }
    }
    init?(_ localUser: LocalUser) {
        if !localUser.email.isEmpty {
            self.id = localUser.email
            self.email = localUser.email
            self.name = localUser.email
            self.password = ""
            self.hasImage = false
            self.signOnType = .account
        } else {
            return nil
        }
    }
    
    func getPlayerImage() -> Image {
        if let pictureData = picture?.createImage() {
            return pictureData
        }
        return Image(systemName: "person")
    }
}
enum SignOnType: String, Codable {
    case google
    case account
}
