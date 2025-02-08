//
//  LocalUser.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 2/7/25.
//

import Foundation
import SwiftData

@Model
final class LocalUser {
    var id: String?
    var userName: String
    var email: String
    var signInType: SignOnType
    var picture: Data?
    init(id: String? = nil, userName: String, email: String, signInType: SignOnType = .account, picture: Data? = nil) {
        self.id = id
        self.userName = userName
        self.email = email
        self.signInType = signInType
        self.picture = picture
    }
}
