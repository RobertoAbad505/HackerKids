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
    var id: String?
    var name: String
    var email: String
    var picture: Data?
    var icon: Data?
    var hasImage: Bool?
    var signOnType: SignOnType? = .account
    
    init(id: String?, name: String, email: String, picture: Data? = nil, signOnType : SignOnType? = nil) {
        self.id = id
        self.name = name
        self.email = email
        self.picture = picture
        self.signOnType = signOnType ?? .account
    }
    init?(googleUser: GIDGoogleUser, _ pictureData: Data? = nil) {
        self.id = googleUser.userID ?? ""
        self.email = googleUser.profile?.email ?? ""
        self.name = googleUser.profile?.givenName  ?? ""
        self.hasImage = googleUser.profile?.hasImage ?? false
        self.signOnType = .google
        self.picture = pictureData
    }
    init?(_ localUser: LocalUser) {
        if !localUser.email.isEmpty {
            self.id = localUser.email
            self.email = localUser.email
            self.name = localUser.email
            self.hasImage = false
            self.picture = localUser.picture
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
