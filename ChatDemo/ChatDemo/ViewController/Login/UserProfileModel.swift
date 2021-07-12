//
//  UserProfileModel.swift
//  FirebaseChat
//
//  Created by Amit Chauhan on 22/04/20.
//  Copyright © 2020 Amit Chauhan. All rights reserved.
//

import Foundation

struct UserProfileModel: Codable {
    let uid : String?
    let email : String?
    let displayName : String?
    let photoURL: URL?
    
    enum CodingKeys: String, CodingKey {
        case uid = "uid"
        case email = "email"
        case displayName = "displayName"
        case photoURL = "photoURL"
    }
}
