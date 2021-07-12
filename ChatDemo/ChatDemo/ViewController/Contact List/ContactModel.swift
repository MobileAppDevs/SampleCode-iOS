//
//  ContactModel.swift
//  ChatDemo
//
//  Created by Amit Chauhan on 27/04/20.
//  Copyright © 2020 Amit Chauhan. All rights reserved.
//

struct Contact {
    var name : String?
    var email: String?
    var number: String?
    var firstLetter : String?
    var countryCode : String?


    init() {
    }

    init(with json: [String: Any]) {
        self.name = json["name"] as? String
        self.email = json["email"] as? String
        self.number = json["number"] as? String
        self.firstLetter = json["firstLetter"] as? String
        self.countryCode = json["countryCode"] as? String

    }
    
    var toDictinoary : [ String : Any] {
        var dict = [String : Any]()
        dict["name"] = name
        dict["email"] = email
        dict["number"] = number
        dict["firstLetter"] = firstLetter
        dict["countryCode"] = countryCode

        return dict
    }
}
