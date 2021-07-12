//
//  FBDBManager.swift
//  FirebaseChat
//
//  Created by Amit Chauhan on 21/04/20.
//  Copyright © 2020 Amit Chauhan. All rights reserved.
//

import UIKit
import Foundation
import FirebaseDatabase

let DBRefence : DatabaseReference = Database.database().reference()

final class FBDBManager {
    //    var handleRecent : DatabaseHandle? = nil
    var handleRecent: DatabaseHandle?
    static var shared : FBDBManager = FBDBManager()
    let USER_NODE : String  = ""
    private var arrRecentChatMsg : [RecentMessage]?
    let userModel = UserDefaultManager.sharedInstance.getUserProfileModel()
    lazy var myUserId = userModel?.uid ?? ""
    
    enum Reference  {
        case message
        case recentMessage
        case user
        
        var getDBRef : DatabaseReference {
            switch self {
            case .message:
                return DBRefence.child("MESSAGE")
            case .recentMessage:
                return DBRefence.child("RECENT_MESSAGE_LIST")
            case .user:
                return DBRefence.child("USER_LIST")
            }
        }
    }
    
    private func getOtherUserIDFrom(_ nodeKey:String) -> String {
        var arrUserID = nodeKey.components(separatedBy: "_")
        if let index = arrUserID.firstIndex(of: myUserId) {
            arrUserID.remove(at: index)
        }
        let otherUserid = arrUserID.last
        return otherUserid ?? ""

    }
    
    func makeNodeKey(sender:String,rec:String)-> String {
        return "\(sender)_\(rec)"
    }
    
    func createMessage(senderId : String, recId : String, text : String, type: MessageType, ImageURL : String, lat: Double, long : Double) -> (Message , RecentMessage){
        let data = Message()
        data.receiver_id = recId
        data.sender_id = senderId
        data.text = text
        data.type = type
        data.ImageURL = ImageURL
        data.latitude = lat
        data.longitude = long
        
        let time =  FunctionConstants.getInstance().GetCurrentTimeStamp()
        data.time = time
        var recentMessage = RecentMessage()
        recentMessage.text = text
        recentMessage.type = type
        recentMessage.time = time
        return (data, recentMessage)
    }
    
    func sendMessages(senderId: String, recId: String, text: String, type: MessageType, imageURL : String, latitude : Double, longitude : Double) {
        
        let tuple = self.createMessage(senderId: senderId, recId: recId, text: text, type: type, ImageURL: imageURL, lat: latitude, long: longitude)
        
        self.checkNodeExistOrNot(senderId: senderId, recId: recId, dbRef: Reference.message) { (nodeID, nodeExist, snapShotValue) in
            let message = tuple.0
            self.updateChatMessageWith(nodeId: nodeID!, chatMessage: message)
        }
        self.checkNodeExistOrNot(senderId: senderId, recId: recId, dbRef: Reference.recentMessage) { (nodeID, nodeExist, snapShotValue) in
            var rMessage = tuple.1
            if nodeExist {
                self.getSingleRecentMsgWith(nodeID: nodeID!, completion: { (message) in
                    debugPrint("message >>", message)
                    if let unreadCnt = message.unreadCount {
                        let count = (unreadCnt.count ?? 0) + 1
                        rMessage.unreadCount?.count = count
                        rMessage.unreadCount?.userID = recId
                        self.updateRecentMessageNode(nodeId: nodeID!, recentMsg: rMessage)
                    }
                })
            } else {
                rMessage.unreadCount?.count = 1
                rMessage.unreadCount?.userID = recId
                self.updateRecentMessageNode(nodeId: nodeID!, recentMsg: rMessage)
            }
        }
    }
    
    func getSingleRecentMsgWith(nodeID: String, completion:@escaping (_ data: RecentMessage) -> Void){
        Reference.recentMessage.getDBRef.child(nodeID).observeSingleEvent(of: .value) { (snap) in
            if let dict = snap.value as? [String : Any] {
                let recenMsg = RecentMessage.init(with: dict)
                completion(recenMsg)
            }
        }
    }
    
    func checkNodeExistOrNot(senderId: String, recId: String, dbRef : Reference, completion:@escaping ( _ nodeId: String?, _ exist: Bool,_ value : [String:Any]?) -> Void) {
        
        let nodeId = self.makeNodeKey(sender: senderId, rec: recId)
        
        dbRef.getDBRef.child(nodeId).observeSingleEvent(of: .value) { (snapShot) in
            if snapShot.exists() {
                
                completion(nodeId, true, snapShot.value as? [String:Any])
            } else {
                let nodeId = self.makeNodeKey(sender: recId , rec: senderId)
                dbRef.getDBRef.child(nodeId).observeSingleEvent(of: .value) { (snapShot) in
                    if snapShot.exists() {
                        completion(nodeId, true,snapShot.value as? [String:Any])
                    } else {
                        completion(nodeId, false,nil)
                    }
                }
            }
        }
    }
    
    func updateChatMessageWith(nodeId:String , chatMessage: Message) {
        Reference.message.getDBRef.child(nodeId).childByAutoId().updateChildValues(chatMessage.toDict) { (error, dbRef) in
            if error == nil{
                debugPrint(dbRef)
            }
        }
    }
    
    func getAllChatMessage(senderId: String, recId: String, completion:@escaping (_ data: [Message]?) -> Void){
        self.checkNodeExistOrNot(senderId: senderId, recId: recId, dbRef: Reference.message) { (nodeId, nodeExist, snapShotValue) in
            
            Reference.message.getDBRef.child(nodeId!).observe(.value) { (snap) in
                //                debugPrint("getting all message",snap)
                
                
                
                if let dict = snap.value as? [String : Any]{
                    var newItems: [Message] = []
                    for (key, value) in dict{
                        debugPrint(value)
                        debugPrint(key)
                        
                        if let tempDict = value as? [String : Any]{
                            //                            let item = Message()
                            
                            let item = Message.init(with: tempDict)
                            
                            //                            item.receiver_id = tempDict["receiver_id"] as? String
                            //                            item.sender_id = tempDict["sender_id"] as? String
                            //                            item.text = tempDict["text"] as? String
                            //                            item.time = tempDict["time"] as? Double
                            newItems.append(item)
                        }
                    }
                    
                    
                    newItems = newItems.sorted(by: { (first, second) -> Bool in
                        if first.time! < second.time!{
                            return true
                        }else{
                            return false
                        }
                    })
                    completion(newItems)
                }else{
                    completion([Message]())
                }
            }
        }
    }
    
    func disconnectAllObserver(){
        Reference.message.getDBRef.removeAllObservers()
    }
    
    
    //MARK :- check Recent Message list..
    func updateRecentMessageNode(nodeId:String, recentMsg : RecentMessage) {
        Reference.recentMessage.getDBRef.child(nodeId).updateChildValues(recentMsg.toDictinoary) { (error, dbRef) in
            if error == nil{
                debugPrint("update recent msg >>>", dbRef)
            }
        }
    }
    
    func getAllRecentChatMessage(senderId: String, completion: ((_ data: [RecentMessage]?) -> Void)?){
        
        Reference.recentMessage.getDBRef.observe(.value) { (snapshot) in
            if let dict = snapshot.value as? [String : Any] {
                if dict.keys.count > 0 {
                    self.arrRecentChatMsg = [RecentMessage]()
                    var arr = [[String:Any]]()
                    for (key, value) in dict {
                        //                        debugPrint(value)
                        //                        debugPrint(key)
                        
                        if key.contains(senderId) {
                            if let tempDict = value as? [String : Any] {
                                let newDict : [String:Any] = [key:tempDict]
                                arr.append(newDict)
                            }
                        }
                    }
                    self.makeRecentChatMsgArr(with:arr , completion: { (arrRecentMsg) in
                        self.arrRecentChatMsg = nil
                        print("ARRRECENTCHAT : \(arrRecentMsg)")
                        if var arrRecentMessages = arrRecentMsg {
                            arrRecentMessages = arrRecentMessages.sorted(by: { (first, second) -> Bool in
                                if first.time! > second.time!{
                                    return true
                                } else {
                                    return false
                                }
                            })
                            completion?(arrRecentMessages)
                        }
                    })
                }
            }else{
                completion?([RecentMessage]())
            }
            
        }
        
        
        //        Reference.recentMessage.getDBRef.observeSingleEvent(of: .value) { (snapshot, text) in
        //                   }
    }
    
    
    private func makeRecentChatMsgArr(with arr : [[String:Any]] , completion: @escaping([RecentMessage]?)->Void) {
        let myGroup = DispatchGroup()
        var arrToReturn = [RecentMessage]()
        
        for dict in arr {
            myGroup.enter()
            var item = RecentMessage()
            var nodeKey  = ""
            for (key , val) in dict {
                var unreadCou = UnreadCount()
                if let tempDict = val as? [String:Any] {
                    item.text = tempDict["text"] as? String
                    let mType = tempDict["type"] as? String
                    item.type = MessageType.init(rawValue: mType ?? "")

                    item.time = tempDict["time"] as? Double
                                        
                    if let unreadCount = tempDict["unreadCount"] as? [String : Any]{
                        unreadCou.count = unreadCount["count"] as? Int
                        unreadCou.userID = unreadCount["userID"] as? String
                        item.unreadCount = unreadCou
                    }
                    nodeKey = key
                }
            }
            
            let otherUserid = self.getOtherUserIDFrom(nodeKey)
            self.getuserWith(uid: otherUserid, completion: { (user) in
                item.user = user
                arrToReturn.append(item)
                myGroup.leave()
            })
        }
        
        myGroup.notify(queue: .main) {
            print("Finished all requests.")
            completion(arrToReturn)
        }
    }
    
    
    //MARK :- check User list..
    func registerAndUpdateUserList(userId : String?, userName : String?, picURL : String?, email : String?, isOnline:Int = 0) {
        var userData = User()
        userData.id = userId
        userData.name = userName
        userData.image = picURL
        userData.email = email
        userData.isOnline = isOnline
        if userId != nil{
            Reference.user.getDBRef.child(userId!).updateChildValues(userData.toDictinoary) { (error, dbRef) in
                if error == nil{
                    debugPrint("other update user>>",dbRef)
                }
            }
        }
    }
    
    
    func getAllUser(completion:@escaping (_ data: [User]?) -> Void){
        
        Reference.user.getDBRef.observeSingleEvent(of: .value) { (snapshot) in
            
            var arrUser : [User]?
            if let dict = snapshot.value as? [String : Any] {
                if dict.keys.count > 0 {
                    arrUser = [User]()
                    
                    for (key, value) in dict {
                        debugPrint(value)
                        debugPrint(key)
                        if key.contains(UserDefaultManager.sharedInstance.getUserId()) {
                            // not aading
                        }else{
                            if let tempDict = value as? [String : Any] {
                                
                                let item = User.init(with: tempDict)
                                arrUser?.append(item)
                            }
                        }
                    }
                    completion(arrUser)
                }
            }else{
                completion([User]())
                
            }
        }
    }
    
    
    func getuserWith(uid: String, completion:@escaping (_ data: User?) -> Void){
        Reference.user.getDBRef.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            debugPrint("getting all user",snapshot)
            if let dict = snapshot.value as? [String : Any]{
                var newItems = User()
                newItems.id = dict["id"] as? String
                newItems.name = dict["name"] as? String
                newItems.image = dict["image"] as? String
                completion(newItems)
            }else{
                completion(User())
            }
        })
    }
    
    func observeOtherUser(uid: String, completion:@escaping (_ data: User?) -> Void){
        
        Reference.user.getDBRef.child(uid).observe(.value) { (snapshot) in
            debugPrint("getting all user",snapshot)
            if let dict = snapshot.value as? [String : Any]{
                let user = User.init(with: dict)
                completion(user)
            }else{
                completion(User())
            }
        }
    }
    
    
    func readAllMessagesFor(receiverId: String, isOnline: Int){
        self.checkNodeExistOrNot(senderId: myUserId, recId: receiverId, dbRef: .recentMessage) { (nodeKey, isExist, snapShotValue) in
            
            self.getuserWith(uid: self.myUserId) { (user) in
                self.registerAndUpdateUserList(userId: user?.id, userName: user?.name, picURL: user?.image, email: user?.email, isOnline: isOnline)
            }
            
            if isExist {
                if let value = snapShotValue {
                    var recentMsg = RecentMessage.init(with: value)
                    //                    recentMsg.unreadCount?.count = 0
                    
                    if (recentMsg.unreadCount?.userID ?? "") == self.myUserId {
                        recentMsg.unreadCount?.count = 0
                    }
                    self.updateRecentMessageNode(nodeId: nodeKey ?? "", recentMsg: recentMsg)
                }
            }
        }
    }
    
    //MARK:- to get all unread counts at every time value changes
    func getAllUnreadCount(senderId: String, tabbarObject : UITabBarController? , completion:@escaping ((Int)->Void)){
        //        if let handle = self.handleRecent{
        //            DBRefence.removeObserver(withHandle: handle)
        //        }
        //        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
        
        Reference.recentMessage.getDBRef.observe( .value) { (snapshot) in
            if let dict = snapshot.value as? [String : Any]{
                if dict.keys.count > 0 {
                    self.arrRecentChatMsg = [RecentMessage]()
                    var arr = [[String:Any]]()
                    for (key, value) in dict {
                        debugPrint(value)
                        debugPrint(key)
                        
                        if key.contains(senderId) {
                            if let tempDict = value as? [String : Any] {
                                let newDict : [String:Any] = [key:tempDict]
                                arr.append(newDict)
                            }
                        }
                    }
                    self.makeRecentChatMsgArr(with:arr , completion: { (arrRecentMsg) in
                        self.arrRecentChatMsg = nil
                        if let arrRecentMessages = arrRecentMsg {
                            let arrCount = arrRecentMessages.filter{($0.unreadCount?.userID ?? "") == self.myUserId}.compactMap{$0.unreadCount?.count}
                            let reducedVal = arrCount.reduce( 0,{$0+$1})
                            if reducedVal  > 0 {
                                tabbarObject?.tabBar.items?[0].badgeValue = "\(reducedVal)"
                            } else {
                                tabbarObject?.tabBar.items?[0].badgeValue = nil
                                
                            }
                            completion(0)
                        }
                    })
                }
            }else{
                completion(0)
            }
        }
        //        }
    }
    
    //MARK:- to get all unread counts at single shot (observing single event)
    func getAllUnreadCounts(senderId: String , completion:@escaping ((Int)->Void)){
        Reference.recentMessage.getDBRef.observeSingleEvent(of: .value) { (snapshot) in
            if let dict = snapshot.value as? [String : Any]{
                if dict.keys.count > 0 {
                    self.arrRecentChatMsg = [RecentMessage]()
                    var arr = [[String:Any]]()
                    for (key, value) in dict {
                        debugPrint(value)
                        debugPrint(key)
                        
                        if key.contains(senderId) {
                            if let tempDict = value as? [String : Any] {
                                let newDict : [String:Any] = [key:tempDict]
                                arr.append(newDict)
                            }
                        }
                    }
                    self.makeRecentChatMsgArr(with:arr, completion: { (arrRecentMsg) in
                        self.arrRecentChatMsg = nil
                        if let arrRecentMessages = arrRecentMsg {
                            let arrCount = arrRecentMessages.filter{($0.unreadCount?.userID ?? "") == self.myUserId}.compactMap{$0.unreadCount?.count}
                            let reducedVal = arrCount.reduce( 0,{$0+$1})
                            if reducedVal > 0 {
                                completion(reducedVal)
                            } else {
                                completion(0)
                            }
                        }
                    })
                }
                
            }else{
                completion(0)
            }
        }
    }
    
    //added now
    func createOrUpdateUserWith(userId:String, userImage: String, userName:String) {
        /*let user = User.init(name: userName, image: userImage)
         Reference.user.getDBRef.child(userId).updateChildValues(user.toDictinoary){(error, dbRef) in
         if error == nil{
         debugPrint(dbRef)
         }
         }*/
    }
    
    
    
    
    
    
}




