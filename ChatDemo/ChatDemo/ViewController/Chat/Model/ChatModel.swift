//
//  ChatModel.swift
//  FirebaseChat
//
//  Created by Amit Chauhan on 22/04/20.
//  Copyright © 2020 Amit Chauhan. All rights reserved.
//

import UIKit
import Foundation

enum CellType {
    case my
    case friend
}

public enum MessageType : String {
    case text = "text"
    case image = "image"
    case video = "video"
    case location = "location"
    case contact = "contact"
}

class Message : NSObject {
    var sender_id : String?
    var receiver_id : String?
    var text : String?
    var time : Double?
    //adding
    var type : MessageType?
    var cellType : CellType?
    var isRead : Bool?

    var ImageURL : String?
    var latitude : Double?
    var longitude : Double?

    override init() {
        
    }
    
    
    init(with json: [String: Any]) {
        self.sender_id = json["sender_id"] as? String
        let mType = json["type"] as? String
        self.type = MessageType.init(rawValue: mType ?? "")
        self.text = json["text"] as? String
        self.time = json["time"] as? Double
        self.receiver_id = json["receiver_id"] as? String
        self.isRead = json["isRead"] as? Bool
        self.ImageURL = json["ImageURL"] as? String
        self.latitude = json["latitude"] as? Double
        self.longitude = json["longitude"] as? Double

        if let myUserId = UserDefaultManager.sharedInstance.getUserProfileModel()?.uid{
            if self.sender_id == myUserId{
                self.cellType = .my
            }else{
                self.cellType = .friend
            }
        }
    }
    
    
    var toDict : [String : Any] {
        var dict = [String : Any]()
        
        dict["sender_id"] = sender_id
        dict["receiver_id"] = receiver_id
        dict["text"] = text
        dict["time"] = time
        dict["type"] = type?.rawValue
        dict["isRead"] = isRead
        dict["ImageURL"] = ImageURL
        dict["latitude"] = latitude
        dict["longitude"] = longitude

        return dict
    }
}


struct RecentMessage {
    var text : String?
    var type : MessageType?

    var time : Double?
    var unreadCount : UnreadCount?
    var user : User?
    
    
    init() {
        self.unreadCount = UnreadCount.init()
        self.user = User.init()
    }
    
    init(with json: [String:Any]) {
        self.text = json["text"] as? String
        let mType = json["type"] as? String
        self.type = MessageType.init(rawValue: mType ?? "")
        self.time = json["time"] as? Double
        if let dict = json["unreadCount"] as? [String:Any] {
            self.unreadCount = UnreadCount.init(with: dict)
        }
        if let dict = json["user"] as? [String:Any] {
            self.user = User.init(with: dict)
        }
    }
    
    var toDictinoary : [ String : Any] {
        var dict = [String : Any]()
        
        dict["text"] = text
        dict["type"] = type?.rawValue

        dict["time"] = time
        dict["unreadCount"] = unreadCount?.toDictinoary
        dict["user"] = user?.toDictinoary

        return dict
    }
}

struct UnreadCount {
    var count : Int?
    var userID: String?
    init() {
    }

    init(with json: [String: Any]) {
        self.count = json["count"] as? Int
        self.userID = json["userID"] as? String
    }
    
    var toDictinoary : [ String : Any] {
        var dict = [String : Any]()
        dict["count"] = count
        dict["userID"] = userID
        return dict
    }
}

struct User {
    var name : String?
    var id: String?
    var image: String?
    var email : String?
    
    var isOnline : Int?
    init() {
    }

    init(with json: [String: Any]) {
        self.name = json["name"] as? String
        self.id = json["id"] as? String
        self.image = json["image"] as? String
        self.isOnline = json["isOnline"] as? Int
        self.email = json["email"] as? String
    }
    
    var toDictinoary : [ String : Any] {
        var dict = [String : Any]()
        dict["name"] = name
        dict["id"] = id
        dict["image"] = image
        dict["isOnline"] = isOnline
        dict["email"] = email
        return dict
    }
}

