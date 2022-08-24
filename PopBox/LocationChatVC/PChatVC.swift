//
//  PChatVC.swift
//  Popbox
//
//  Created by Ongraph on 3/15/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit
import UIKit
import SocketIO
import Alamofire
import MediaPlayer
import Photos
import AVKit
import Kingfisher

class PChatVC: UIViewController {
        @IBOutlet weak var img_location: UIMaskViewImage!
        @IBOutlet weak var lbl_location: UILabel!
        @IBOutlet weak var lbl_peoples: UILabel!
        @IBOutlet weak var btn_fav: UIButton!
        
        @IBOutlet weak var viewChatContainer: UIView!
        @IBOutlet var txtviewHeightConstraint : NSLayoutConstraint!
        @IBOutlet var txtviewTrailingConstraint : NSLayoutConstraint!
        @IBOutlet var reportTopConstraint : NSLayoutConstraint!
        @IBOutlet var chatBoxHeightConstraint : NSLayoutConstraint!
        @IBOutlet var msgActoinTopConstraint : NSLayoutConstraint!
        @IBOutlet var txtreportReasonHeight : NSLayoutConstraint!
        @IBOutlet var viewreportReasonHeight : NSLayoutConstraint!
        @IBOutlet var bttnreportWidthConstarint : NSLayoutConstraint!
        @IBOutlet var bttnCopyWidthConstarint : NSLayoutConstraint!
        @IBOutlet var viewMsgActionWidthConstarint : NSLayoutConstraint!
        @IBOutlet var bttnDeleteLeadingConstarint : NSLayoutConstraint!
        @IBOutlet var imgViewCopy : UIImageView!
        @IBOutlet var imgViewSave : UIImageView!
        @IBOutlet var imgDelete : UIImageView!
        @IBOutlet var txtreportReason : UITextField!
        @IBOutlet var bottomChatView : UIView!
        @IBOutlet var reportContainer : UIView!
        @IBOutlet var reportOptionView : UIView!
        @IBOutlet var bttnSendReport : UIButton!
        @IBOutlet var bttnCancelReport : UIButton!
        @IBOutlet var reportTblView : UITableView!
        @IBOutlet var chatTablView : UITableView!
        //@IBOutlet var bottomConstraint : NSLayoutConstraint!
        @IBOutlet var txtViewChat : UITextView!
        // @IBOutlet var topHeader : UILabel!
        @IBOutlet var bttnSendChat : UIButton!
        @IBOutlet var msgActionContainer : UIView!
        @IBOutlet var msgActionView : UIView!
        
        @IBOutlet var lblSaveCopy : UILabel!
        @IBOutlet var bttnmsgReply : UIButton!
        @IBOutlet var bttnmsgShare : UIButton!
        @IBOutlet var bttnmsgCopy : UIButton!
        @IBOutlet var bttnmsgDelete : UIButton!
        @IBOutlet var bttnmsgReport : UIButton!
        @IBOutlet var imgReport : UIImageView!
        
        @IBOutlet var bttnreplyMediaClose : UIButton!
        @IBOutlet var replyPlayerMediaView : PlayerView!
        @IBOutlet var replyImageMediaView : UIImageView!
        @IBOutlet var replyMediaView : UIView!
        @IBOutlet var lblMediaSentUser : UILabel!
        @IBOutlet var lblMediaType : UILabel!
        @IBOutlet var bttnMediaType : UIButton!
        
        @IBOutlet var bttnreplyClose : UIButton!
        @IBOutlet var replyView : UIView!
        @IBOutlet var lblMsgOriginalUser : UILabel!
        @IBOutlet var lblOriginalMsg : UILabel!
        
        @IBOutlet var replyViewHeightConstraint : NSLayoutConstraint!
        // @IBOutlet var replyMediaViewHeightConstraint : NSLayoutConstraint!
        @IBOutlet var bottomViewHeightConstraint :NSLayoutConstraint!
        
        @IBOutlet weak var bgImageView: UIImageView!
        var userID : String = "7" //1,4,5,7
        var friendList : [PPeople] = [PPeople]()
        var timeSlot : Int = 5
        var dateTemp : String = ""
        var imgViewContainer : UIView!
        var tempTitle : String = "Mute"
        var selectedVideoURL : URL!
        var videoDataN : NSData?
        
        var minTextViewHeight : CGFloat = 35
        var maxTextViewHeight : CGFloat = 130
        var imageURL : URL!
        var selectedReportOpt : String = ""
        var selectedImage : UIImage!
        let dateFormaatr = DateFormatter()
        let timeFormattr = DateFormatter()
        let newDateFormatter = DateFormatter()
        let tempDateFormattr = DateFormatter()
        var reportOtions : [String] = ["Spam",
                                       "Violence & harassment",
                                       "Adult content",
                                       "Other"]
        var overlayView : UIView!
        var msgArry  :[ChatUser] = [ChatUser]()
        var allMsgArry  :[ChatUser] = [ChatUser]()
        var currentDay : String = ""
        
        //var manager = SocketManager(socketURL: URL(string: "http://52.205.90.191/chat_module/chat//")!, config: [.log(true), .forcePolling(true)])
        let socket: SocketIOClient = SocketIOClient(socketURL: NSURL(string: "http://popboxapp.com:3000/")! as URL)
        //    var manager = SocketManager(socketURL: URL(string: "http://notosolutions.net:3000/")!, config: [.log(true), .forcePolling(true)])
        //    var socket : SocketIOClient!
        var selectedIndex : Int = -1
        var imagePicker : UIImagePickerController = UIImagePickerController()
        var isKeyboardShown : Bool = false
        var scoreTimer : Timer!
        
        var friend:PFriendsInfo!
//        var locationInfo:PLocationInfo!
        var place_id = ""
        var place_name = ""
        var place_rating = ""
        var place_phone_no = ""
        var place_photo = ""
        var place_latitude = ""
        var place_longitude = ""
        var place_members = [Dictionary<String, AnyObject>]()
        var user_id = ""
        var is_fav = 0
        var isContent = false
        var keyboardHeight:CGFloat! = 216.0
        var locationProfileVC:PLocationProfileVC!
        let dropDown = DropDown()
        //    let menuOptions = ["Location info","Mute","Invite friends","Be an Ambassador"]
        let menuOptions = ["Location info","Invite friends","Be an Ambassador"]
        lazy var dropDowns: [DropDown] = {
            return [
                self.dropDown
            ]
        }()
        
        var navController: UINavigationController!
        var isFromNotifcation = false
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.slideMenuController()?.removeLeftGestures()
            self.slideMenuController()?.removeRightGestures()
            
            if navController == nil {
                navController =  self.navigationController
            }
            // Do any additional setup after loading the view.
            updateProfileInfo()
            setupChatModuleDidload()
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        func setupChatModuleDidload() {
            
            //    userID = UserDefaults.standard.string(forKey: "user")!
            userID = "5" // Shahrukh user's id
//            userID = kAppDelegate.objUserInfo.id
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
            self.topView()
            
            dateFormaatr.dateFormat = "yyyy-MM-dd HH:mm:ss"
            tempDateFormattr.dateFormat = "yyyy-MM-dd"
 
            dateTemp = tempDateFormattr.string(from: AppUtility.getDate())
            msgActionView.layer.borderColor = UIColor.init(hex:"08458E").cgColor
            msgActionView.layer.borderWidth = 0.8
            
            msgActionView.layer.shadowOffset = .zero
            msgActionView.layer.shadowColor = UIColor.black.cgColor
            msgActionView.layer.shadowRadius = 4
            msgActionView.layer.shadowOpacity = 0.25
            
            txtviewHeightConstraint.constant = 35
            txtviewTrailingConstraint.constant = 5
            bttnSendChat.isHidden = true
            //replyMediaView.isHidden = true
            let notificationName = Notification.Name("messageLikeorUnlikeNotification")
            NotificationCenter.default.addObserver(self, selector: #selector(PLocationChat.messageLikeorUnlikeNotification(notification:)), name: notificationName, object: nil)
            
            NotificationCenter.default.addObserver(self, selector: #selector(PLocationChat.appComeInForeGround), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
            
            UITextView.appearance().tintColor = UIColor.init(red: 0/255.0, green: 90.0/255.0, blue: 155.0/255.0, alpha: 1.0)
            
            imagePicker.delegate = self
            txtreportReasonHeight.constant = 0
            txtreportReason.isHidden = true
            viewreportReasonHeight.constant = 250
            
            msgActionContainer.isHidden = true
            reportContainer.isHidden = true
            reportContainer.backgroundColor = UIColor.black.withAlphaComponent(0.45)
            reportOptionView.clipsToBounds = true
            replyView.clipsToBounds = true
            txtViewChat.layer.cornerRadius = 5.0
            txtViewChat.layer.borderColor = UIColor.lightGray.cgColor
            txtViewChat.layer.borderWidth = 0.2
            replyViewHeightConstraint.constant = 0
            // replyMediaViewHeightConstraint.constant = 0
            bttnreplyClose.isHidden = true
            bottomViewHeightConstraint.constant = 63
            self.view.layoutSubviews()
            self.view.setNeedsUpdateConstraints()
            
            registerCellClass()
            chatTablView.estimatedRowHeight = 30
            chatTablView.rowHeight = UITableViewAutomaticDimension
            chatTablView.separatorStyle = .none
            
            let tapgestureMsgAction = UITapGestureRecognizer.init(target: self, action: #selector(handleMsgActionTapGesture(sender:)))
            msgActionContainer.addGestureRecognizer(tapgestureMsgAction)
 
            let swipeGEstureKeypad = UISwipeGestureRecognizer(target: self, action: #selector(handleKeypadSwipeGesture(sender:)))
            bottomChatView.addGestureRecognizer(swipeGEstureKeypad)
            
            let swipeGEsturetxtChat = UISwipeGestureRecognizer(target: self, action: #selector(handleKeypadSwipeGesture(sender:)))
            txtViewChat.addGestureRecognizer(swipeGEsturetxtChat)
            swipeGEstureKeypad.direction = .down
            // overlayView.isHidden = true
            
            self.getChatHistory(index: 0, purpose: "")
            
            // scoreTimer  = Timer.scheduledTimer(timeInterval: 300, target: self, selector: #selector(scoreTimerAPI), userInfo: nil, repeats: true)
            // Do any additional setup after loading the view, typically from a nib.
            
            
            
            //    socket = manager.defaultSocket
            
            // SocketIOManager.sharedInstance.establishConnection()
            // socket = SocketIOManager.sharedInstance.socket
            
            socket.on(clientEvent: .connect) {data, ack in
                print("socket connected")
                self.getNewMessage()
            }
            
            socket.on("currentAmount") {data, ack in
                guard let cur = data[0] as? Double else { return }
                
                self.socket.emitWithAck("canUpdate", cur).timingOut(after: 0) {data in
                    self.socket.emit("update", ["amount": cur + 2.50])
                }
                
                ack.with("Got your currentAmount", "dude")
            }
            
            socket.connect()
            
        }
        
        @objc func keyboardWillHide(sender: NSNotification) {
            
            // let userInfo: NSDictionary = sender.userInfo! as NSDictionary
            //  let keyboardSize: CGRect = userInfo[UIKeyboardFrameBeginUserInfoKey]!.cgRectValue
            // self.view.frame.origin.y += keyboardSize.height
        }
        
        @objc func keyboardWillShow(notification: NSNotification) {
            //  let userInfo: [NSObject : AnyObject] = notification.userInfo!
            
            //  let keyboardSize: CGRect = userInfo[UIKeyboardFrameBeginUserInfoKey]!.cgRectValue
            
            /* msgActionContainer.isHidden = true
             if(overlayView != nil)
             {
             overlayView.removeFromSuperview()
             }*/
            
            
            // selectedIndex = -1
        }
        
        override func viewWillLayoutSubviews() {
            if(selectedIndex == -1)
            {
                replyViewHeightConstraint.constant = 0
            }
        }
        override func viewDidLayoutSubviews() {
            
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            //self.connectionEstablish()
            // self.getChatHistory(index: 0, purpose: "")
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(true)
            
        }
        override func viewWillDisappear(_ animated: Bool) {
            if(scoreTimer != nil)
            {
                //            scoreTimer.invalidate()
                scoreTimer.dispose()
                scoreTimer = nil
            }
            
        }
        
        //MARK: - call back event -
        func getNewMessage()
        {
            socket.on("msg") { (dataArray, socketAck) -> Void in
                
                NSLog("recieved msg is called")
                
                DispatchQueue.main.async {
                    
                    let dictdata : NSDictionary = dataArray[0] as! NSDictionary
                    var like_msg_id = ""
                    
                    let data = dictdata["message"] as? [String :Any]
                    
                    if let message = dictdata["message"] as? [String :Any]
                    {
                        let chatuser : ChatUser = ChatUser(message)
                        
                        if(chatuser.id != "")
                        {
                            if let msgID = data!["id"] as? Int
                            {
                                like_msg_id    = String(format:"%d",msgID)
                            }
                            if let msg_ID = data!["id"] as? String
                            {
                                like_msg_id    = msg_ID
                            }
                            
                            for x in 0..<self.msgArry.count
                            {
                                
                                let object = self.msgArry[x]
                                
                                if(object.id == like_msg_id)
                                {
                                    
                                    var count = chatuser.count! > 0 ? chatuser.count! : 0
                                    if(chatuser.is_like == "1")
                                    {
                                        count = count + 1
                                    }
                                    else
                                    {
                                        count = count - 1
                                    }
                                    if let messageCount = message["count"] as? NSDictionary
                                    {
                                        if let likeCount = messageCount["likeCount"] as? Int
                                        {
                                            chatuser.count = likeCount
                                            
                                        }
                                    }
                                    NSLog("chatuser.count --\(chatuser.count!)")
                                    self.msgArry[x] = chatuser
                                    self.chatTablView.reloadRows(at: [NSIndexPath.init(row: x, section: 0) as IndexPath], with: .automatic)
                                    
                                    // NSLog("updated value \(String(describing: self.msgArry[x].is_like))")
                                    return
                                }
                            }
                            
                            
                        }
                    }
                }
                
            }
            
            socket.on("send") { (dataArray, socketAck) -> Void in
                
                NSLog("recieved is called")
                
                DispatchQueue.main.async {
                    
                    let dictdata : NSDictionary = dataArray[0] as! NSDictionary
                    var arrived_msg_id = ""
                    
                    let data = dictdata["message"] as? [String :Any]
                    
                    if let msgID = data!["id"] as? Int
                    {
                        arrived_msg_id    = String(format:"%d",msgID)
                    }
                    if let msg_ID = data!["id"] as? String
                    {
                        arrived_msg_id    = msg_ID
                    }
                    
                    for obj in self.msgArry
                    {
                        if(obj.id == arrived_msg_id)
                        {
                            return
                        }
                    }
                    
                    if let message = dictdata["message"] as? [String :Any]
                    {
                        
                        var isFound = false
                        let chatuser : ChatUser = ChatUser(message)
                        
                        if(chatuser.id != "")
                        {
                            
                            var msg_id = ""
                            
                            if let msgID = message["message_id"] as? Int
                            {
                                msg_id    = String(format:"%d",msgID)
                            }
                            if let msg_ID = message["message_id"] as? String
                            {
                                msg_id    = msg_ID
                            }
                            
                            
                            for x in 0..<self.msgArry.count
                            {
                                let object = self.msgArry[x]
                                
                                if(object.id == msg_id)
                                {
                                    isFound = true
                                    var count = chatuser.count! > 0 ? chatuser.count! : 0
                                    if(chatuser.is_like == "1")
                                    {
                                        count = count + 1
                                    }
                                    else
                                    {
                                        count = count - 1
                                    }
                                    chatuser.count = count
                                    self.msgArry[x] = chatuser
                                    self.chatTablView.reloadRows(at: [NSIndexPath.init(row: x, section: 0) as IndexPath], with: .automatic)
                                    
                                    // NSLog("updated value \(String(describing: self.msgArry[x].is_like))")
                                    return
                                }
                            }
                            
                            if(isFound == false)
                            {
                                self.msgArry.append(chatuser)
                            }
                            
                            let indexPAth : IndexPath = IndexPath(row: self.msgArry.count-1, section: 0)
                            
                            
                            
                            
                            self.setDatewiseChatList()
                            
                            let lastScrollOffset = self.chatTablView.contentOffset
                            
                            let height : CGFloat   = self.chatTablView.frame.size.height+10
                            let contentYoffset     = self.chatTablView.contentOffset.y
                            let distanceFromBottom = self.chatTablView.contentSize.height - contentYoffset
                            /*if (self.chatTablView.contentOffset.y >= (self.chatTablView.contentSize.height - self.chatTablView.bounds.size.height)) {
                             self.chatTablView.beginUpdates()
                             self.chatTablView.insertRows(at: [indexPAth], with: .top)
                             self.chatTablView.endUpdates()
                             //you reached end of the table
                             }*/
                            
                            if(distanceFromBottom < height)
                            {
                                self.chatTablView.beginUpdates()
                                self.chatTablView.insertRows(at: [indexPAth], with: .none)
                                self.chatTablView.endUpdates()
                                self.chatTablView.scrollToRow(at: indexPAth, at: .bottom, animated: true)
                                
                                //you reached end of the table
                            }
                            else
                            {
                                self.chatTablView.beginUpdates()
                                self.chatTablView.insertRows(at: [indexPAth], with: .none)
                                self.chatTablView.endUpdates()
                                self.chatTablView.setContentOffset(lastScrollOffset, animated: false)
                            }
                            
                            
                        }
                    }
                }
                
            }
            
        }
        //MARK: Navigation Bar item
        func topView()
        {
            let topView : UIView = UIView.init(frame: CGRect(x:0,y:0,width:self.view.frame.size.width/2,height:40))
            let imgview = UIImageView.init(frame: CGRect(x:20,y:0,width:40,height:38))
            imgview.image = UIImage(named:"topgrp.png")
            let grpName = UILabel.init(frame: CGRect(x:70,y:0,width:150,height:20))
            grpName.text = "Popbox"
            grpName.textColor = UIColor.white
            grpName.font = UIFont.boldSystemFont(ofSize: 16.0)
            let grpMemberName = UILabel.init(frame: CGRect(x:70,y:grpName.frame.origin.y+grpName.frame.size.height,width:250,height:20))
            grpMemberName.text = "Ava,Kayla,720 others"
            grpMemberName.textColor = UIColor(red: 178.0/255.0, green: 204.0/255.0, blue: 225/255.0, alpha: 1.0)
            grpMemberName.font = UIFont.systemFont(ofSize: 12.0)
            topView.addSubview(imgview)
            topView.addSubview(grpName)
            topView.addSubview(grpMemberName)
            self.navigationController?.navigationBar.addSubview(topView)
            
        }
        
        func muteUnmute(title : String)
        {
            txtViewChat.resignFirstResponder()
            if title == "Mute"
            {
                self.tempTitle = "Unmute"
                UserDefaults.standard.set(true, forKey: "isMute")
                self.showAlert(message: "Notifications muted")
            }
            else
            {
                self.tempTitle = "Mute"
                UserDefaults.standard.set(false, forKey: "isMute")
                self.showAlert(message: "Notifications unmuted")
            }
            //
            //        let actoinSheet = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
            //        actoinSheet.addAction(UIAlertAction.init(title: "Profile", style: .default, handler: { (action) in
            //
            //        }))
            //        actoinSheet.addAction(UIAlertAction.init(title: tempTitle, style:  .default, handler: { (action) in
            //
            //        }))
            //
            //        actoinSheet.addAction(UIAlertAction.init(title: "Invite friends", style:  .default, handler: { (action) in
            //
            //        }))
            //        actoinSheet.addAction(UIAlertAction.init(title: "Be an Ambassador", style:  .default, handler: { (action) in
            //
            //        }))
            //        actoinSheet.addAction(UIAlertAction.init(title: "Cancel", style:  .cancel, handler: { (action) in
            //
            //        }))
            //
            //        present(actoinSheet, animated: true, completion: nil)
        }
        @IBAction func barbttnTwo(sender : UIBarButtonItem)
        {
            
        }
        //MARK:
        
        //MARK: Notification Handler
        
        @objc func appComeInForeGround()
        {
            //manager = SocketManager(socketURL: URL(string: "http://notosolutions.net:1337/")!, config: [.log(true), .forcePolling(true)])
            //commented
            //        socket = manager.defaultSocket
            
            socket.on(clientEvent: .connect) {data, ack in
                print("socket connected")
                self.getNewMessage()
            }
            socket.on("currentAmount") {data, ack in
                guard let cur = data[0] as? Double else { return }
                
                self.socket.emitWithAck("canUpdate", cur).timingOut(after: 0) {data in
                    self.socket.emit("update", ["amount": cur + 2.50])
                }
                
                ack.with("Got your currentAmount", "dude")
            }
            
            socket.connect()
            
            ///scoreTimer  = Timer.scheduledTimer(timeInterval: 300, target: self, selector: #selector(scoreTimerAPI), userInfo: nil, repeats: true)
            
            self.getChatHistory(index: 0, purpose: "")
        }
        @objc func messageLikeorUnlikeNotification(notification : Notification)
        {
            let userInfo : [String : Any] = notification.userInfo as! [String : Any]
            
            if let msgID = userInfo["msg_id"] as? Int
            {
                getChatHistory(index: msgID, purpose: "Like")
            }
            if let msgID = userInfo["msg_id"] as? String
            {
                getChatHistory(index: Int(msgID)!, purpose: "Like")
            }
            
        }
        
        //MARK: Webservices
        @objc func scoreTimerAPI()
        {
            let urlStr: String = kApiScorelist
            
            let params : [String : Any] = ["min":time as AnyObject]
            
            Alamofire.request(urlStr, method: .post, parameters: params ).responseJSON { response in
                
                if let jsonObject = response.result.value as? [String: AnyObject]{
                    print(jsonObject)
                    if (jsonObject["status"] as? Bool) != nil
                    {
                        self.timeSlot = self.timeSlot+5
                    }
                }
            }
        }
 
        func getChatHistory(index: Int , purpose : String)
        {
            
            let urlStr: String = kApiChatHistory
            
            let params : [String : Any] = ["box_id":"1", "user_id":userID]
            
            Alamofire.request(urlStr, method: .post, parameters: params ).responseJSON { response in
                
                if let jsonObject = response.result.value as? [String: AnyObject]{
                    print(jsonObject)
                    if let status  = jsonObject["status"] as? Bool
                    {
                        self.msgArry.removeAll()
                        self.dateTemp = self.tempDateFormattr.string(from: AppUtility.getDate())
                        if(status == true)
                        {
                            if let response = jsonObject["response"] as? NSDictionary
                            {
                                if let results = response["results"] as? [NSDictionary]
                                {
                                    for dict in results
                                    {
                                        if (dict["user_id"] as? String) != nil
                                        {
                                            let chatuser : ChatUser = ChatUser(dict as! [AnyHashable : Any])
                                            
                                            if chatuser.likeResult.contains(where: { (like) -> Bool in
                                                if like.user_id == kAppDelegate.objUserInfo.id {
                                                    return true
                                                }
                                                return false
                                            }) {
                                                chatuser.is_like = "1"
                                            }else{
                                                chatuser.is_like = "0"
                                            }
                                            self.msgArry.append(chatuser)
                                        }
                                    }
                                    if(self.msgArry.count > 0)
                                    {
                                        
                                        self.msgArry.reverse()
                                        
                                        if(purpose == "Like")
                                        {
                                            do
                                            {
                                                let msgId : String = String(format:"%d",index)
                                                let indexxx : Int = self.msgArry.index(where: { $0.id == msgId })!
                                                
                                                if(indexxx < self.msgArry.count)
                                                {
                                                    let indexPath = IndexPath(row: indexxx, section: 0)
                                                    if(self.chatTablView.indexPathsForVisibleRows?.contains(indexPath))!
                                                    {
                                                        self.setDatewiseChatList()
                                                        self.chatTablView.reloadRows(at: [indexPath], with: .automatic)
                                                    }
                                                    else
                                                    {
                                                        self.setDatewiseChatList()
                                                        /* self.allMsgArry.removeAll()
                                                         
                                                         let array = self.msgArry
                                                         if let indexx = array.index(where: {$0.message == self.currentDay})
                                                         {
                                                         let arrSlice = [indexx..<self.msgArry.count]
                                                         self.allMsgArry = arrSlice
                                                         self.allMsgArry.append(contentsOf: arrSlice)
                                                         }*/
                                                        self.chatTablView.reloadData()
                                                    }
                                                }
                                                
                                            }
                                            
                                            
                                        }
                                        else if(purpose == "Image")
                                        {
                                            self.view.layoutSubviews()
                                            self.view.layoutIfNeeded()
                                        }
                                        else if(purpose == "New")
                                        {
                                            do
                                            {
                                                let indexPAth : IndexPath = IndexPath(row: self.msgArry.count-1, section: 0)
                                                if(self.chatTablView.indexPathsForVisibleRows?.contains(indexPAth))!
                                                {
                                                    //self.msgArry.append(chatuser)
                                                    self.setDatewiseChatList()
                                                    self.chatTablView.reloadData()
                                                    self.scrollToTheBottom(animated: true)
                                                }
                                                else
                                                {
                                                    // self.msgArry.append(chatuser)
                                                    self.setDatewiseChatList()
                                                    self.chatTablView.reloadData()
                                                }
                                            }
                                        }
                                        else
                                        {
                                            self.setDatewiseChatList()
                                            self.chatTablView.reloadData()
                                            self.scrollToTheBottom(animated: true)
                                        }
                                        
                                        //
                                    }
                                }
                            }
                            
                        }
                    }
                    
                }
                else
                {
                    NSLog("response --error--chathistory-- \(String(describing: response.result.error?.localizedDescription))")
                }
            }
        }
        func likeMessage(messageID  : String , userID : String ,index: Int)
        {
            
            //        //MBProgressHUD.showAdded(to: self.view, animated: true)
            //        let urlStr: String = likeFeature
            //
            //        let params : [String : Any] = ["message_id":messageID ,"user_id":userID,"box_id":"1"]
            //
            //        Alamofire.request(urlStr, method: .post, parameters: params ).responseJSON { response in
            //            // MBProgressHUD.hide(for: self.view, animated: true)
            //            if let jsonObject = response.result.value as? [String: AnyObject]{
            //                print(jsonObject)
            //                if let status  = jsonObject["status"] as? Bool
            //                {
            //                    if(status == true)
            //                    {
            //                        if let response = jsonObject["response"] as? NSDictionary
            //                        {
            //                            if let lastMsgDetail = response["lastMsgDetail"] as? NSDictionary
            //                            {
            //                                let chatuser : ChatUser = ChatUser(lastMsgDetail as! [AnyHashable : Any])
            //
            //                                self.msgArry.remove(at: index)
            //                                self.msgArry.insert(chatuser, at: index)
            //
            //                            }
            //
            //
            //                        }
            //
            //                    }
            //                }
            //
            //            }
            //
            //        }
            
        }
        
        //MARK: - event on like unlike
        
        func likeunlikeevent(chat : ChatUser)
        {
            
            //is_like: String, message_id:String, message: String
            let datfomattr = DateFormatter()
            datfomattr.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let time : String = datfomattr.string(from: AppUtility.getDate())
            var  param  : [String : Any] = [String : Any]()
            
            let like_msg = (chat.is_like == "1") ? 1 : 0
            //  let like = is_like == "1" ? "0": "1"
            
            //let msgText = encode(txtViewChat.text!)
            
            //            {"message_id":"2814",
            //                "status":"1",
            //                "parent_id":"0",
            //                "isliketext":1,
            //                "created_at":"2018-01-11 11:56:25",
            //                "is_like":1,
            //                "user_id":"4",
            //                "box_id":"1",
            //                "message":"Hi",
            //                "is_flagged":"1",
            //                "type":""}
            
            param = ["message_id":chat.id!,
                     "status":"1",
                     "parent_id":"0",
                     "isliketext":"Yes",
                     "created_at":time,
                     "is_like": like_msg,
                     "user_id":userID,
                     "box_id":"1",
                     "message":chat.message!,
                     "is_flagged":"1",
                     "type":""]
            
            let message : String = notPrettyString(from: param)!
            
            socket.emit("send message", with: [message])
            
        }
        
        func deleteMessage(messageID  : String , userID : String)
        {
            
            //MBProgressHUD.showAdded(to: self.view, animated: true)
            let urlStr: String = kApiDeleteChat
            
            let params : [String : Any] = ["message_id":messageID ,"user_id":userID]
            
            Alamofire.request(urlStr, method: .post, parameters: params ).responseJSON { response in
                
                if let jsonObject = response.result.value as? [String: AnyObject]{
                    print(jsonObject)
                    if let status  = jsonObject["status"] as? Bool
                    {
                        if(status == true)
                        {
                            self.selectedIndex = -1
                            
                            
                        }
                    }
                    
                }
                
            }
        }
        func addAttachment(attachmentName  :String)
        {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            let url = kApiChatInsert
            let parameters = ["user_id":userID ,
                              "box_id":"1",
                              "parent_id":"0",
                              "is_flagged":"1",
                              "is_like":"0",
                              "isliketext":"",
                              "attachment_name":attachmentName]
            
            var data : Data!
            var mileType : String = ""
            var fileName : String = ""
            
            if(self.selectedImage != nil && attachmentName == "Image")
            {
                data = UIImageJPEGRepresentation(self.selectedImage!, 0)!
                mileType = "image/jpeg"
                fileName = String(format:"image_%d.jpg",self.random9DigitString())
                
            }
            if(self.selectedVideoURL != nil && attachmentName == "Video")
            {
                do
                {
                    let video3 : NSData = try NSData(contentsOf: self.selectedVideoURL, options: .dataReadingMapped)
                    data = video3 as Data
                    mileType = "video/mp4"
                    fileName = String(format:"video_%d.mp4",self.random9DigitString())
                }
                catch let error as Error
                {
                    NSLog("error  -- \(error.localizedDescription)")
                }
                
            }
            
            let headers: HTTPHeaders = [
                
                "Content-type": "multipart/form-data"
            ]
            if(data != nil)
            {
                Alamofire.upload(multipartFormData: { multipartFormData in
                    
                    for (key,value) in parameters {
                        multipartFormData.append((value ).data(using: .utf8)!, withName: key)
                    }
                    multipartFormData.append(data, withName: "file", fileName: fileName,mimeType: mileType)
                    
                },
                                 usingThreshold: UInt64.init(),
                                 to: url,
                                 method: .post,
                                 headers : headers){
                                    (result) in
                                    switch result{
                                    case .success(let upload, _, _):
                                        upload.responseJSON { response in
                                            DispatchQueue.main.async {
                                                MBProgressHUD.hide(for: self.view, animated: true)
                                            }
                                            do
                                            {
                                                let jsondata = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                                                print("Succesfully uploaded --- \(jsondata)")
                                                if let response = jsondata["response"] as? NSDictionary
                                                {
                                                    
                                                    
                                                    let chatuser : ChatUser = ChatUser(response as! [AnyHashable : Any])
                                                    
                                                    let   paramSocket : [String : Any] = ["user_id":chatuser.user_id ?? "",
                                                                                          "box_id":"1",
                                                                                          "parent_id":"0",
                                                                                          "message":"",
                                                                                          "is_flagged":"1",
                                                                                          "status":"1",
                                                                                          "is_like":"0",
                                                                                          "isliketext":"",
                                                                                          "created_at":chatuser.created_at ?? "",
                                                                                          "message_id":chatuser.id ?? "",
                                                                                          "type" : attachmentName]
                                                    
                                                    let message : String = self.notPrettyString(from: paramSocket)!
                                                    NSLog("message---\(message)")
                                                    self.socket.emit("send message", with: [message])
                                                    
                                                    //let imgName
                                                    if(chatuser.attachment_name?.lowercased() == "image")
                                                    {
                                                        
                                                        DispatchQueue.main.async {
                                                            self.msgArry.append(chatuser)
                                                            // let beforeCount = self.msgArry.count
                                                            self.setDatewiseChatList()
                                                            
                                                            
                                                            do
                                                            {
                                                                let indexPathN:IndexPath = IndexPath(row:(self.msgArry.count - 1), section:0)
                                                                
                                                                self.chatTablView.performSelector(onMainThread: #selector(self.chatTablView.reloadData), with: nil, waitUntilDone: true)
                                                                
                                                                self.chatTablView.scrollToRow(at: indexPathN, at: UITableViewScrollPosition.top, animated: true)
                                                                
                                                            }
                                                            
                                                        }
                                                        
                                                    }
                                                    if(chatuser.attachment_name?.lowercased() == "video")
                                                    {
                                                        let videoname : String = chatuser.video!
                                                        if(videoname != "")
                                                        {
                                                            
                                                            if(videoname.contains("/"))
                                                            {
                                                                let urlarry = videoname.components(separatedBy: "/")
                                                                chatuser.video? = (urlarry.last)!
                                                            }
                                                            
                                                        }
                                                        DispatchQueue.main.async(execute: {
                                                            self.msgArry.append(chatuser)
                                                            // let beforeCount = self.msgArry.count
                                                            self.setDatewiseChatList()
                                                            
                                                            
                                                            do
                                                            {
                                                                let indexPathN:IndexPath = IndexPath(row:(self.msgArry.count - 1), section:0)
                                                                self.chatTablView.performSelector(onMainThread: #selector(self.chatTablView.reloadData), with: nil, waitUntilDone: true)
                                                                
                                                                self.chatTablView.scrollToRow(at: indexPathN, at: UITableViewScrollPosition.top, animated: true)
                                                                self.chatTablView.layoutIfNeeded()
                                                                
                                                                
                                                            }
                                                            
                                                            
                                                        })
                                                    }
                                                    
                                                }
                                            }
                                            catch
                                            {
                                                
                                            }
                                            
                                            
                                            
                                            
                                            /*if response is NSDictionary
                                             */
                                        }
                                    case .failure(let error):
                                        print("Error in upload: \(error.localizedDescription)")
                                        
                                    }
                }
            }
            
            
            
        }
        
        
        
        
        func random9DigitString() -> String {
            let min: UInt32 = 100_000_000
            let max: UInt32 = 999_999_999
            let i = min + arc4random_uniform(max - min + 1)
            return String(i)
        }
        func createBody(parameters: [String: String],boundary: String,data: Data,mimeType: String,
                        filename: String) -> Data
        {
            let body = NSMutableData()
            
            let boundaryPrefix = "--\(boundary)\r\n"
            
            for (key, value) in parameters {
                body.appendString(boundaryPrefix)
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
            
            body.appendString(boundaryPrefix)
            body.appendString("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n")
            body.appendString("Content-Type: \(mimeType)\r\n\r\n")
            body.append(data)
            body.appendString("\r\n")
            body.appendString("--".appending(boundary.appending("--")))
            
            return body as Data
        }
        func reportFeatureAPI(messageID  : String , userID : String)
        {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            let urlStr: String = kApiReportFeature
            
            let params : [String : Any] = ["message_id":messageID ,"user_id":userID,"msg_options":selectedReportOpt , "rpt_message":txtreportReason.text!]
            
            NSLog("params \(params)")
            
            Alamofire.request(urlStr, method: .post, parameters: params ).responseJSON { response in
                
                MBProgressHUD.hide(for: self.view, animated: true)
                
                NSLog("what \(String(describing: response.result.value))")
                
                if let jsonObject = response.result.value as? [String: AnyObject]{
                    print(jsonObject)
                    if let status  = jsonObject["status"] as? Bool
                    {
                        
                        if(status == true)
                        {
                            self.selectedIndex = -1
                            self.showAlert(message: "Message reported")
                            self.selectedReportOpt = ""
                            
                        }
                    }
                    
                }
                
            }
            
        }
        
        
        //MARK: Chat Send method
        
        
        func scrollToTheBottom(animated: Bool)
        {
            if (msgArry.count>0)
            {
                
                // self.chatTablView.scrollToRow(at: indeXPath, at: .bottom, animated: animated)
                
                let numberOfSections = chatTablView.numberOfSections
                let numberOfRows = chatTablView.numberOfRows(inSection: numberOfSections-1)
                
                if numberOfRows > 0 {
                    print(numberOfSections)
                    print(numberOfRows)
                    let indexPath = NSIndexPath(row: numberOfRows-1,section: (numberOfSections-1))
                    
                    print(indexPath)
                    
                    chatTablView.scrollToRow(at: indexPath as IndexPath, at: UITableViewScrollPosition.top, animated: false)
                    self.view.layoutIfNeeded()
                    //self.view.layoutSubviews()
                    // self.view.setNeedsUpdateConstraints()
                }
            }
        }
        @IBAction func sendMessage()
        {
            
            //        isliketext = Yes or No
            //        is_like = 1 or 0
            //        message_id =
            
            //txtViewChat.resignFirstResponder()
            // overlayView.isHidden = true
            if(txtViewChat.text == "Write a message..." || txtViewChat.text == "")
            {
                return
            }
            else
            {
                let datfomattr = DateFormatter()
                datfomattr.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let time : String = datfomattr.string(from: AppUtility.getDate())
                var  param  : [String : Any] = [String : Any]()
                
                let msgText = encode(txtViewChat.text!)
                if(selectedIndex == -1)
                {
                    
                    param = ["user_id":userID, "box_id":"1", "parent_id":"0", "message":msgText,"is_flagged":"1","status":"1","created_at":time,"type":"",
                             "message_id":"","is_like":"0", "isliketext":""]
                    
                    NSLog("\(param)")
                }
                else
                {
                    bttnreplyClose.isHidden = true
                    replyViewHeightConstraint.constant = 0
                    
                    lblMsgOriginalUser.text = ""
                    lblOriginalMsg.text = ""
                    
                    if(selectedIndex < msgArry.count && self.selectedIndex > 0)
                    {
                        let chatObj : ChatUser = msgArry[selectedIndex]
                        let messageID : String = String(format:"%@",chatObj.id!)
                        param = ["user_id":userID,
                                 "box_id":"1",
                                 "parent_id":messageID,
                                 "message":msgText,
                                 "is_flagged":"1",
                                 "status":"1",
                                 "created_at":time,
                                 "type":"",
                                 "is_like":"0",
                                 "isliketext":"",
                                 "message_id":""]
                    }
                    
                }
                
                
                
                let message : String = notPrettyString(from: param)!
                
                socket.emit("send message", with: [message])
                
                var msgData : [String : Any]  = [String : Any]()
                if(selectedIndex < msgArry.count && self.selectedIndex > 0)
                {
                    let chatObj : ChatUser = msgArry[selectedIndex]
                    let lastObj : ChatUser = self.msgArry[self.msgArry.count - 1]
                    var newId : Int = 0
                    if(lastObj.id != "")
                    {
                        newId = Int(lastObj.id!)! + 1
                    }
                    
                    let messageID : String = String(format:"%@",chatObj.id!)
                    let indexxx : Int = self.msgArry.index(where: { $0.id == messageID })!
                    let replyData = self.msgArry[indexxx]
                    let replyUSer : [String : Any] = ["id": replyData.id ?? "",
                                                      "user_id": replyData.user_id ?? "",
                                                      "box_id": "1",
                                                      "event_type": "1",
                                                      "message": replyData.message ?? "",
                                                      "attachment_name": replyData.attachment_name ?? "",
                                                      "parent_id": replyData.parent_id ?? "",
                                                      "is_flagged": "1",
                                                      "is_like": replyData.is_like ?? "",
                                                      "created_at": replyData.created_at ?? "",
                                                      "status": "1",
                                                      "logo": replyData.logo ?? "",
                                                      "audio": replyData.audio ?? "",
                                                      "video": replyData.video ?? "",
                                                      "username": replyData.username ?? "",
                                                      "count": replyData.count ?? 0,
                                                      "color": replyData.color ?? 0,]
                    msgData = ["message_id": String(format:"%d",newId),
                               "user_id": userID,
                               "box_id": "1",
                               "event_type": "1",
                               "message": msgText,
                               "attachment_name": "",
                               "parent_id": messageID,
                               "is_flagged": "1",
                               "is_like": "0",
                               "created_at": time,
                               "status": "1",
                               "logo": "",
                               "audio": "",
                               "video": "",
                               "username": "test",
                               "count": 0,
                               "color": 0,
                               "reply":["results" :[replyUSer]]]
                }
                else
                {
                    var newId : Int = 0
                    if(self.msgArry.count > 0)
                    {
                        let lastObj : ChatUser = self.msgArry[self.msgArry.count - 1]
                        if(lastObj.id != "" && lastObj.id != nil)
                        {
                            newId = Int(lastObj.id!)! + 1
                        }
                        
                    }
                    else
                    {
                        
                        newId =  1
                    }
                    
                    msgData = ["message_id": String(format:"%d",newId),
                               "user_id": userID,
                               "box_id": "1",
                               "event_type": "1",
                               "message": msgText,
                               "attachment_name": "",
                               "parent_id": "0",
                               "is_flagged": "1",
                               "is_like": "0",
                               "created_at": time,
                               "status": "1",
                               "logo": "",
                               "audio": "",
                               "video": "",
                               "username": "test",
                               "count": 0,
                               "color": 0,
                               "reply":[String : Any]()]
                }
                NSLog("msgData---\(msgData)")
                let chatUser : ChatUser = ChatUser(msgData)
                txtViewChat.text = ""
                self.msgArry.append(chatUser)
                
            }
            
            if(txtViewChat.text.trimmingCharacters(in: .whitespacesAndNewlines) == "")
            {
                txtviewTrailingConstraint.constant = 5
                txtviewHeightConstraint.constant = 35
                bttnSendChat.isHidden = true
            }
            bottomViewHeightConstraint.constant = 214 - txtviewHeightConstraint.constant
            selectedIndex = -1
            // let beforeCount = self.msgArry.count
            NSLog("self.msgArry.count -000-- \(self.msgArry.count)")
            self.setDatewiseChatList()
            //let aftercount = self.msgArry.count
            NSLog("self.msgArry.count -1111-- \(self.msgArry.count)")
            
            do
            {
                DispatchQueue.main.async
                    {
                        let index_path:IndexPath = IndexPath(row:(self.msgArry.count - 1), section:0)
                        
//                        self.chatTablView.beginUpdates()
//                        self.chatTablView.insertRows(at: [index_path], with: .none)
//                        self.chatTablView.endUpdates()
//                        self.chatTablView.scrollToRow(at: index_path, at: UITableViewScrollPosition.none, animated: false)
                }                
            }
        }
        
        //MARK:Gesture
        @objc func handleKeypadSwipeGesture(sender : UIButton)
        {
            txtViewChat.resignFirstResponder()
        }
        @objc func handleMsgActionTapGesture(sender : UITapGestureRecognizer)
        {
            //setBackMsgBackgroundColor()
            msgActionContainer.isHidden = true
            overlayView.removeFromSuperview()
            selectedIndex = -1
        }
        
        @objc func handleTapGesture(sender : UITapGestureRecognizer)
        {
            txtViewChat.resignFirstResponder()
            // overlayView.isHidden = true
        }
        @objc func longPressGesture(sender :UILongPressGestureRecognizer)
        {
            
            //      txtViewChat.resignFirstResponder()
            
            if(msgActionContainer.isHidden == true)
            {
                let view : UIView = sender.view!
                NSLog("view tag---\(view.tag)")
                selectedIndex = view.tag
                var yPos : CGFloat = 0.0
                var yPos1 : CGFloat = 0.0
                do
                {
                    let indexPath = IndexPath(row: selectedIndex, section: 0)
                    let cell = chatTablView.cellForRow(at: indexPath)
                    
                    if let indexPath = chatTablView.indexPath(for: cell!) {
                        let rect = self.chatTablView.rectForRow(at: indexPath)
                        let rectInScreen = self.chatTablView.convert(rect, to: self.view)
                        
                        yPos = rectInScreen.origin.y
                        yPos1 = rectInScreen.origin.y
                        yPos = yPos - 80
                        if(yPos < 20)
                        {
                            yPos = rectInScreen.origin.y + rectInScreen.size.height + 10
                             yPos =  yPos - 64
                        }
                        else if(yPos > chatTablView.frame.size.height)
                        {
//                            yPos = rectInScreen.origin.y - rectInScreen.size.height+20
                            yPos = rectInScreen.origin.y - (64+80+10)
                        }else if (yPos1 >= rectInScreen.origin.y) && (rectInScreen.origin.y+rectInScreen.size.height+10+80 > screenHeight()-60) {
                             yPos = rectInScreen.origin.y - (64+80+10)
                            
                        }else if (yPos1 >= rectInScreen.origin.y) && (rectInScreen.origin.y+rectInScreen.size.height+10+80 < screenHeight()-60) {
                            yPos = rectInScreen.origin.y + rectInScreen.size.height + 10
                            yPos =  yPos - 64
                        }
                        
                        NSLog("yessss \(viewChatContainer.frame.origin.y)")
                        
                        let total_height = rectInScreen.origin.y + rectInScreen.size.height
                        
                        var height_remaining = 0
                        if(viewChatContainer.frame.origin.y < total_height-64)
                        {
                            height_remaining =  Int((total_height-64) - viewChatContainer.frame.origin.y)
//                            height_remaining = Int(total_height) - height_remaining
                            // yPos = yPos - (viewChatContainer.frame.origin.y - (yPos + self.chatTablView.frame.height))
                        }
                        //CCE6FD
                        overlayView = UIView.init(frame: CGRect(x:rectInScreen.origin.x,y:rectInScreen.origin.y, width:rectInScreen.size.width, height:rectInScreen.size.height - CGFloat(height_remaining) ))
                        overlayView.backgroundColor = UIColor.init(hex: "08458E").withAlphaComponent(0.10)//UIColor.lightGray.withAlphaComponent(0.15)
                        self.view.addSubview(overlayView)
                    }
                }
                
                
                if(selectedIndex < msgArry.count && self.selectedIndex > 0)
                {
                    let chatObj : ChatUser = msgArry[selectedIndex]
                    bttnmsgCopy.removeTarget(nil, action: nil, for: .touchUpInside)
                    bttnmsgCopy.setTitle("", for: .normal)
                    if(chatObj.user_id == userID)
                    {
                        if(chatObj.attachment_name?.lowercased() == "image" || chatObj.attachment_name?.lowercased() == "video")
                        {
                            bttnreportWidthConstarint.constant = 0
                            
                            viewMsgActionWidthConstarint.constant = 183
                            imgReport.isHidden = true
                            imgViewCopy.isHidden = true
                            imgViewSave.isHidden = true
                            bttnDeleteLeadingConstarint.constant = 12
                            msgActionView.layoutSubviews()
                            msgActionView.layoutIfNeeded()
                            // bttnmsgDelete.center.x = bttnmsgCopy.center.x
                            imgDelete.center.x = bttnmsgDelete.center.x+3
                            bttnCopyWidthConstarint.constant = 0
                            lblSaveCopy.text = ""
                            lblSaveCopy.isHidden = true
                            msgActionView.layoutSubviews()
                            msgActionView.layoutIfNeeded()
                        }
                        else
                        {
                            bttnreportWidthConstarint.constant = 0
                            viewMsgActionWidthConstarint.constant = 235
                            bttnCopyWidthConstarint.constant = 40
                            bttnDeleteLeadingConstarint.constant = 63
                            imgReport.isHidden = true
                            //bttnmsgCopy.setTitle("Copy", for: .normal)
                            lblSaveCopy.text = "Copy"
                            lblSaveCopy.isHidden = false
                            imgViewCopy.isHidden = false
                            imgViewSave.isHidden = true
                            msgActionView.layoutSubviews()
                            msgActionView.layoutIfNeeded()
                            imgDelete.center.x = bttnmsgDelete.center.x
                            bttnmsgCopy.addTarget(self, action: #selector(bttnmsgCopyClicked(sender:)), for: .touchUpInside)
                        }
                        
                    }
                    else
                    {
                        bttnreportWidthConstarint.constant = 50
                        bttnCopyWidthConstarint.constant = 40
                        bttnDeleteLeadingConstarint.constant = 63
                        viewMsgActionWidthConstarint.constant = 297
                        msgActionView.layoutSubviews()
                        msgActionView.layoutIfNeeded()
                        imgDelete.center.x = bttnmsgDelete.center.x
                        if(chatObj.attachment_name?.lowercased() == "image" || chatObj.attachment_name?.lowercased() == "video")
                        {
                            imgViewCopy.isHidden = true
                            imgViewSave.isHidden = false
                            //bttnmsgCopy.setTitle("Save", for: .normal)
                            lblSaveCopy.text = "Save"
                            lblSaveCopy.isHidden = false
                            bttnmsgCopy.addTarget(self, action: #selector(bttnmsgSaveClicked(sender:)), for: .touchUpInside)
                        }
                        else
                        {
                            imgViewCopy.isHidden = false
                            imgViewSave.isHidden = true
                            //bttnmsgCopy.setTitle("Copy", for: .normal)
                            lblSaveCopy.text = "Copy"
                            lblSaveCopy.isHidden = false
                            bttnmsgCopy.addTarget(self, action: #selector(bttnmsgCopyClicked(sender:)), for: .touchUpInside)
                        }
                        imgReport.isHidden = false
                        
                    }
                }
                
                if(isKeyboardShown == true)
                {
                    msgActoinTopConstraint.constant = yPos
                }
                else
                {
                    msgActoinTopConstraint.constant = yPos
                }
                
                msgActionView.isHidden = true
                msgActionContainer.frame = CGRect(x:0,y:0,width:self.view.frame.size.width,height:self.view.frame.size.height)
                
                msgActionContainer.backgroundColor = UIColor.clear
                msgActionView.layer.cornerRadius = 2.5
                msgActionContainer.clipsToBounds = true
                msgActionContainer.isHidden = false
                msgActionView.isHidden = false
                // self.view.bringSubview(toFront: overlayView)
            }
            
            //self.view.superview?.bringSubview(toFront: bottomChatView)
        }
        @IBAction func bttnAddAttachment()
        {
            let alertController = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let cameraAction = UIAlertAction.init(title: "Camera", style: .default) { (action) in
                
                if((UIImagePickerController.availableMediaTypes(for: UIImagePickerControllerSourceType.camera)) != nil)
                {
                    self.imagePicker.allowsEditing = false
                    self.imagePicker.sourceType = .camera
                    self.imagePicker.cameraCaptureMode = .photo
                    self.present(self.imagePicker, animated: true, completion: nil)
                }
            }
            
            let photoAction = UIAlertAction.init(title: "Photo & Video Library", style: .default) { (action) in
                self.imagePicker.allowsEditing = false
                self.imagePicker.sourceType = .photoLibrary
                self.imagePicker.mediaTypes = ["public.image", "public.movie"]
                self.present(self.imagePicker, animated: true, completion: nil)
            }
            let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel) { (action) in
                self.dismiss(animated: true, completion: nil)
            }
            
            alertController.addAction(cameraAction)
            alertController.addAction(photoAction)
            
            alertController.addAction(cancelAction)
            //alert
            self.present(alertController, animated: true, completion: nil)
        }
        
        //MARK:
        func registerCellClass()
        {
            
            
            chatTablView.register(UINib.init(nibName: "UserDateViewCell", bundle: nil), forCellReuseIdentifier: "datebubble")
            //--------------------------My Chat Text--------------------------
            chatTablView.register(UINib.init(nibName: "UserChatByMeCell", bundle: nil), forCellReuseIdentifier: "chatbymeCell")
            //--------------------------Other User Chat Text------------------
            chatTablView.register(UINib.init(nibName: "UserChatByOtherCell", bundle: nil), forCellReuseIdentifier: "chatbyotherCell")
            //------------------------- Reply By Other User Chat--------------
            chatTablView.register(UINib.init(nibName: "UserReplyViewCell", bundle: nil), forCellReuseIdentifier: "replyotherCell")
            //--------------------------My Reply Chat-------------------------
            chatTablView.register(UINib.init(nibName: "UserMyMsgReplyCell", bundle: nil), forCellReuseIdentifier: "myReplyCell")
            //------------------------- My Image Chat-------------------------
            chatTablView.register(UINib.init(nibName: "UserChatImageByMeCell", bundle: nil), forCellReuseIdentifier: "myImageCell")
            //------------------------- Other User Image Chat-----------------
            chatTablView.register(UINib.init(nibName: "UserChatImageByOtherCell", bundle: nil), forCellReuseIdentifier: "otherImageCell")
            
            //------------------------- My Video Chat-------------------------
            chatTablView.register(UINib.init(nibName: "UserMyChatVideoCell", bundle: nil), forCellReuseIdentifier: "myChatVideo")
            //------------------------- Other user Chat Video-----------------
            chatTablView.register(UINib.init(nibName: "UserOtherChatVideoCell", bundle: nil), forCellReuseIdentifier: "otherChatVideo")
            //------------------------- Other User Video Reply----------------
            chatTablView.register(UINib.init(nibName: "UserOtherVideoReplyCell", bundle: nil), forCellReuseIdentifier: "othervideoReply")
            
            //------------------------- My Video Reply Chat-------------------
            chatTablView.register(UINib.init(nibName: "UserMyVideoReplyCell", bundle: nil), forCellReuseIdentifier: "myvideoReply")
            
            //------------------------- My Image Reply Chat--------------------
            chatTablView.register(UINib.init(nibName: "UserReplyImageCell", bundle: nil), forCellReuseIdentifier: "myReplyImage")
            
            //------------------------- Other User Image Reply Chat------------
            chatTablView.register(UINib.init(nibName: "UserReplyChatOtherCell", bundle: nil), forCellReuseIdentifier: "replyOtherImage")
            //------------------------- My Reported Msg------------------------
            chatTablView.register(UINib.init(nibName: "UserMyReportedMsgCell", bundle: nil), forCellReuseIdentifier: "myMsgReportCell")
            //------------------------- Other User Msg reported----------------
            chatTablView.register(UINib.init(nibName: "UserOtherReportedMsgCell", bundle: nil), forCellReuseIdentifier: "otherMsgReportCell")
            //------------------------- Report Option--------------------------
            reportTblView.register(UITableViewCell.self, forCellReuseIdentifier: "reportoptioncell")
            
            
            //        settingTblView.register(UITableViewCell.self, forCellReuseIdentifier: "settingoptioncell")ReplyImageCell
        }
        func rectForText(text: String, font: UIFont, maxSize: CGSize) -> CGSize {
            let attrString = NSAttributedString.init(string: text, attributes: [NSFontAttributeName:font])
            //        let attrString = NSAttributedString.init(string: text, attributes: [NSAttributedStringKey.font:font])
            let rect = attrString.boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
            let size = CGSize(width:rect.size.width, height:rect.size.height)
            return size
        }
        func notPrettyString(from object: Any) -> String? {
            if let objectData = try? JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions(rawValue: 0)) {
                let objectString = String(data: objectData, encoding: .utf8)
                return objectString
            }
            return nil
        }
        
        func setDatewiseChatList()
        {
            
            self.dateTemp = self.tempDateFormattr.string(from: AppUtility.getDate())
            self.msgArry = self.msgArry.filter({ ($0.created_at != "")})
            self.msgArry = self.msgArry.filter({ ($0.id != "*")})
            NSLog("self.msgArry.count ---\(self.msgArry.count)")
            
            var i = 0
            while i < self.msgArry.count
            {
                let chatobj : ChatUser = self.msgArry[i]
                
                if(chatobj.created_at == "")
                {
                    
                }
                else
                {
                    
                    
                    let date = self.dateFormaatr.date(from: chatobj.created_at!)
                    
                    let dateStr = self.tempDateFormattr.string(from: date!)
                    
                    
                    if(self.dateTemp != dateStr)
                    {
                        self.dateTemp = dateStr
                        
                        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: AppUtility.getDate())
                        let todayDate : String = self.tempDateFormattr.string(from: AppUtility.getDate())
                        let yesterdyDate : String = self.tempDateFormattr.string(from: yesterday!)
                        if(dateStr == todayDate)
                        {
                            //cell.textLabel?.text = "Today"
                            let dateObj : [String : Any] = ["id":"*", "message":"Today"]
                            let chatuser : ChatUser = ChatUser(dateObj)
                            currentDay = "Today"
                            self.msgArry.insert(chatuser, at: i)
                            
                        }
                        else if(dateStr == yesterdyDate)
                        {
                            // cell.textLabel?.text = "Yesterday"
                            let dateObj : [String : Any] = ["id":"*", "message":"Yesterday"]
                            currentDay = "Yesterday"
                            let chatuser : ChatUser = ChatUser(dateObj)
                            self.msgArry.insert(chatuser, at: i)
                            
                        }
                        else
                        {
                            
                            self.newDateFormatter.dateFormat = "MMMM dd"
                            let dateObj : [String : Any] = ["id":"*", "message":String(format:"%@",newDateFormatter.string(from: date!))]
                            let chatuser : ChatUser = ChatUser(dateObj)
                            currentDay = String(format:"%@",newDateFormatter.string(from: date!))
                            self.msgArry.insert(chatuser, at: i)
                            
                        }
                        
                        
                    }
                    
                }
                i = i+1
            }
            
        }
        
        func clearOldDates() {
            
            self.msgArry = self.msgArry.filter({ ($0.id != "*")})
        }
        
        //====================================================================================================
        //MARK: -  DropDown
        //====================================================================================================
        func customizeDropDown(_ sender: AnyObject) {
            
            let appearance = DropDown.appearance()
            
            appearance.cellHeight = 40
            appearance.backgroundColor = UIColor.white
            appearance.selectionBackgroundColor = UIColor(red: 0.6494, green: 0.8155, blue: 1.0, alpha: 0.2)
            appearance.selectionBackgroundColor = hexStringToUIColor(cLightGrey)
            appearance.cornerRadius = 3
            appearance.shadowColor = UIColor(white: 0.6, alpha: 1)
            appearance.shadowOpacity = 0.9
            appearance.shadowRadius = 25
            appearance.animationduration = 0.25
            appearance.textColor = hexStringToUIColor(cDarkGrey)
            appearance.textFont = UIFont(name: fRoboto, size: 14)!
            
            dropDowns.forEach {
                /*** FOR CUSTOM CELLS ***/
                $0.cellNib = UINib(nibName: "MyCell", bundle: nil)
                
                $0.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
                    guard let cell = cell as? MyCell else { return }
                    
                    // Setup your custom UI components
                    cell.optionLabel.textAlignment = .right
                    
                    cell.iconWidthConstraint.constant = 0
                    cell.lblTrailingConstraint.constant = 10
                    
                }
                /*** ---------------- ***/
            }
        }
        func setupChooseArticleDropDown(chooseButton:UIButton) {
            self.view.endEditing(true)
            customizeDropDown(chooseButton)
            dropDown.anchorView = chooseButton
            dropDown.direction = .bottom
            dropDown.width = 150
            dropDown.bottomOffset = CGPoint(x: (chooseButton.bounds.width-155), y: chooseButton.bounds.height)
            dropDown.dataSource = menuOptions
            
            // Action triggered on selection
            dropDown.selectionAction = { [unowned self] (index, item) in
 
            }
        }
        
        
        
        //====================================================================================================
        //MARK: -  IB ACTION
        //====================================================================================================
        
        @IBAction func backAction(_ sender: Any) {
 
            if isFromNotifcation == false {
                _ =  self.navController?.popViewController(animated: true)
            }else{
                self.dismiss(animated: true, completion: nil)
            }
            socket.disconnect()
        }
    @IBAction func favouriteAction(_ sender: Any)  {
        
    }
        @IBAction func moreMenuAction(_ sender: Any) {
 
        }
        @IBAction func showLocationProfileAction(_ sender: Any) {
 
        }
        
        func updateProfileInfo(){

            if friend.profile_pic_thumb != "" {
                let url = URL(string: friend.profile_pic_thumb)
                img_location.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "loading_icon"), options: [SDWebImageOptions.refreshCached,SDWebImageOptions.highPriority,SDWebImageOptions.retryFailed]) { (image, error, cacheType, url) in
                    if error != nil {
                        debugPrint("Failed: \(error)")
                        
                    } else {
                        self.img_location.image = image!
                    }
                }
            }
            lbl_location.text = self.friend.full_name
        }
        
        //====================================================================================================
        //MARK: -  SERVICE CALL
        //====================================================================================================
        
        //Get location complete details
 
    }

    // Chat Module Extensions
    
    extension PChatVC : UITextFieldDelegate
    {
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            if(textField == txtreportReason)
            {
                if(UIScreen.main.bounds.width >= 375)
                {
                    reportTopConstraint.constant = 70
                }
                else
                {
                    reportTopConstraint.constant = 70
                }
                
            }
            return true
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            
            
            if let text = textField.text as NSString? {
                
                let txtAfterUpdate = text.replacingCharacters(in: range, with: string)
                
                if(txtAfterUpdate.trimmingCharacters(in: .whitespacesAndNewlines).length > 0) {
                    bttnSendReport.isEnabled = true
                }
                else {
                    bttnSendReport.isEnabled = false
                }
            }
            return true
        }
    }
    
    extension PChatVC: UITextViewDelegate
    {
        func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
            
            if(textView.text == "Write a message...")
            {
                textView.text = ""
                textView.textColor  = UIColor.black
            }
            return true
        }
        
        func textViewDidChange(_ textView: UITextView) {
            isKeyboardShown = true
            var height = ceil(textView.contentSize.height) // ceil to avoid decimal
            if(textView.text == "Write a message...")
            {
                textView.text = ""
                textView.textColor  = UIColor.black
                
            }
            
            if(textView.text.trimmingCharacters(in: .whitespacesAndNewlines) == "")
            {
                txtviewTrailingConstraint.constant = 5
                txtviewHeightConstraint.constant = 35
                bttnSendChat.isHidden = true
            }
            else
            {
                txtviewTrailingConstraint.constant = 47
                bttnSendChat.isHidden = false
                if (height <= minTextViewHeight + 5) { // min cap, + 5 to avoid tiny height difference at min height
                    height = minTextViewHeight
                    
                    txtviewHeightConstraint.constant = 35
                }
                else if (height > maxTextViewHeight) { // max cap
                    height = maxTextViewHeight
                    
                }
                else
                {
                    self.view.layoutSubviews()
                    self.view.layoutIfNeeded()
                    self.view.setNeedsUpdateConstraints()
                    txtviewHeightConstraint.constant = textView.contentSize.height
                    chatBoxHeightConstraint.constant = txtviewHeightConstraint.constant
                    if(replyViewHeightConstraint.constant == 0)
                    {
                        if(bottomViewHeightConstraint.constant < 106)
                        {
                            
                            bottomViewHeightConstraint.constant = 214 - txtviewHeightConstraint.constant
                            
                            self.txtViewChat.setContentOffset(.zero, animated: true)
                        }
                        else
                        {
                            
                            self.txtViewChat.setContentOffset(.zero, animated: false)
                        }
                        
                    }
                    else
                    {
                        
                        if(replyViewHeightConstraint.constant + txtviewHeightConstraint.constant > 214)
                        {
                            
                            
                            self.txtViewChat.setContentOffset(.zero, animated: false)
                        }
                        else
                        {
                            
                            bottomViewHeightConstraint.constant = 214 - replyViewHeightConstraint.constant + txtviewHeightConstraint.constant
                            
                            self.txtViewChat.setContentOffset(.zero, animated: true)
                        }
                    }
                    
                    
                    self.view.layoutSubviews()
                    self.view.layoutIfNeeded()
                    self.view.setNeedsUpdateConstraints()
                }
            }
            
            
            self.view.layoutSubviews()
            self.view.layoutIfNeeded()
            self.view.setNeedsUpdateConstraints()
            
        }
        func textViewDidEndEditing(_ textView: UITextView) {
            // overlayView.isHidden = true
            isKeyboardShown = false
            if(txtViewChat.text == "Write a message..." || txtViewChat.text == "")
            {
                txtViewChat.text = "Write a message..."
                txtViewChat.textColor = UIColor.lightGray
            }
            else
            {
                
            }
        }
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            
            return true
        }
        
    }
    
    
    extension PChatVC : UITableViewDelegate , UITableViewDataSource
    {
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if(tableView == chatTablView)
            {
                return UITableViewAutomaticDimension
            }
            else if (tableView == reportTblView)
            {
                return 35
            }
            else
            {
                return 50
            }
            
        }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if(tableView == chatTablView)
            {
                return msgArry.count
            }
            else if (tableView == reportTblView)
            {
                return reportOtions.count
            }
            else
            {
                return 0
            }
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            
            timeFormattr.dateFormat = "HH:mm"
            
            newDateFormatter.dateFormat = "MMMM dd, YYYY"
            if(tableView == chatTablView)
            {
                if(indexPath.row < msgArry.count)
                {
                    
                    let chatuser : ChatUser = self.msgArry[indexPath.row]
                    
                    
                    if(chatuser.id == "" || chatuser.id == nil)
                    {
                        
                        let cell : UserDateViewCell = tableView.dequeueReusableCell(withIdentifier: "datebubble", for: indexPath) as! UserDateViewCell
                        // cell.setDateTop(chatObj: chatuser)
                        cell.lblDate.text = chatuser.message
                        cell.selectionStyle = .none
                        cell.backgroundColor = UIColor.clear
                        cell.contentView.backgroundColor = UIColor.clear
                        cell.contentView.isUserInteractionEnabled = false
                        
                        return cell
                    }
                    else
                    {
                        if(chatuser.user_id == userID)
                        {
                            let parentID : Int = Int(chatuser.parent_id!)!
                            if(chatuser.color == 1)
                            {
                                let myCell : UserMyReportedMsgCell = tableView.dequeueReusableCell(withIdentifier: "myMsgReportCell", for: indexPath) as! UserMyReportedMsgCell
                                // myCell.setReportedMessageCell(chatObj: chatuser)
                                let date = dateFormaatr.date(from: chatuser.created_at!)
                                myCell.chattime.text = String(format:"%@",timeFormattr.string(from: date!))
                                
                                myCell.meChatBubbleView.backgroundColor = UIColor.lightGray
                                myCell.meChatBubbleView.layer.shadowOffset = .zero
                                myCell.meChatBubbleView.layer.shadowColor = UIColor.black.cgColor
                                myCell.meChatBubbleView.layer.shadowRadius = 4
                                myCell.meChatBubbleView.layer.shadowOpacity = 0.25
                                myCell.backgroundColor = UIColor.clear
                                myCell.selectionStyle = .none
                                
                                return myCell
                            }
                            else
                            {
                                if(chatuser.attachment_name == "")
                                {
                                    if(parentID > 0 && chatuser.reply != nil)
                                    {
                                        if(chatuser.reply != nil)
                                        {
                                            let likeCount : Int = chatuser.count!
                                            let replyChat : ReplyByUser = chatuser.reply
                                            
                                            if(replyChat.attachment_name == "")
                                            {
                                                let myReplyCell : UserMyMsgReplyCell = tableView.dequeueReusableCell(withIdentifier: "myReplyCell", for: indexPath) as! UserMyMsgReplyCell
                                                
                                                if(chatuser.user_id == userID)
                                                {
//                                                    myReplyCell.otherUSer.text = "You"
                                                }
                                                else
                                                {
//                                                    myReplyCell.otherUSer.attributedText = NSMutableAttributedString(string: replyChat.username!)
                                                }
                                                
                                                if decode(replyChat.message!) != nil{
                                                    let msgReplyText : String = decode(replyChat.message!)!
                                                    myReplyCell.otherMsg.text = msgReplyText
                                                }
                                                else
                                                {
                                                    myReplyCell.otherMsg.text = replyChat.message!
                                                }
                                                
                                                
                                                
                                                let date = dateFormaatr.date(from: chatuser.created_at!)
                                                
                                                myReplyCell.chattime.text = String(format:"%@",timeFormattr.string(from: date!))
                                                if decode(chatuser.message!) != nil{
                                                    let msgText : String = decode(chatuser.message!)!
                                                    myReplyCell.meChatText.text = String(format:"%@",msgText)
                                                }
                                                else
                                                {
                                                    myReplyCell.meChatText.text = String(format:"%@",chatuser.message!)
                                                }
                                                
                                                
                                                
                                                //myCell.leadingConstraint.constant = 110
                                                myReplyCell.viewContainer.frame = CGRect(x:myReplyCell.viewContainer.frame.origin.x,y:myReplyCell.viewContainer.frame.origin.y,width:120,height: myReplyCell.viewContainer.frame.size.height)
                                                myReplyCell.backgroundColor = UIColor.clear
                                                myReplyCell.selectionStyle = .none
                                                let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture(sender:)))
                                                myReplyCell.viewContainer.tag = indexPath.row
                                                myReplyCell.viewContainer.addGestureRecognizer(longPress)
                                                myReplyCell.lblNoOfLikes.isHidden = true
                                                myReplyCell.likecountHeight.constant = 0
                                                myReplyCell.imgLikes.isHidden = true
                                                
                                                if(likeCount > 0)
                                                {
                                                    myReplyCell.lblNoOfLikes.isHidden = false
                                                    myReplyCell.likecountHeight.constant = 15
                                                    myReplyCell.imgLikes.isHidden = false
                                                    if(likeCount > 1)
                                                    {
                                                        myReplyCell.lblNoOfLikes.text = String(format:"%d likes",likeCount)
                                                    }
                                                    else
                                                    {
                                                        myReplyCell.lblNoOfLikes.text = String(format:"%d like",likeCount)
                                                    }
                                                    
                                                }
                                                
                                                NSLog("viewContainer --- \(myReplyCell.viewContainer.frame.size.width)")
                                                
                                                
                                                
                                                myReplyCell.meChatBubbleView.layer.shadowOffset = .zero
                                                myReplyCell.meChatBubbleView.layer.shadowColor = UIColor.black.cgColor
                                                myReplyCell.meChatBubbleView.layer.shadowRadius = 4
                                                myReplyCell.meChatBubbleView.layer.shadowOpacity = 0.25
                                                // myReplyCell.meChatBubbleView = self.setShadowToView(view: myReplyCell.meChatBubbleView)
                                                return myReplyCell
                                            }
                                            else
                                            {
                                                if(replyChat.attachment_name?.lowercased() == "video")
                                                {
                                                    let myvideoReply : UserMyVideoReplyCell = tableView.dequeueReusableCell(withIdentifier: "myvideoReply", for: indexPath) as! UserMyVideoReplyCell
                                                    
                                                    if(chatuser.user_id == userID)
                                                    {
                                                        myvideoReply.otherUSer.text = "You"
                                                    }
                                                    else
                                                    {
                                                        myvideoReply.otherUSer.attributedText = NSMutableAttributedString(string: replyChat.username!)
                                                    }
                                                    
                                                    let date = dateFormaatr.date(from: chatuser.created_at!)
                                                    
                                                    myvideoReply.chattime.text = String(format:"%@",timeFormattr.string(from: date!))
                                                    if decode(chatuser.message!) != nil
                                                    {
                                                        let msgText : String = decode(chatuser.message!)!
                                                        myvideoReply.meChatText.text = String(format:"%@",msgText)
                                                    }
                                                    else
                                                    {
                                                        myvideoReply.meChatText.text = String(format:"%@",chatuser.message!)
                                                    }
                                                    
                                                    myvideoReply.backgroundColor = UIColor.clear
                                                    myvideoReply.selectionStyle = .none
                                                    
                                                    myvideoReply.bttnVideo.tag = indexPath.row+200
                                                    myvideoReply.bttnVideo.addTarget(self, action: #selector(bttnmyReplyVideo(sender:)), for: .touchUpInside)
                                                    
                                                    let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture(sender:)))
                                                    myvideoReply.viewContainer.tag = indexPath.row
                                                    myvideoReply.viewContainer.addGestureRecognizer(longPress)
                                                    myvideoReply.lblNoOfLikes.isHidden = true
                                                    myvideoReply.likecountHeight.constant = 0
                                                    myvideoReply.imgLikes.isHidden = true
                                                    if(likeCount > 0)
                                                    {
                                                        myvideoReply.lblNoOfLikes.isHidden = false
                                                        myvideoReply.likecountHeight.constant = 15
                                                        myvideoReply.imgLikes.isHidden = false
                                                        if(likeCount > 1)
                                                        {
                                                            myvideoReply.lblNoOfLikes.text = String(format:"%d likes",likeCount)
                                                        }
                                                        else
                                                        {
                                                            myvideoReply.lblNoOfLikes.text = String(format:"%d like",likeCount)
                                                        }
                                                        
                                                    }
                                                    let videoName : String = replyChat.video!
                                                    
                                                    if( videoName != "")
                                                    {
                                                        let url = NSURL(string: String(format:"%@%@",videoBaseURL,replyChat.video!))
                                                        
                                                        let avPlayer = AVPlayer(url: url! as URL)
                                                        myvideoReply.playerView?.playerLayer.player = avPlayer
                                                        
                                                        //                                                    myvideoReply.playerView?.playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                                                        myvideoReply.playerView?.playerLayer.masksToBounds = true
                                                    }
                                                    
                                                    myvideoReply.meChatBubbleView.layer.shadowOffset = .zero
                                                    myvideoReply.meChatBubbleView.layer.shadowColor = UIColor.black.cgColor
                                                    myvideoReply.meChatBubbleView.layer.shadowRadius = 4
                                                    myvideoReply.meChatBubbleView.layer.shadowOpacity = 0.25
                                                    
                                                    return myvideoReply
                                                }
                                                if(replyChat.attachment_name?.lowercased() == "image")
                                                {
                                                    let myReplyImage : UserReplyImageCell = tableView.dequeueReusableCell(withIdentifier: "myReplyImage", for: indexPath) as! UserReplyImageCell
                                                    
                                                    if(chatuser.user_id == userID)
                                                    {
                                                        myReplyImage.otherUSer.text = "You"
                                                    }
                                                    else
                                                    {
                                                        myReplyImage.otherUSer.attributedText = NSMutableAttributedString(string: replyChat.username!)
                                                    }
                                                    
                                                    let date = dateFormaatr.date(from: chatuser.created_at!)
                                                    
                                                    myReplyImage.chattime.text = String(format:"%@",timeFormattr.string(from: date!))
                                                    if decode(chatuser.message!) != nil
                                                    {
                                                        let msgText : String = decode(chatuser.message!)!
                                                        myReplyImage.meChatText.text = String(format:"%@",msgText)
                                                    }
                                                    else
                                                    {
                                                        myReplyImage.meChatText.text = String(format:"%@",chatuser.message!)
                                                    }
                                                    
                                                    
                                                    
                                                    //myCell.leadingConstraint.constant = 110
                                                    
                                                    myReplyImage.backgroundColor = UIColor.clear
                                                    myReplyImage.selectionStyle = .none
                                                    let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture(sender:)))
                                                    myReplyImage.viewContainer.tag = indexPath.row
                                                    myReplyImage.viewContainer.addGestureRecognizer(longPress)
                                                    myReplyImage.lblNoOfLikes.isHidden = true
                                                    myReplyImage.likecountHeight.constant = 0
                                                    myReplyImage.imgLikes.isHidden = true
                                                    if(likeCount > 0)
                                                    {
                                                        myReplyImage.lblNoOfLikes.isHidden = false
                                                        myReplyImage.likecountHeight.constant = 15
                                                        myReplyImage.imgLikes.isHidden = false
                                                        if(likeCount > 1)
                                                        {
                                                            myReplyImage.lblNoOfLikes.text = String(format:"%d likes",likeCount)
                                                        }
                                                        else
                                                        {
                                                            myReplyImage.lblNoOfLikes.text = String(format:"%d like",likeCount)
                                                        }
                                                        
                                                    }
                                                    let imgName : String = replyChat.logo!
                                                    if(imgName != "")
                                                    {
                                                        
                                                        let url : URL = URL(string: String(format:"%@%@",imageThumbURL, imgName))!
                                                        
                                                        //myReplyImage.imgView.sd_addActivityIndicator()
                                                        //myReplyImage.imgView.sd_setIndicatorStyle(.gray)
                                                        myReplyImage.imgView.kf.indicatorType = .activity
                                                        myReplyImage.imgView.kf.setImage(with: url)
                                                        
                                                        
                                                    }
                                                    else
                                                    {
                                                        myReplyImage.imgView.image = UIImage(named:"no_Preview")
                                                    }
                                                    myReplyImage.bttnImgPreview.tag = indexPath.row+6000000
                                                    myReplyImage.bttnImgPreview.addTarget(self, action: #selector(bttnImagePreview(sender:)), for: .touchUpInside)
                                                    myReplyImage.meChatBubbleView.layer.shadowOffset = .zero
                                                    myReplyImage.meChatBubbleView.layer.shadowColor = UIColor.black.cgColor
                                                    myReplyImage.meChatBubbleView.layer.shadowRadius = 4
                                                    myReplyImage.meChatBubbleView.layer.shadowOpacity = 0.25
                                                    
                                                    return myReplyImage
                                                }
                                            }
                                        }
                                        
                                        
                                    }
                                    else
                                    {
                                        let likeCount : Int = chatuser.count!
                                        let myCell : UserChatByMeCell = tableView.dequeueReusableCell(withIdentifier: "chatbymeCell", for: indexPath) as! UserChatByMeCell
                                        let date = dateFormaatr.date(from: chatuser.created_at!)
                                        myCell.chattime.text = String(format:"%@",timeFormattr.string(from: date!))
                                        if decode(chatuser.message!) != nil
                                        {
                                            let msgText : String = decode(chatuser.message!)!
                                            myCell.meChatText.text = String(format:"%@",msgText)
                                        }
                                        else
                                        {
                                            myCell.meChatText.text = String(format:"%@",chatuser.message!)
                                        }
                                        
                                        
                                        
                                        myCell.meChatText.font = UIFont.systemFont(ofSize: 15.0)
                                        //myCell.leadingConstraint.constant = 110
                                        myCell.viewContainer.frame = CGRect(x:myCell.viewContainer.frame.origin.x,y:myCell.viewContainer.frame.origin.y,width:120,height: myCell.viewContainer.frame.size.height)
                                        myCell.backgroundColor = UIColor.clear
                                        myCell.selectionStyle = .none
                                        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture(sender:)))
                                        myCell.viewContainer.tag = indexPath.row
                                        myCell.viewContainer.addGestureRecognizer(longPress)
                                        myCell.lblNoOfLikes.isHidden = true
                                        myCell.likecountHeight.constant = 0
                                        myCell.imgLikes.isHidden = true
                                        
                                        
                                        
                                        if(likeCount > 0)
                                        {
                                            myCell.lblNoOfLikes.isHidden = false
                                            myCell.likecountHeight.constant = 15
                                            myCell.imgLikes.isHidden = false
                                            if(likeCount > 1)
                                            {
                                                myCell.lblNoOfLikes.text = String(format:"%d likes",likeCount)
                                            }
                                            else
                                            {
                                                myCell.lblNoOfLikes.text = String(format:"%d like",likeCount)
                                            }
                                            
                                        }
                                        if(myCell.leadingConstraint.constant < 50)
                                        {
                                            myCell.leadingConstraint.constant = 50
                                        }
                                        NSLog("myCell.leadingConstraint.constant --- \(myCell.leadingConstraint.constant)")
                                        myCell.meChatBubbleView.backgroundColor = UIColor.init(hex: "cce6fd")
                                        
                                        myCell.meChatBubbleView.layer.shadowOffset = .zero
                                        myCell.meChatBubbleView.layer.shadowColor = UIColor.black.cgColor
                                        myCell.meChatBubbleView.layer.shadowRadius = 4
                                        myCell.meChatBubbleView.layer.shadowOpacity = 0.25
                                        
                                        return myCell
                                    }
                                }
                                else
                                {
                                    if(chatuser.attachment_name?.lowercased() == "image")
                                    {
                                        let myImageCell : UserChatImageByMeCell = tableView.dequeueReusableCell(withIdentifier: "myImageCell", for: indexPath) as! UserChatImageByMeCell
                                        let date = dateFormaatr.date(from: chatuser.created_at!)
                                        let likeCount : Int = chatuser.count!
                                        myImageCell.lblTime.text = String(format:"%@",timeFormattr.string(from: date!))
                                        myImageCell.lblCountLikes.isHidden = true
                                        myImageCell.likecountHeight.constant = 0
                                        myImageCell.imgLike.isHidden = true
                                        if(likeCount > 0)
                                        {
                                            myImageCell.lblCountLikes.isHidden = false
                                            myImageCell.likecountHeight.constant = 15
                                            myImageCell.imgLike.isHidden = false
                                            if(likeCount > 1)
                                            {
                                                myImageCell.lblCountLikes.text = String(format:"%d likes",likeCount)
                                            }
                                            else
                                            {
                                                myImageCell.lblCountLikes.text = String(format:"%d like",likeCount)
                                            }
                                            
                                        }
                                        let imgName : String = chatuser.logo!
                                        myImageCell.imgView.image = nil
                                        if(imgName != "")
                                        {
                                            
                                            let url : URL = URL(string: String(format:"%@%@",imageThumbURL,imgName))!
                                            
                                            //myImageCell.imgView.sd_addActivityIndicator()
                                            //myImageCell.imgView.sd_setIndicatorStyle(.gray)
                                            myImageCell.imgView.kf.indicatorType = .activity
                                            myImageCell.imgView.kf.setImage(with: url)
                                            
                                        }
                                        else
                                        {
                                            
                                            myImageCell.imgView.image = UIImage(named:"no_Preview")
                                        }
                                        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture(sender:)))
                                        myImageCell.viewContainer.tag = indexPath.row
                                        myImageCell.viewContainer.addGestureRecognizer(longPress)
                                        
                                        
                                        myImageCell.bttnImgPreview.tag = indexPath.row+6000000
                                        myImageCell.bttnImgPreview.addTarget(self, action: #selector(bttnImagePreview(sender:)), for: .touchUpInside)
                                        
                                        myImageCell.chatBubbleView.layer.shadowOffset = .zero
                                        myImageCell.chatBubbleView.layer.shadowColor = UIColor.black.cgColor
                                        myImageCell.chatBubbleView.layer.shadowRadius = 4
                                        myImageCell.chatBubbleView.layer.shadowOpacity = 0.25
                                        myImageCell.backgroundColor = UIColor.clear
                                        myImageCell.selectionStyle = .none
                                        return myImageCell
                                    }
                                    if(chatuser.attachment_name?.lowercased() == "video")
                                    {
                                        let myVideoCell : UserMyChatVideoCell = tableView.dequeueReusableCell(withIdentifier: "myChatVideo", for: indexPath) as! UserMyChatVideoCell
                                        let date = dateFormaatr.date(from: chatuser.created_at!)
                                        myVideoCell.chtaTime.text = String(format:"%@",timeFormattr.string(from: date!))
                                        let likeCount : Int = chatuser.count!
                                        let videoName : String = chatuser.video!
                                        if(videoName != "")
                                        {
                                            let url = NSURL(string: String(format:"%@%@",videoBaseURL,chatuser.video!))
                                            
                                            let avPlayer = AVPlayer(url: url! as URL)
                                            myVideoCell.playerView?.playerLayer.player = avPlayer
                                            
                                            //                                        myVideoCell.playerView?.playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                                            myVideoCell.playerView?.playerLayer.masksToBounds = true
                                        }
                                        myVideoCell.lblCountLikes.isHidden = true
                                        myVideoCell.likecountHeight.constant = 0
                                        myVideoCell.imgLike.isHidden = true
                                        if(likeCount > 0)
                                        {
                                            myVideoCell.lblCountLikes.isHidden = false
                                            myVideoCell.likecountHeight.constant = 0
                                            myVideoCell.imgLike.isHidden = false
                                            if(likeCount > 1)
                                            {
                                                myVideoCell.lblCountLikes.text = String(format:"%d likes",likeCount)
                                            }
                                            else
                                            {
                                                myVideoCell.lblCountLikes.text = String(format:"%d like",likeCount)
                                            }
                                            
                                        }
                                        myVideoCell.bttnPlayPauseVideo.tag = indexPath.row+50000
                                        myVideoCell.bttnPlayPauseVideo.addTarget(self, action: #selector(bttnPlayPauseVideoSender(sender:)), for: .touchUpInside)
                                        
                                        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture(sender:)))
                                        myVideoCell.playerView.tag = indexPath.row
                                        myVideoCell.playerView.addGestureRecognizer(longPress)
                                        
                                        myVideoCell.chatBubble.layer.shadowOffset = .zero
                                        myVideoCell.chatBubble.layer.shadowColor = UIColor.black.cgColor
                                        myVideoCell.chatBubble.layer.shadowRadius = 4
                                        myVideoCell.chatBubble.layer.shadowOpacity = 0.25
                                        myVideoCell.backgroundColor = UIColor.clear
                                        myVideoCell.selectionStyle = .none
                                        return myVideoCell
                                    }
                                }
                            }
                            
                            
                            
                            
                        }
                        else
                        {
                            var parentID : Int =  0
                            if(chatuser.parent_id != nil)
                            {
                                parentID = Int(chatuser.parent_id!)!
                            }
                            let likeCount : Int = chatuser.count!
                            
                            var is_like:Int = 0
                            if(chatuser.is_like != nil)
                            {
                                is_like = Int(chatuser.is_like!)!
                            }
                            
                            if(chatuser.color == 1)
                            {
                                let otherCell : UserOtherReportedMsgCell = tableView.dequeueReusableCell(withIdentifier: "otherMsgReportCell", for: indexPath) as! UserOtherReportedMsgCell
                                let date = dateFormaatr.date(from: chatuser.created_at!)
                                otherCell.chatTime.text = String(format:"%@",timeFormattr.string(from: date!))
                                otherCell.userName.attributedText = NSMutableAttributedString(string: chatuser.username!)
//                                otherCell.userStatus.image = kAppDelegate.setUserStatus(status: friend.status)
//                                setUserImage(imgView:otherCell.userImg,urlStr: friend.profile_pic_thumb)
                                
                                otherCell.otherChatBubbleView.layer.shadowOffset = .zero
                                otherCell.otherChatBubbleView.layer.shadowColor = UIColor.black.cgColor
                                otherCell.otherChatBubbleView.layer.shadowRadius = 4
                                otherCell.otherChatBubbleView.layer.shadowOpacity = 0.25
                                otherCell.backgroundColor = UIColor.clear
                                otherCell.selectionStyle = .none
                                
                                otherCell.otherChatBubbleView.backgroundColor = UIColor.lightGray
                                return otherCell
                            }
                            else
                            {
  
                                if(chatuser.attachment_name == "")
                                {
                                    if(parentID > 0 && chatuser.reply != nil)
                                    {
                                        if(chatuser.reply != nil)
                                        {
                                            let replyChat : ReplyByUser = chatuser.reply
                                            if(replyChat.attachment_name == "")
                                            {
                                                let otherReplyCell : UserReplyViewCell = tableView.dequeueReusableCell(withIdentifier: "replyotherCell", for: indexPath) as! UserReplyViewCell
                                                otherReplyCell.replyView.clipsToBounds = true
                                                
                                                if(chatuser.user_id == userID)
                                                {
//                                                    otherReplyCell.otherUser.text = String(format:"You")
                                                }
                                                else
                                                {
                                                    
//                                                    otherReplyCell.otherUser.attributedText = NSMutableAttributedString(string: replyChat.username!)
                                                }
                                                if decode(replyChat.message!) != nil
                                                {
                                                    let msgReplyText : String = decode(replyChat.message!)!
                                                    otherReplyCell.otherMsg.text = String(format:"%@",msgReplyText)
                                                }
                                                else
                                                {
                                                    otherReplyCell.otherMsg.text = String(format:"%@",replyChat.message!)
                                                }
//                                                otherReplyCell.newConnection.isHidden = true
//                                                otherReplyCell.userConnection.isHidden = true
                                                if(friend != nil)
                                                {
                                                    if(friend.is_friend == 1)
                                                    {
//                                                        otherReplyCell.newConnection.isHidden = false
//                                                        otherReplyCell.userConnection.isHidden = false
                                                        
                                                        
                                                    }
                                                    else
                                                    {
//                                                        otherReplyCell.newConnection.isHidden = true
//                                                        otherReplyCell.userConnection.isHidden = true
                                                    }
                                                }
                                                
                                                
                                                let date = dateFormaatr.date(from: chatuser.created_at!)
                                                otherReplyCell.chatTime.text = String(format:"%@",timeFormattr.string(from: date!))
//                                                otherReplyCell.userName.attributedText = NSMutableAttributedString(string: chatuser.username!)
                                                
                                                //otherReplyCell.userName.font = UIFont(name: "Roboto-Bold", size: 10.0)'
                                                if decode(chatuser.message!) != nil
                                                {
                                                    let msgText : String = decode(chatuser.message!)!
                                                    otherReplyCell.userChatText.text = String(format:"%@",msgText)
                                                }
                                                else
                                                {
                                                    otherReplyCell.userChatText.text = String(format:"%@",chatuser.message!)
                                                }
                                                
                                                otherReplyCell.backgroundColor = UIColor.clear
                                                //otherCell.chatContainer.backgroundColor = UIColor.clear
                                                otherReplyCell.selectionStyle = .none
                                                
                                                let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture(sender:)))
                                                otherReplyCell.chatContainer.tag = indexPath.row
                                                otherReplyCell.chatContainer.addGestureRecognizer(longPress)
//                                                otherReplyCell.noOfLikes.isHidden = true
//                                                otherReplyCell.likecountHeight.constant = 0
                                                if(is_like == 0)
                                                {
//                                                    otherReplyCell.bttnLike.setImage(UIImage(named:"like-other_and"), for: .normal)
                                                    
                                                }
                                                else
                                                {
//                                                    otherReplyCell.bttnLike.setImage(UIImage(named:"like_and"), for: .normal)
                                                }
                                                if(likeCount > 0)
                                                {
//                                                    otherReplyCell.noOfLikes.isHidden = false
//                                                    otherReplyCell.likecountHeight.constant = 20
                                                    if(likeCount > 1)
                                                    {
//                                                        otherReplyCell.noOfLikes.text = String(format:"%d likes",likeCount)
                                                    }
                                                    else
                                                    {
//                                                        otherReplyCell.noOfLikes.text = String(format:"%d like",likeCount)
                                                    }
                                                }
//                                                otherReplyCell.bttnLike.addTarget(self, action: #selector(likeMessageAction(sender:)), for: .touchUpInside)
//                                                otherReplyCell.bttnLike.tag = indexPath.row+2000
//
                                                
                                                //otherReplyCell.otherUser.font = UIFont(name: "Roboto-Bold", size: 10.0)
                                                otherReplyCell.chatBubble.layer.shadowOffset = .zero
                                                otherReplyCell.chatBubble.layer.shadowColor = UIColor.black.cgColor
                                                otherReplyCell.chatBubble.layer.shadowRadius = 4
                                                otherReplyCell.chatBubble.layer.shadowOpacity = 0.25
                                                // otherReplyCell.chatBubble = self.setShadowToView(view: otherReplyCell.chatBubble)
                                                
//                                                otherReplyCell.userStatus.image = kAppDelegate.setUserStatus(status: friend.status)
//                                                setUserImage(imgView:otherReplyCell.userImg,urlStr: friend.profile_pic_thumb)
                                                return otherReplyCell
                                            }
                                            else
                                            {
                                                if(replyChat.attachment_name?.lowercased() == "image")
                                                {
                                                    let otherReplyImageCell : UserReplyChatOtherCell = tableView.dequeueReusableCell(withIdentifier: "replyOtherImage", for: indexPath) as! UserReplyChatOtherCell
                                                    // let likeCount : Int = chatuser.count!
                                                    //let is_like : Int = Int(chatuser.is_like!)!
                                                    let date = dateFormaatr.date(from: chatuser.created_at!)
//                                                    otherReplyImageCell.userName.attributedText = NSMutableAttributedString(string: chatuser.username!)
                                                    if(chatuser.user_id == userID)
                                                    {
//                                                        otherReplyImageCell.otherUser.text = "You"
                                                    }
                                                    else
                                                    {
//                                                        otherReplyImageCell.otherUser.attributedText = NSMutableAttributedString(string: replyChat.username!)
                                                    }
                                                    if decode(chatuser.message!) != nil
                                                    {
                                                        let msgText : String = decode(chatuser.message!)!
                                                        otherReplyImageCell.userChatText.text = String(format:"%@",msgText)
                                                    }
                                                    else
                                                    {
                                                        otherReplyImageCell.userChatText.text = String(format:"%@",chatuser.message!)
                                                    }
//                                                    otherReplyImageCell.newConnection.isHidden = true
//                                                    otherReplyImageCell.userConnection.isHidden = true
                                                    if(friend != nil)
                                                    {
                                                        if(friend.is_friend == 1)
                                                        {
//                                                            otherReplyImageCell.newConnection.isHidden = false
//                                                            otherReplyImageCell.userConnection.isHidden = true
                                                            
                                                            
                                                        }
                                                        else
                                                        {
//                                                            otherReplyImageCell.newConnection.isHidden = true
//                                                            otherReplyImageCell.userConnection.isHidden = true
                                                        }
                                                    }
                                                    
                                                    
                                                    otherReplyImageCell.chatTime.text = String(format:"%@",timeFormattr.string(from: date!))
//                                                    otherReplyImageCell.noOfLikes.isHidden = true
//                                                    otherReplyImageCell.likecountHeight.constant = 0
                                                    if(is_like == 0)
                                                    {
//                                                        otherReplyImageCell.bttnLike.setImage(UIImage(named:"like-other_and"), for: .normal)
                                                        
                                                    }
                                                    else
                                                    {
//                                                        otherReplyImageCell.bttnLike.setImage(UIImage(named:"like_and"), for: .normal)
                                                    }
                                                    if(likeCount > 0)
                                                    {
//                                                        otherReplyImageCell.noOfLikes.isHidden = false
//                                                        otherReplyImageCell.likecountHeight.constant = 16
                                                        if(likeCount > 1)
                                                        {
//                                                            otherReplyImageCell.noOfLikes.text = String(format:"%d likes",chatuser.count!)
                                                        }
                                                        else
                                                        {
//                                                            otherReplyImageCell.noOfLikes.text = String(format:"%d like",chatuser.count!)
                                                        }
                                                    }
                                                    let imgName : String = replyChat.logo!
                                                    otherReplyImageCell.imgView.image = nil
                                                    if(imgName != "")
                                                    {
                                                        let url : URL = URL(string: String(format:"%@%@",imageThumbURL,imgName))!
                                                        //otherReplyImageCell.imgView.sd_addActivityIndicator()
                                                        //otherReplyImageCell.imgView.sd_setIndicatorStyle(.gray)
                                                        otherReplyImageCell.imgView.kf.indicatorType = .activity
                                                        otherReplyImageCell.imgView.kf.setImage(with: url)
                                                    }
                                                    else
                                                    {
                                                        otherReplyImageCell.imgView.image = UIImage(named:"no_Preview")
                                                    }
//                                                    otherReplyImageCell.bttnLike.addTarget(self, action: #selector(likeMessageAction(sender:)), for: .touchUpInside)
//                                                    otherReplyImageCell.bttnLike.tag = indexPath.row+2000
                                                    otherReplyImageCell.bttnImgPreview.tag = indexPath.row+6000000
                                                    otherReplyImageCell.bttnImgPreview.addTarget(self, action: #selector(bttnImagePreview(sender:)), for: .touchUpInside)
                                                    
                                                    let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture(sender:)))
                                                    otherReplyImageCell.chatContainer.tag = indexPath.row
                                                    otherReplyImageCell.chatContainer.addGestureRecognizer(longPress)
                                                    otherReplyImageCell.chatBubble.layer.shadowOffset = .zero
                                                    otherReplyImageCell.chatBubble.layer.shadowColor = UIColor.black.cgColor
                                                    otherReplyImageCell.chatBubble.layer.shadowRadius = 4
                                                    otherReplyImageCell.chatBubble.layer.shadowOpacity = 0.25
                                                    otherReplyImageCell.backgroundColor = UIColor.clear
                                                    otherReplyImageCell.selectionStyle = .none
//                                                    otherReplyImageCell.userStatus.image = kAppDelegate.setUserStatus(status: friend.status)
//                                                    setUserImage(imgView:otherReplyImageCell.userImg,urlStr: friend.profile_pic_thumb)
                                                    return otherReplyImageCell
                                                }
                                                if(replyChat.attachment_name?.lowercased() == "video")
                                                {
                                                    let otherReplyVideoCell : UserOtherVideoReplyCell = tableView.dequeueReusableCell(withIdentifier: "othervideoReply", for: indexPath) as! UserOtherVideoReplyCell
                                                    
                                                    let is_likee : Int = Int(chatuser.is_like!)!
                                                    
                                                    let date = dateFormaatr.date(from: chatuser.created_at!)
                                                    otherReplyVideoCell.userName.attributedText = NSMutableAttributedString(string: chatuser.username!)
                                                    if(chatuser.user_id == userID)
                                                    {
                                                        otherReplyVideoCell.otherUser.text = "You"
                                                    }
                                                    else
                                                    {
                                                        otherReplyVideoCell.otherUser.attributedText = NSMutableAttributedString(string: replyChat.username!)
                                                    }
                                                    if decode(chatuser.message!) != nil
                                                    {
                                                        let msgText : String = decode(replyChat.message!)!
                                                        otherReplyVideoCell.userChatText.text = String(format:"%@",msgText)
                                                    }
                                                    else
                                                    {
                                                        otherReplyVideoCell.userChatText.text = String(format:"%@",chatuser.message!)
                                                    }
                                                    otherReplyVideoCell.newConnection.isHidden = true
                                                    otherReplyVideoCell.userConnection.isHidden = true
                                                    if(friend != nil)
                                                    {
                                                        if(friend.is_friend == 1)
                                                        {
                                                            otherReplyVideoCell.newConnection.isHidden = false
                                                            otherReplyVideoCell.userConnection.isHidden = true
                                                        }
                                                        else
                                                        {
                                                            otherReplyVideoCell.newConnection.isHidden = true
                                                            otherReplyVideoCell.userConnection.isHidden = true
                                                        }
                                                    }
                                                    
                                                    otherReplyVideoCell.chatTime.text = String(format:"%@",timeFormattr.string(from: date!))
                                                    otherReplyVideoCell.noOfLikes.isHidden = true
                                                    otherReplyVideoCell.likecountHeight.constant = 0
                                                    if(is_likee == 0)
                                                    {
                                                        otherReplyVideoCell.bttnLike.setImage(UIImage(named:"like-other_and"), for: .normal)
                                                        
                                                    }
                                                    else
                                                    {
                                                        otherReplyVideoCell.bttnLike.setImage(UIImage(named:"like_and"), for: .normal)
                                                    }
                                                    if(likeCount > 0)
                                                    {
                                                        otherReplyVideoCell.noOfLikes.isHidden = false
                                                        otherReplyVideoCell.likecountHeight.constant = 16
                                                        if(likeCount > 1)
                                                        {
                                                            otherReplyVideoCell.noOfLikes.text = String(format:"%d likes",chatuser.count!)
                                                        }
                                                        else
                                                        {
                                                            otherReplyVideoCell.noOfLikes.text = String(format:"%d like",chatuser.count!)
                                                        }
                                                    }
                                                    
                                                    if(replyChat.video != nil || replyChat.video != "")
                                                    {
                                                        let url = NSURL(string: String(format:"%@%@",videoBaseURL,replyChat.video!))
                                                        
                                                        let avPlayer = AVPlayer(url: url! as URL)
                                                        otherReplyVideoCell.playerView?.playerLayer.player = avPlayer
                                                        
                                                        //                                                    otherReplyVideoCell.playerView?.playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                                                        otherReplyVideoCell.playerView?.playerLayer.masksToBounds = true
                                                    }
                                                    otherReplyVideoCell.bttnLike.addTarget(self, action: #selector(likeMessageAction(sender:)), for: .touchUpInside)
                                                    otherReplyVideoCell.bttnLike.tag = indexPath.row+2000
                                                    otherReplyVideoCell.bttnVideoPlay.tag = indexPath.row+200000
                                                    otherReplyVideoCell.bttnVideoPlay.addTarget(self, action: #selector(bttnOtherReplyVideo(sender:)), for: .touchUpInside)
                                                    let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture(sender:)))
                                                    otherReplyVideoCell.playerView.tag = indexPath.row
                                                    otherReplyVideoCell.playerView.addGestureRecognizer(longPress)
                                                    otherReplyVideoCell.chatBubble.layer.shadowOffset = .zero
                                                    otherReplyVideoCell.chatBubble.layer.shadowColor = UIColor.black.cgColor
                                                    otherReplyVideoCell.chatBubble.layer.shadowRadius = 4
                                                    otherReplyVideoCell.chatBubble.layer.shadowOpacity = 0.25
                                                    otherReplyVideoCell.backgroundColor = UIColor.clear
                                                    otherReplyVideoCell.selectionStyle = .none
//                                                    otherReplyVideoCell.userStatus.image = kAppDelegate.setUserStatus(status: friend.status)
//                                                    setUserImage(imgView:otherReplyVideoCell.userImg,urlStr: friend.profile_pic_thumb)
                                                    return otherReplyVideoCell
                                                }
                                            }
                                        }
                                        
                                        
                                    }
                                    else
                                    {
                                        let otherCell : UserChatByOtherCell = tableView.dequeueReusableCell(withIdentifier: "chatbyotherCell", for: indexPath) as! UserChatByOtherCell
                                        let date = dateFormaatr.date(from: chatuser.created_at!)
                                        otherCell.chatTime.text = String(format:"%@",timeFormattr.string(from: date!))
//                                        otherCell.userName.attributedText = NSMutableAttributedString(string: chatuser.username!)
//                                        self.friendNameWithDegree(name: String(format:"%@",chatuser.username!))
//                                        otherCell.userStatus.image = kAppDelegate.setUserStatus(status: friend.status)
//                                        setUserImage(imgView:otherCell.userImg,urlStr: friend.profile_pic_thumb)
                                        //otherCell.userName.font = UIFont(name: "Roboto-Bold", size: 10.0)
                                        if decode(chatuser.message!) != nil
                                        {
                                            let msgText : String = decode(chatuser.message!)!
                                            otherCell.userChatText.text = String(format:"%@",msgText)
                                        }
                                        else
                                        {
                                            otherCell.userChatText.text = String(format:"%@",chatuser.message!)
                                        }
                                        
                                        let widthChat : CGFloat = self.widthForLabel(text: otherCell.userChatText.text!, font: otherCell.userChatText.font, height: 15)
//                                          let widthChat : CGFloat = chatuser.message!.widthWithConstrainedHeight(height: 15, font: otherCell.userChatText.font)
//                                        let widthUsername : CGFloat = self.widthForLabel(text: otherCell.userName.text!, font: otherCell.userName.font, height: 15)
                                        
                                        otherCell.trailingConstraint.isActive = false
                                        if(widthChat+30 > (UIScreen.main.bounds.size.width))
                                        {
                                            otherCell.trailingConstraint.constant = 95
                                            
                                        }
                                        else
                                        {
                                            if(widthChat < 50)
                                            {
                                                otherCell.trailingConstraint.constant = (UIScreen.main.bounds.size.width ) - (widthChat+(70-widthChat))
                                            }
                                            else
                                            {
                                                otherCell.trailingConstraint.constant = (UIScreen.main.bounds.size.width ) - (widthChat+20)
                                            }
                                            if(otherCell.trailingConstraint.constant < 20)
                                            {
                                                otherCell.trailingConstraint.constant = 85
                                            }
                                           
                                            otherCell.updateConstraints()
                                        }
                                        
                                        otherCell.trailingConstraint.isActive = true
                                        otherCell.layoutSubviews()
                                        otherCell.layoutIfNeeded()
                                        otherCell.setNeedsUpdateConstraints()
                                        chatTablView.layoutIfNeeded()
                                        self.view.layoutIfNeeded()
                                        
                                        otherCell.backgroundColor = UIColor.clear
                                        //otherCell.chatContainer.backgroundColor = UIColor.clear
                                        otherCell.selectionStyle = .none
                                        
                                        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture(sender:)))
                                        otherCell.chatContainer.tag = indexPath.row
                                        otherCell.chatContainer.addGestureRecognizer(longPress)
//                                        otherCell.noOfLikes.isHidden = true
//                                        otherCell.likecountHeight.constant = 0
                                        if(is_like == 0)
                                        {
//                                            otherCell.bttnLike.setImage(UIImage(named:"like-other_and"), for: .normal)
                                        }
                                        else
                                        {
//                                            otherCell.bttnLike.setImage(UIImage(named:"like_and"), for: .normal)
                                        }
                                        if(likeCount > 0)
                                        {
//                                            otherCell.noOfLikes.isHidden = false
//                                            otherCell.likecountHeight.constant = 16
                                            if(likeCount > 1)
                                            {
//                                                otherCell.noOfLikes.text = String(format:"%d likes",chatuser.count!)
                                            }
                                            else
                                            {
//                                                otherCell.noOfLikes.text = String(format:"%d like",chatuser.count!)
                                            }
                                        }
//                                        otherCell.newConnection.isHidden = true
//                                        otherCell.userConnection.isHidden = true
                                        if(friend != nil)
                                        {
                                            if(friend.is_friend == 1)
                                            {
//                                                otherCell.newConnection.isHidden = false
//                                                otherCell.userConnection.isHidden = false
                                            }
                                            else
                                            {
//                                                otherCell.newConnection.isHidden = true
//                                                otherCell.userConnection.isHidden = true
                                            }
                                        }
//                                        otherCell.bttnLike.addTarget(self, action: #selector(likeMessageAction(sender:)), for: .touchUpInside)
//                                        otherCell.bttnLike.tag = indexPath.row+2000
                                        
                                        
                                        otherCell.otherChatBubbleView.layer.shadowOffset = .zero
                                        otherCell.otherChatBubbleView.layer.shadowColor = UIColor.black.cgColor
                                        otherCell.otherChatBubbleView.layer.shadowRadius = 4
                                        otherCell.otherChatBubbleView.layer.shadowOpacity = 0.25
                                        
                                        return otherCell
                                    }
                                }
                                else
                                {
                                    if(chatuser.attachment_name?.lowercased() == "image")
                                    {
                                        let otherImageCell : UserChatImageByOtherCell = tableView.dequeueReusableCell(withIdentifier: "otherImageCell", for: indexPath) as! UserChatImageByOtherCell
                                        
                                        let date = dateFormaatr.date(from: chatuser.created_at!)
                                        otherImageCell.lblUserName.attributedText = NSMutableAttributedString(string: chatuser.username!)
                                        otherImageCell.chatTime.text = String(format:"%@",timeFormattr.string(from: date!))
                                        otherImageCell.lblCountLikes.isHidden = true
                                        otherImageCell.likecountHeight.constant = 0
                                        if(is_like == 0)
                                        {
                                            otherImageCell.bttnLike.setImage(UIImage(named:"like-other_and"), for: .normal)
                                            
                                        }
                                        else
                                        {
                                            otherImageCell.bttnLike.setImage(UIImage(named:"like_and"), for: .normal)
                                        }
                                        if(likeCount > 0)
                                        {
                                            otherImageCell.lblCountLikes.isHidden = false
                                            otherImageCell.likecountHeight.constant = 16
                                            if(likeCount > 1)
                                            {
                                                otherImageCell.lblCountLikes.text = String(format:"%d likes",chatuser.count!)
                                            }
                                            else
                                            {
                                                otherImageCell.lblCountLikes.text = String(format:"%d like",chatuser.count!)
                                            }
                                        }
                                        let imgName : String = chatuser.logo!
                                        otherImageCell.imgView.image = nil
                                        
                                        if(imgName != "")
                                        {
                                            
                                            let url : URL = URL(string: String(format:"%@%@",imageThumbURL,imgName))!
                                            //otherImageCell.imgView.sd_addActivityIndicator()
                                            //otherImageCell.imgView.sd_setIndicatorStyle(.gray)
                                            otherImageCell.imgView.kf.setImage(with: url)
                                            
                                        }
                                        else
                                        {
                                            
                                            otherImageCell.imgView.image = UIImage(named:"no_Preview")
                                        }
                                        otherImageCell.newConnection.isHidden = true
                                        otherImageCell.userConnection.isHidden = true
                                        if(friend != nil)
                                        {
                                            if(friend.is_friend == 1)
                                            {
                                                otherImageCell.newConnection.isHidden = false
                                                otherImageCell.userConnection.isHidden = true
                                                
                                                
                                            }
                                            else
                                            {
                                                otherImageCell.newConnection.isHidden = true
                                                otherImageCell.userConnection.isHidden = true
                                            }
                                        }
                                        otherImageCell.bttnLike.addTarget(self, action: #selector(likeMessageAction(sender:)), for: .touchUpInside)
                                        otherImageCell.bttnLike.tag = indexPath.row+2000
                                        otherImageCell.bttnImgPreview.tag = indexPath.row+6000000
                                        otherImageCell.bttnImgPreview.addTarget(self, action: #selector(bttnImagePreview(sender:)), for: .touchUpInside)
                                        
                                        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture(sender:)))
                                        otherImageCell.viewContainer.tag = indexPath.row
                                        otherImageCell.viewContainer.addGestureRecognizer(longPress)
                                        otherImageCell.chatBubbleView.layer.shadowOffset = .zero
                                        otherImageCell.chatBubbleView.layer.shadowColor = UIColor.black.cgColor
                                        otherImageCell.chatBubbleView.layer.shadowRadius = 4
                                        otherImageCell.chatBubbleView.layer.shadowOpacity = 0.25
                                        otherImageCell.backgroundColor = UIColor.clear
                                        otherImageCell.selectionStyle = .none
//                                        otherImageCell.userStatus.image = kAppDelegate.setUserStatus(status: friend.status)
//                                        setUserImage(imgView:otherImageCell.userImg,urlStr: friend.profile_pic_thumb)
                                        return otherImageCell
                                    }
                                    if(chatuser.attachment_name?.lowercased() == "video")
                                    {
                                        let otherVideoCell : UserOtherChatVideoCell = tableView.dequeueReusableCell(withIdentifier: "otherChatVideo", for: indexPath) as! UserOtherChatVideoCell
                                        
                                        let is_likee : Int = Int(chatuser.is_like!)!
                                        
                                        let date = dateFormaatr.date(from: chatuser.created_at!)
                                        otherVideoCell.otherUerName.attributedText = NSMutableAttributedString(string: chatuser.username!)
                                        otherVideoCell.chtaTime.text = String(format:"%@",timeFormattr.string(from: date!))
                                        otherVideoCell.lblCountLikes.isHidden = true
                                        otherVideoCell.likecountHeight.constant = 0
                                        if(is_likee == 0)
                                        {
                                            otherVideoCell.bttnLike.setImage(UIImage(named:"like-other_and"), for: .normal)
                                            
                                        }
                                        else
                                        {
                                            otherVideoCell.bttnLike.setImage(UIImage(named:"like_and"), for: .normal)
                                        }
                                        if(likeCount > 0)
                                        {
                                            otherVideoCell.lblCountLikes.isHidden = false
                                            otherVideoCell.likecountHeight.constant = 16
                                            if(likeCount > 1)
                                            {
                                                otherVideoCell.lblCountLikes.text = String(format:"%d likes",chatuser.count!)
                                            }
                                            else
                                            {
                                                otherVideoCell.lblCountLikes.text = String(format:"%d like",chatuser.count!)
                                            }
                                        }
                                        
                                        if(chatuser.video != nil || chatuser.video != "")
                                        {
                                            let url = NSURL(string: String(format:"%@%@",videoBaseURL,chatuser.video!))
                                            
                                            let avPlayer = AVPlayer(url: url! as URL)
                                            otherVideoCell.playerView?.playerLayer.player = avPlayer
                                            
                                            //                                        otherVideoCell.playerView?.playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                                            otherVideoCell.playerView?.playerLayer.masksToBounds = true
                                        }
                                        otherVideoCell.newConnection.isHidden = true
                                        otherVideoCell.userConnection.isHidden = true
                                        if(friend != nil)
                                        {
                                            if(friend.is_friend == 1)
                                            {
                                                otherVideoCell.newConnection.isHidden = false
                                                otherVideoCell.userConnection.isHidden = false
                                                
                                                
                                            }
                                            else
                                            {
                                                otherVideoCell.newConnection.isHidden = true
                                                otherVideoCell.userConnection.isHidden = true
                                            }
                                        }
                                        otherVideoCell.bttnLike.addTarget(self, action: #selector(likeMessageAction(sender:)), for: .touchUpInside)
                                        otherVideoCell.bttnLike.tag = indexPath.row+2000
                                        otherVideoCell.bttnPlayPauseVideo.tag = indexPath.row+20000
                                        otherVideoCell.bttnPlayPauseVideo.addTarget(self, action: #selector(bttnPlayPauseOtherVideoSender(sender:)), for: .touchUpInside)
                                        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture(sender:)))
                                        otherVideoCell.playerView.tag = indexPath.row
                                        otherVideoCell.playerView.addGestureRecognizer(longPress)
                                        otherVideoCell.chatBubble.layer.shadowOffset = .zero
                                        otherVideoCell.chatBubble.layer.shadowColor = UIColor.black.cgColor
                                        otherVideoCell.chatBubble.layer.shadowRadius = 4
                                        otherVideoCell.chatBubble.layer.shadowOpacity = 0.25
                                        otherVideoCell.backgroundColor = UIColor.clear
                                        otherVideoCell.selectionStyle = .none
                                        return otherVideoCell
//                                        otherVideoCell.userStatus.image = kAppDelegate.setUserStatus(status: friend.status)
//                                        setUserImage(imgView:otherVideoCell.userImg,urlStr: friend.profile_pic_thumb)
                                    }
                                }
                            }

                        }
                    }
                    
                    
                }
            }
            else if(tableView == reportTblView)
            {
                let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "reportoptioncell", for: indexPath)
                // cell.accessoryType = .checkmark
                cell.textLabel?.font = UIFont.systemFont(ofSize: 17.0)
                //            cell.textLabel?.font = UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.regular)
                cell.textLabel?.textColor = UIColor.init(hex: "#047cfc")
                cell.textLabel?.text = String(format:"%@",reportOtions[indexPath.row])
                cell.selectionStyle = .none
                return cell
            }
            
            return UITableViewCell()
        }
        func setUserImage(imgView:UIMaskViewImage, urlStr:String)
        {
            imgView.maskImage = #imageLiteral(resourceName: "mask_blackwstroke")
            if  let url = URL(string: urlStr) {
                imgView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "avatar"), options: [SDWebImageOptions.continueInBackground, SDWebImageOptions.lowPriority, SDWebImageOptions.refreshCached, SDWebImageOptions.handleCookies, SDWebImageOptions.retryFailed]) { (image, error, cacheType, url) in
                    if error != nil {
                        //                imgView.image = #imageLiteral(resourceName: "avatar")
                    } else {
                        imgView.image = image
                        imgView.maskImage = #imageLiteral(resourceName: "mask_blackwstroke")
                    }
                }
            }
        }
 
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if(tableView == reportTblView)
            {
                if(tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark)
                {
                    tableView.cellForRow(at: indexPath)?.accessoryType = .none
                    //bttnSendReport.isEnabled = false
                    
                    //bttnSendReport.backgroundColor = UIColor.lightGray
                    selectedReportOpt = ""
                    if(reportOtions[indexPath.row] == "Other")
                    {
                        txtreportReasonHeight.constant = 0
                        txtreportReason.isHidden = true
                        viewreportReasonHeight.constant = 250
                        reportTopConstraint.constant = 70
                        
                        txtreportReason.resignFirstResponder()
                    }
                    else
                    {
                        reportTopConstraint.constant = 70
                        txtreportReason.resignFirstResponder()
                    }
                }
                else
                {
                    tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
                    
                    selectedReportOpt = reportOtions[indexPath.row]
                    if(reportOtions[indexPath.row] == "Other")
                    {
                        txtreportReasonHeight.constant = 40
                        txtreportReason.isHidden = false
                        viewreportReasonHeight.constant = 300
                        if(UIScreen.main.bounds.width <= 375)
                        {
                            reportTopConstraint.constant = 0
                        }
                        
                        txtreportReason.becomeFirstResponder()
                        bttnSendReport.isEnabled = false
                    }
                    else
                    {
                        reportTopConstraint.constant = 70
                        txtreportReason.resignFirstResponder()
                        bttnSendReport.isEnabled = true
                    }
                }
                
                
            }
            
            
        }
        
        func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
            
            if(tableView == reportTblView)
            {
                tableView.cellForRow(at: indexPath)?.accessoryType = .none
                // bttnSendReport.isEnabled = false
                //bttnSendReport.backgroundColor = UIColor.lightGray
                selectedReportOpt = ""
                if(reportOtions[indexPath.row] == "Other")
                {
                    txtreportReasonHeight.constant = 0
                    txtreportReason.isHidden = true
                    viewreportReasonHeight.constant = 250
                    if(UIScreen.main.bounds.width <= 375)
                    {
                        reportTopConstraint.constant = 0
                    }
                    txtreportReason.becomeFirstResponder()
                }
            }
        }
        //MARK: Tbaleview UIButton Actions
        @objc func bttnCloseImagePreview(sender : UIButton)
        {
            let bttn : UIButton = sender
            let indexPath : IndexPath = IndexPath(row: bttn.tag, section: 0)
            imgViewContainer.removeFromSuperview()
            
            chatTablView.scrollToRow(at: indexPath, at: .middle, animated: true)
        }
        @objc func bttnPlayPauseVideoSender(sender: UIButton)
        {
            let bttn : UIButton = sender
            let tagVal : Int = bttn.tag - 50000
            NSLog("tagVal --- \(tagVal)")
            do
            {
                
                let indexPath : IndexPath = IndexPath(row: tagVal, section: 0)
                let cell : UserMyChatVideoCell = chatTablView.cellForRow(at: indexPath) as! UserMyChatVideoCell
                let chatObj : ChatUser = self.msgArry[tagVal]
                let playerController = AVPlayerViewController()
                playerController.delegate = self
                playerController.showsPlaybackControls = true
                if(chatObj.video != nil || chatObj.video != "")
                {
                    
                    playerController.player = cell.playerView.playerLayer.player
                    
                    playerController.view.frame = self.view.frame
                    self.present(playerController, animated: true, completion: {
                        playerController.player?.play()
                    })
                }
                
                
                
            }
            
        }
        @objc func bttnmyReplyVideo(sender : UIButton)
        {
            let bttn : UIButton = sender
            let tagVal : Int = bttn.tag - 200
            NSLog("tagVal --- \(tagVal)")
            do
            {
                
                let indexPath : IndexPath = IndexPath(row: tagVal, section: 0)
                let cell : UserMyVideoReplyCell = chatTablView.cellForRow(at: indexPath) as! UserMyVideoReplyCell
                let chatObj : ChatUser = self.msgArry[tagVal]
                let replyUser : ReplyByUser = chatObj.reply
                let playerController = AVPlayerViewController()
                playerController.delegate = self
                playerController.showsPlaybackControls = true
                if(replyUser.video != nil || replyUser.video != "")
                {
                    
                    playerController.player = cell.playerView.playerLayer.player
                    
                    playerController.view.frame = self.view.frame
                    self.present(playerController, animated: true, completion: {
                        playerController.player?.play()
                    })
                }
                
                
                
            }
            
        }
        @objc func bttnOtherReplyVideo(sender : UIButton)
        {
            let bttn : UIButton = sender
            let tagVal : Int = bttn.tag - 200000
            NSLog("tagVal --- \(tagVal)")
            do
            {
                
                let indexPath : IndexPath = IndexPath(row: tagVal, section: 0)
                let cell : OtherVideoReplyCell = chatTablView.cellForRow(at: indexPath) as! OtherVideoReplyCell
                let chatObj : ChatUser = self.msgArry[tagVal]
                let replyUser : ReplyByUser = chatObj.reply
                let playerController = AVPlayerViewController()
                playerController.delegate = self
                playerController.showsPlaybackControls = true
                if(replyUser.video != nil || replyUser.video != "")
                {
                    
                    playerController.player = cell.playerView.playerLayer.player
                    
                    playerController.view.frame = self.view.frame
                    self.present(playerController, animated: true, completion: {
                        playerController.player?.play()
                    })
                }
                
                
                
            }
            
        }
        @objc func bttnPlayPauseOtherVideoSender(sender: UIButton)
        {
            let bttn : UIButton = sender
            let tagVal : Int = bttn.tag - 20000
            NSLog("tagVal --- \(tagVal)")
            do
            {
                
                let indexPath : IndexPath = IndexPath(row: tagVal, section: 0)
                let cell : UserOtherChatVideoCell = chatTablView.cellForRow(at: indexPath) as! UserOtherChatVideoCell
                let chatObj : ChatUser = self.msgArry[tagVal]
                let playerController = AVPlayerViewController()
                playerController.delegate = self
                playerController.showsPlaybackControls = true
                if(chatObj.video != nil || chatObj.video != "")
                {
                    
                    playerController.player = cell.playerView.playerLayer.player
                    
                    playerController.view.frame = self.view.frame
                    self.present(playerController, animated: true, completion: {
                        playerController.player?.play()
                    })
                }
                
                
                
            }
            
        }
        @objc func bttnImagePreview(sender : UIButton)
        {
            txtViewChat.resignFirstResponder()
            let bttn : UIButton = sender
            let tagVal = bttn.tag - 6000000
            let indexPath : IndexPath = IndexPath(row: tagVal, section: 0)
            if(indexPath.row < self.msgArry.count)
            {
                let chatObj : ChatUser = self.msgArry[indexPath.row]
                let parentID : Int = Int(chatObj.parent_id!)!
                if(chatObj.attachment_name == "")
                {
                    if(parentID > 0 && chatObj.reply != nil)
                    {
                        let replyChat : ReplyByUser = chatObj.reply
                        let imgName : String = replyChat.logo!
                        if(imgName != "")
                        {
                            if(replyChat.attachment_name?.lowercased() == "image")
                            {
                                imgViewContainer = UIView.init(frame: CGRect(x:0,y:0,width:UIScreen.main.bounds.size.width , height:UIScreen.main.bounds.size.height))
                                
                                let imgView = UIImageView.init(frame: imgViewContainer.bounds)
                                if(imgName != "")
                                {
                                    let imageUrl = self.getPathURL(name: replyChat.logo!)
                                    
                                    imgView.contentMode = .scaleAspectFit
                                    
                                    //imgView.sd_addActivityIndicator()
                                    // imgView.sd_setIndicatorStyle(.white)
                                    // imgView.sd_setImage(with: URL(string:String(format:"%@%@",imageBaseURL,imgName))!, completed: nil)
                                    
                                    imgView.kf.indicatorType = .activity
                                    imgView.kf.setImage(with: URL(string:String(format:"%@%@",imageBaseURL,imgName))!)
                                }
                                else
                                {
                                    imgView.contentMode = .scaleAspectFit
                                    imgView.image = UIImage(named:"no_Preview")
                                }
                                let bttnClose = UIButton.init(frame: CGRect(x:15,y:25,width:32,height:22))
                                bttnClose.setImage(UIImage(named:"close-icon_white"), for: .normal)
                                bttnClose.tag = indexPath.row
                                bttnClose.addTarget(self, action: #selector(bttnCloseImagePreview(sender:)), for: .touchUpInside)
                                
                                imgViewContainer.addSubview(imgView)
                                imgViewContainer.addSubview(bttnClose)
                                UIApplication.shared.keyWindow?.addSubview(imgViewContainer)
                                let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(sender:)))
                                imgViewContainer.addGestureRecognizer(swipeGesture)
                                imgViewContainer.backgroundColor = UIColor.black
                                swipeGesture.direction = [.down , .up]
                            }
                        }
                        else
                        {
                            self.showAlert(message: "There is no image.")
                        }
                        
                    }
                }
                else
                {
                    if(chatObj.attachment_name?.lowercased() == "image")
                    {
                        let imgName : String = chatObj.logo!
                        if(imgName != "")
                        {
                            imgViewContainer = UIView.init(frame: CGRect(x:0,y:0,width:UIScreen.main.bounds.size.width , height:UIScreen.main.bounds.size.height))
                            
                            let imgView = UIImageView.init(frame: imgViewContainer.bounds)
                            if(imgName != "")
                            {
                                
                                do
                                {
                                    
                                    imgView.contentMode = .scaleAspectFit
                                    
                                    // imgView.sd_addActivityIndicator()
                                    // imgView.sd_setIndicatorStyle(.white)
                                    imgView.kf.indicatorType = .activity
                                    imgView.kf.setImage(with: URL(string:String(format:"%@%@",imageBaseURL,imgName))!)
                                }
                                
                                
                                
                                //}
                            }
                            else
                            {
                                imgView.contentMode = .scaleAspectFit
                                imgView.image = UIImage(named:"no_Preview")
                            }
                            let bttnClose = UIButton.init(frame: CGRect(x:10,y:25,width:30,height:22))
                            bttnClose.setImage(UIImage(named:"close-icon_white"), for: .normal)
                            bttnClose.tag = indexPath.row
                            bttnClose.addTarget(self, action: #selector(bttnCloseImagePreview(sender:)), for: .touchUpInside)
                            
                            imgViewContainer.addSubview(imgView)
                            imgViewContainer.addSubview(bttnClose)
                            UIApplication.shared.keyWindow?.addSubview(imgViewContainer)
                            let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(sender:)))
                            imgViewContainer.addGestureRecognizer(swipeGesture)
                            imgViewContainer.backgroundColor = UIColor.black
                            swipeGesture.direction = [.down , .up]
                            
                        }
                        else
                        {
                            self.showAlert(message: "There is no image.")
                        }
                        
                        
                    }
                }
                
            }
            
        }
        @objc func handleSwipeGesture(sender : UISwipeGestureRecognizer)
        {
            imgViewContainer.removeFromSuperview()
        }
        func setShadowToView(view : UIImageView) ->UIImageView
        {
            //view.clipsToBounds = false
            
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowOpacity = 0.5
            view.layer.shadowOffset = CGSize.zero
            view.layer.shadowRadius = 2
            view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: 2).cgPath
            return view
        }
    }
    extension PChatVC : AVPlayerViewControllerDelegate
    {
        
        func playerViewControllerWillStartPictureInPicture(_ playerViewController: AVPlayerViewController){
            print("playerViewControllerWillStartPictureInPicture")
        }
        
        func playerViewControllerDidStartPictureInPicture(_ playerViewController: AVPlayerViewController)
        {
            print("playerViewControllerDidStartPictureInPicture")
            
        }
        func playerViewController(_ playerViewController: AVPlayerViewController, failedToStartPictureInPictureWithError error: Error)
        {
            print("failedToStartPictureInPictureWithError")
        }
        func playerViewControllerWillStopPictureInPicture(_ playerViewController: AVPlayerViewController)
        {
            print("playerViewControllerWillStopPictureInPicture")
        }
        func playerViewControllerDidStopPictureInPicture(_ playerViewController: AVPlayerViewController)
        {
            print("playerViewControllerDidStopPictureInPicture")
        }
        func playerViewControllerShouldAutomaticallyDismissAtPictureInPictureStart(_ playerViewController: AVPlayerViewController) -> Bool
        {
            print("playerViewControllerShouldAutomaticallyDismissAtPictureInPictureStart")
            return true
        }
    }
    extension PChatVC
    {
        @IBAction func bttnSendReport(sender : UIButton)
        {
            if(selectedReportOpt == "")
            {
                self.showAlert(message: "Please select reason first.")
            }
            else
            {
                txtreportReason.resignFirstResponder()
                reportContainer.isHidden = true
                
                if(selectedIndex < msgArry.count && self.selectedIndex > 0)
                {
                    let chatObj : ChatUser = msgArry[selectedIndex]
                    self.reportFeatureAPI(messageID: String(format:"%@",chatObj.id!), userID: userID)
                }
            }
            
        }
        @IBAction func bttnCancelReport(sender : UIButton)
        {
            txtreportReasonHeight.constant = 0
            txtreportReason.isHidden = true
            viewreportReasonHeight.constant = 250
            self.selectedIndex = -1
            reportTblView.reloadData()
            do
            {
                for i in 0..<reportOtions.count
                {
                    let index : IndexPath = IndexPath(row: i, section: 0)
                    let cell : UITableViewCell = reportTblView.cellForRow(at: index)!
                    cell.accessoryType = .none
                }
            }
            
            reportTblView.reloadData()
            txtreportReason.resignFirstResponder()
            reportContainer.isHidden = true
            selectedReportOpt = ""
            txtreportReason.text = ""
        }
        @objc func likeMessageAction(sender : UIButton)
        {
            let bttn : UIButton = sender
            let tagVal : Int = bttn.tag-2000
            if(tagVal < msgArry.count)
            {
                let chatObj : ChatUser = msgArry[tagVal]
                if(chatObj.is_like! == "1")
                {
                    var likeCount : Int = chatObj.count!
                    
                    do{
                        likeCount = likeCount-1
                        if(likeCount < 1)
                        {
                            chatObj.is_like = "0"
                        }
                        else
                        {
                            chatObj.is_like = "1"
                        }
                        
                        
                        chatObj.count = likeCount
                        
                        self.msgArry[tagVal] = chatObj
                        let indexPath  : IndexPath = IndexPath(row: tagVal, section: 0)
                        chatObj.is_like = "0"
                        
                        self.setLikeCountandImage(indexPath: indexPath, is_like: 0 ,likeCount: likeCount)
                        self.likeunlikeevent(chat: chatObj)
                        // self.chatTablView.reloadRows(at: [indexPath], with: .automatic)
                        
                    }
                    
                    bttn.setImage(UIImage(named:"like-other_and"), for: .normal)
                }
                else
                {
                    
                    bttn.setImage(UIImage(named:"like-other"), for: .normal)
                    do{
                        var likeCount : Int = chatObj.count!
                        likeCount = likeCount+1
                        
                        chatObj.is_like = "1"
                        chatObj.count = likeCount
                        self.msgArry[tagVal] = chatObj
                        let indexPath  : IndexPath = IndexPath(row: tagVal, section: 0)
                        self.setLikeCountandImage(indexPath: indexPath , is_like: 1 ,likeCount: likeCount)
                        self.likeunlikeevent(chat: chatObj)
                        // self.chatTablView.reloadRows(at: [indexPath], with: .automatic)
                        
                    }
                    bttn.setImage(UIImage(named:"like_and"), for: .normal)
                }
                
                // self.likeMessage(messageID: String(format:"%@",chatObj.id!), userID: chatObj.user_id!,index:tagVal)
            }
            
        }
        func setLikeCountandImage(indexPath : IndexPath , is_like : Int , likeCount : Int)
        {
            
//            let cell  = chatTablView.cellForRow(at: indexPath)
//
//
//            if(cell is UserChatByOtherCell)
//            {
//                let chatByOtherCell : UserChatByOtherCell = cell as! UserChatByOtherCell
//                chatByOtherCell.noOfLikes.isHidden = true
//                chatByOtherCell.likecountHeight.constant = 0
//                if(chatByOtherCell.bttnLike.imageView?.image == UIImage.init(named: "like_and"))
//                {
//                    chatByOtherCell.bttnLike.setImage(UIImage(named:"like-other_and"), for: .normal)
//
//                }
//                else
//                {
//                    chatByOtherCell.bttnLike.setImage(UIImage(named:"like_and"), for: .normal)
//                }
//                if(likeCount > 0)
//                {
//                    chatByOtherCell.noOfLikes.isHidden = false
//                    chatByOtherCell.likecountHeight.constant = 16
//                    if(likeCount > 1)
//                    {
//                        chatByOtherCell.noOfLikes.text = String(format:"%d likes",likeCount)
//                    }
//                    else
//                    {
//                        chatByOtherCell.noOfLikes.text = String(format:"%d like",likeCount)
//                    }
//                }
//            }
//            else if(cell is UserReplyViewCell)
//            {
//                let replyViewCell : UserReplyViewCell = cell as! UserReplyViewCell
//                replyViewCell.noOfLikes.isHidden = true
//                replyViewCell.likecountHeight.constant = 0
//                if(is_like == 0)
//                {
//                    replyViewCell.bttnLike.setImage(UIImage(named:"like-other_and"), for: .normal)
//
//                }
//                else
//                {
//                    replyViewCell.bttnLike.setImage(UIImage(named:"like_and"), for: .normal)
//                }
//                if(likeCount > 0)
//                {
//                    replyViewCell.noOfLikes.isHidden = false
//                    replyViewCell.likecountHeight.constant = 20
//                    if(likeCount > 1)
//                    {
//                        replyViewCell.noOfLikes.text = String(format:"%d likes",likeCount)
//                    }
//                    else
//                    {
//                        replyViewCell.noOfLikes.text = String(format:"%d like",likeCount)
//                    }
//                }
//            }
//            else if(cell is UserReplyChatOtherCell)
//            {
//                let replyChatOtherCell : UserReplyChatOtherCell = cell as! UserReplyChatOtherCell
//
//                replyChatOtherCell.noOfLikes.isHidden = true
//                replyChatOtherCell.likecountHeight.constant = 0
//                if(is_like == 0)
//                {
//                    replyChatOtherCell.bttnLike.setImage(UIImage(named:"like-other_and"), for: .normal)
//
//                }
//                else
//                {
//                    replyChatOtherCell.bttnLike.setImage(UIImage(named:"like_and"), for: .normal)
//                }
//                if(likeCount > 0)
//                {
//                    replyChatOtherCell.noOfLikes.isHidden = false
//                    replyChatOtherCell.likecountHeight.constant = 20
//                    if(likeCount > 1)
//                    {
//                        replyChatOtherCell.noOfLikes.text = String(format:"%d likes",likeCount)
//                    }
//                    else
//                    {
//                        replyChatOtherCell.noOfLikes.text = String(format:"%d like",likeCount)
//                    }
//                }
//            }
//            else if(cell is UserOtherVideoReplyCell)
//            {
//                let otherVideoReplyCell : UserOtherVideoReplyCell = cell as! UserOtherVideoReplyCell
//                otherVideoReplyCell.noOfLikes.isHidden = true
//                otherVideoReplyCell.likecountHeight.constant = 0
//                if(is_like == 0)
//                {
//                    otherVideoReplyCell.bttnLike.setImage(UIImage(named:"like-other_and"), for: .normal)
//
//                }
//                else
//                {
//                    otherVideoReplyCell.bttnLike.setImage(UIImage(named:"like_and"), for: .normal)
//                }
//                if(likeCount > 0)
//                {
//                    otherVideoReplyCell.noOfLikes.isHidden = false
//                    otherVideoReplyCell.likecountHeight.constant = 20
//                    if(likeCount > 1)
//                    {
//                        otherVideoReplyCell.noOfLikes.text = String(format:"%d likes",likeCount)
//                    }
//                    else
//                    {
//                        otherVideoReplyCell.noOfLikes.text = String(format:"%d like",likeCount)
//                    }
//                }
//            }
//            else if(cell is UserChatImageByOtherCell)
//            {
//                let chatImageByOtherCell : UserChatImageByOtherCell = cell as! UserChatImageByOtherCell
//                chatImageByOtherCell.lblCountLikes.isHidden = true
//                chatImageByOtherCell.likecountHeight.constant = 0
//                if(is_like == 0)
//                {
//                    chatImageByOtherCell.bttnLike.setImage(UIImage(named:"like-other_and"), for: .normal)
//
//                }
//                else
//                {
//                    chatImageByOtherCell.bttnLike.setImage(UIImage(named:"like_and"), for: .normal)
//                }
//                if(likeCount > 0)
//                {
//                    chatImageByOtherCell.lblCountLikes.isHidden = false
//                    chatImageByOtherCell.likecountHeight.constant = 20
//                    if(likeCount > 1)
//                    {
//                        chatImageByOtherCell.lblCountLikes.text = String(format:"%d likes",likeCount)
//                    }
//                    else
//                    {
//                        chatImageByOtherCell.lblCountLikes.text = String(format:"%d like",likeCount)
//                    }
//                }
//            }
//            else if(cell is UserOtherChatVideoCell)
//            {
//
//                let otherChatVideoCell : UserOtherChatVideoCell = cell as! UserOtherChatVideoCell
//                otherChatVideoCell.lblCountLikes.isHidden = true
//                otherChatVideoCell.likecountHeight.constant = 0
//                if(is_like == 0)
//                {
//                    otherChatVideoCell.bttnLike.setImage(UIImage(named:"like-other_and"), for: .normal)
//
//                }
//                else
//                {
//                    otherChatVideoCell.bttnLike.setImage(UIImage(named:"like_and"), for: .normal)
//                }
//                if(likeCount > 0)
//                {
//                    otherChatVideoCell.lblCountLikes.isHidden = false
//                    otherChatVideoCell.likecountHeight.constant = 20
//                    if(likeCount > 1)
//                    {
//                        otherChatVideoCell.lblCountLikes.text = String(format:"%d likes",likeCount)
//                    }
//                    else
//                    {
//                        otherChatVideoCell.lblCountLikes.text = String(format:"%d like",likeCount)
//                    }
//                }
//            }
        }
        
        func displayShareController(msg : String , attachment : Data)
        {
            var shareItem = [AnyObject]()
            if(msg == "imageShare")
            {
                shareItem = [attachment as Data as AnyObject]
            }
            else
            {
                shareItem = [msg as String as AnyObject]
            }
            
            let activityController = UIActivityViewController(
                activityItems: shareItem,
                applicationActivities: nil)
            
            
            activityController.popoverPresentationController?.sourceRect = self.view.frame
            activityController.popoverPresentationController?.sourceView = self.view
            activityController.popoverPresentationController?.permittedArrowDirections = .any
            
            // present the controller
            present(activityController, animated: true, completion: nil)
        }
        @IBAction func bttnReplyViewClosePressed(sender : UIButton)
        {
            
            selectedIndex = -1
            msgActionContainer.isHidden  = true
            bttnreplyClose.isHidden = true
            replyViewHeightConstraint.constant = 0
            if(replyViewHeightConstraint.constant == 0)
            {
                bottomViewHeightConstraint.constant = 214 - txtviewHeightConstraint.constant
            }
            else{
                bottomViewHeightConstraint.constant = replyViewHeightConstraint.constant + txtviewHeightConstraint.constant
            }
            lblMsgOriginalUser.text = ""
            lblOriginalMsg.text = ""
        }
        
        @IBAction func bttnmsgReplyClicked(sender : UIButton)
        {
            overlayView.removeFromSuperview()
            //setBackMsgBackgroundColor()
            msgActionContainer.isHidden  = true
            bttnreplyClose.isHidden = false
            replyViewHeightConstraint.constant = 64
            
            if(replyViewHeightConstraint.constant == 0) {
                
                bottomViewHeightConstraint.constant = 214 - txtviewHeightConstraint.constant
            }
            else {
                
                bottomViewHeightConstraint.constant = replyViewHeightConstraint.constant + txtviewHeightConstraint.constant+10
            }
            
            self.view.layoutSubviews()
            self.view.setNeedsUpdateConstraints()
            lblMsgOriginalUser.text = ""
            lblOriginalMsg.text = ""
            if(selectedIndex < msgArry.count && self.selectedIndex > 0)
            {
                let chatObj : ChatUser = msgArry[selectedIndex]
                if(chatObj.attachment_name?.lowercased() == "image")
                {
                    lblMsgOriginalUser.isHidden = true
                    lblMsgOriginalUser.isHidden = true
                    replyPlayerMediaView.isHidden = true
                    replyMediaView.isHidden = false
                    lblMediaType.text = "Photo"
                    bttnMediaType.setImage(UIImage(named:"camera"), for: .normal)
                    let imgName : String = chatObj.logo!
                    if(imgName != "")
                    {
                        
                        // replyImageMediaView.sd_addActivityIndicator()
                        // replyImageMediaView.sd_setIndicatorStyle(.white)
                        replyImageMediaView.kf.indicatorType = .activity
                        
                        replyImageMediaView.kf.setImage(with: URL(string: String(format:"%@%@",imageThumbURL,chatObj.logo!))!)
                    }
                    
                    if(chatObj.user_id == userID)
                    {
                        lblMediaSentUser.text = "You"
                    }
                    else
                    {
                        lblMediaSentUser.text = chatObj.username
                    }
                    
                }
                else if(chatObj.attachment_name?.lowercased() == "video")
                {
                    lblMsgOriginalUser.isHidden = true
                    lblMsgOriginalUser.isHidden = true
                    replyMediaView.isHidden = false
                    lblMediaType.text = "Video"
                    replyPlayerMediaView.isHidden = false
                    
                    bttnMediaType.setImage(UIImage(named:"video-call-filled"), for: .normal)
                    if(chatObj.video != nil || chatObj.video != "")
                    {
                        let url = NSURL(string: String(format:"%@%@",videoBaseURL,chatObj.video!))
                        
                        let avPlayer = AVPlayer(url: url! as URL)
                        replyPlayerMediaView.playerLayer.player = avPlayer
                        
                        //                    replyPlayerMediaView.playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                        replyPlayerMediaView.playerLayer.masksToBounds = true
                    }
                    if(chatObj.user_id == userID)
                    {
                        lblMediaSentUser.text = "You"
                    }
                    else
                    {
                        lblMediaSentUser.text = chatObj.username
                    }
                }
                else
                {
                    lblMsgOriginalUser.isHidden = false
                    lblMsgOriginalUser.isHidden = false
                    replyMediaView.isHidden = true
                    if(chatObj.user_id == userID)
                    {
                        lblMsgOriginalUser.text = "You"
                    }
                    else
                    {
                        lblMsgOriginalUser.text = chatObj.username
                    }
                    if decode(chatObj.message!) != nil
                    {
                        lblOriginalMsg.text = decode(chatObj.message!)!
                    }
                    else
                    {
                        lblOriginalMsg.text = chatObj.message
                    }
                }
                txtViewChat.becomeFirstResponder()
                
                
                if (selectedIndex == msgArry.count-1 ) {
                    _ = Timer.scheduledTimerWithTimeInterval(0.0, repeats: false, callback: {
                        self.chatTablView.scrollToRow(at: IndexPath(row:self.selectedIndex, section:0), at: UITableViewScrollPosition.bottom, animated: true)
                    })
                    //                Timer.scheduledTimer(timeInterval: 0.0,
                    //                                     target: self,
                    //                                     selector: #selector(self.scrollToSelectedIndex(_:)),
                    //                                     userInfo: nil,
                    //                                     repeats: false)
                }
                
                
            }
        }
        
        
        @objc func scrollToSelectedIndex(_ timer: AnyObject) {
            
            self.chatTablView.scrollToRow(at: IndexPath(row:selectedIndex, section:0), at: UITableViewScrollPosition.bottom, animated: true)
        }
        
        @IBAction func bttnmsgShareClicked(sender : UIButton)
        {
            overlayView.removeFromSuperview()
            // setBackMsgBackgroundColor()
            msgActionContainer.isHidden  = true
            if(selectedIndex < msgArry.count && self.selectedIndex > 0)
            {
                let chatObj : ChatUser = msgArry[selectedIndex]
                
                if(chatObj.attachment_name?.lowercased() == "image")
                {
                    
                    let imgName : String = chatObj.logo!
                    if(imgName != "")
                    {
                        
                        do
                        {
                            let url : URL = URL(string: String(format:"%@%@",imageBaseURL,imgName))!
                            let imgData : Data = try Data.init(contentsOf: url)
                            displayShareController(msg: "imageShare", attachment: imgData)
                        }
                        catch
                        {
                            
                        }
                        
                        //}
                    }
                }
                else
                {
                    if(chatObj.attachment_name?.lowercased() == "video")
                    {
                        
                    }
                    else
                    {
                        let imgData : Data = Data.init()
                        displayShareController(msg: chatObj.message!, attachment: imgData)
                    }
                    
                }
                
                
                selectedIndex = -1
            }
            
        }
        @IBAction func bttnmsgCopyClicked(sender : UIButton)
        {
            overlayView.removeFromSuperview()
            //setBackMsgBackgroundColor()
            msgActionContainer.isHidden  = true
            
            if(selectedIndex < msgArry.count && self.selectedIndex > 0)
            {
                
                let chatObj : ChatUser = msgArry[selectedIndex]
                let pBoard : UIPasteboard = UIPasteboard(name: .general, create: true)!
                // pBoard.string = chatObj.message
                if decode(chatObj.message!) != nil
                {
                    
                    pBoard.string = decode(chatObj.message!)!
                }
                else
                {
                    pBoard.string = chatObj.message
                }
                self.showAlert(message:"Message copied")
                
                self.selectedIndex = -1
            }
        }
        
        @IBAction func bttnmsgSaveClicked(sender : UIButton)
        {
            overlayView.removeFromSuperview()
            msgActionContainer.isHidden  = true
            let photos = PHPhotoLibrary.authorizationStatus()
            if photos == .notDetermined {
                PHPhotoLibrary.requestAuthorization({status in
                    if status == .authorized{
                        if(self.selectedIndex < self.msgArry.count && self.selectedIndex > 0)
                        {
                            DispatchQueue.main.async {
                                MBProgressHUD.showAdded(to: self.view, animated: true)
                            }
                            let chatObj : ChatUser = self.msgArry[self.selectedIndex]
                            if(chatObj.attachment_name?.lowercased() == "image")
                            {
                                let imageName : String = chatObj.logo!
                                DispatchQueue.global(qos: .background).async {
                                    NSLog("saveinPhotoLibrary ----\(String(format:"%@%@",imageBaseURL,imageName))")
                                    let imgURL : URL = URL(string:String(format:"%@%@",imageBaseURL,imageName))!
                                    KingfisherManager.shared.retrieveImage(with: imgURL, options: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, url) in
                                        if(image != nil)
                                        {
                                            print("image downloaded: \(imageName)")
                                            
                                            
                                            DispatchQueue.main.async {
                                                MBProgressHUD.hide(for: self.view, animated: true)
                                                
                                                do {
                                                    PHPhotoLibrary.shared().performChanges({
                                                        PHAssetChangeRequest.creationRequestForAsset(from: image!)
                                                    }) { completed, error in
                                                        if completed {
                                                            print("Image is saved!")
                                                            self.showAlert(message: "Photo saved.")
                                                        }
                                                    }
                                                }
                                                
                                            }
                                            self.selectedIndex = -1
                                        }
                                    })
                                    /*    SDWebImageDownloader.shared().downloadImage(with: imgURL, options: SDWebImageDownloaderOptions.ignoreCachedResponse, progress: { (receivedSize :Int, ExpectedSize :Int,  url : URL?) in
                                     
                                     }, completed: { (image : UIImage?, data : Data?, error : Error?, finished : Bool) in
                                     if(finished == true)
                                     {
                                     if(image != nil)
                                     {
                                     print("image downloaded: \(imageName)")
                                     
                                     
                                     DispatchQueue.main.async {
                                     MBProgressHUD.hide(for: self.view, animated: true)
                                     
                                     do {
                                     PHPhotoLibrary.shared().performChanges({
                                     PHAssetChangeRequest.creationRequestForAsset(from: image!)
                                     }) { completed, error in
                                     if completed {
                                     print("Image is saved!")
                                     self.showAlert(message: "Image downloaded.")
                                     }
                                     }
                                     }
                                     
                                     }
                                     self.selectedIndex = -1
                                     }
                                     }
                                     })*/
                                    
                                }
                            }
                            if(chatObj.attachment_name?.lowercased() == "video")
                            {
                                DispatchQueue.global(qos: .background).async {
                                    let videoname : String = chatObj.video!
                                    if let url = URL(string: String(format:"%@%@",videoBaseURL,videoname)),
                                        let urlData = NSData(contentsOf: url)
                                    {
                                        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
                                        
                                        let filePath = "\(documentsPath)/\(videoname)"
                                        DispatchQueue.main.async {
                                            MBProgressHUD.hide(for: self.view, animated: true)
                                            
                                            urlData.write(toFile: filePath, atomically: true)
                                            PHPhotoLibrary.shared().performChanges({
                                                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(fileURLWithPath: filePath))
                                            }) { completed, error in
                                                if completed {
                                                    print("Video is saved!")
                                                    self.showAlert(message: "Video saved.")
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    } else {
                        
                        self.showAlert(message: "You are not allowed to access your Media Library.")
                    }
                })
            }
            else
            {
                PHPhotoLibrary.requestAuthorization({status in
                    if status == .authorized{
                        if(self.selectedIndex < self.msgArry.count && self.selectedIndex > 0)
                        {
                            DispatchQueue.main.async {
                                MBProgressHUD.showAdded(to: self.view, animated: true)
                            }
                            let chatObj : ChatUser = self.msgArry[self.selectedIndex]
                            if(chatObj.attachment_name?.lowercased() == "image")
                            {
                                let imageName : String = chatObj.logo!
                                DispatchQueue.global(qos: .background).async {
                                    NSLog("saveinPhotoLibrary ----\(String(format:"%@%@",imageBaseURL,imageName))")
                                    let imgURL : URL = URL(string:String(format:"%@%@",imageBaseURL,imageName))!
                                    KingfisherManager.shared.retrieveImage(with: imgURL, options: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, url) in
                                        
                                        if(image != nil)
                                        {
                                            print("image downloaded: \(image)")
                                            
                                            
                                            DispatchQueue.main.async {
                                                MBProgressHUD.hide(for: self.view, animated: true)
                                                
                                                do {
                                                    PHPhotoLibrary.shared().performChanges({
                                                        PHAssetChangeRequest.creationRequestForAsset(from: image!)
                                                    }) { completed, error in
                                                        if completed {
                                                            print("Image is saved!")
                                                            self.showAlert(message: "Photo saved.")
                                                        }
                                                    }
                                                }
                                                
                                            }
                                            self.selectedIndex = -1
                                        }
                                    })
                                    /*SDWebImageDownloader.shared().downloadImage(with: imgURL, options: SDWebImageDownloaderOptions.ignoreCachedResponse, progress: { (receivedSize :Int, ExpectedSize :Int,  url : URL?) in
                                     
                                     }, completed: { (image : UIImage?, data : Data?, error : Error?, finished : Bool) in
                                     if(finished == true)
                                     {
                                     if(image != nil)
                                     {
                                     print("image downloaded: \(image)")
                                     
                                     
                                     DispatchQueue.main.async {
                                     MBProgressHUD.hide(for: self.view, animated: true)
                                     
                                     do {
                                     PHPhotoLibrary.shared().performChanges({
                                     PHAssetChangeRequest.creationRequestForAsset(from: image!)
                                     }) { completed, error in
                                     if completed {
                                     print("Image is saved!")
                                     self.showAlert(message: "Image downloaded.")
                                     }
                                     }
                                     }
                                     
                                     }
                                     self.selectedIndex = -1
                                     }
                                     }
                                     })*/
                                    
                                }
                            }
                            if(chatObj.attachment_name?.lowercased() == "video")
                            {
                                DispatchQueue.global(qos: .background).async {
                                    let videoname : String = chatObj.video!
                                    if let url = URL(string: String(format:"%@%@",videoBaseURL,videoname)),
                                        let urlData = NSData(contentsOf: url)
                                    {
                                        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
                                        
                                        let filePath = "\(documentsPath)/\(videoname)"
                                        DispatchQueue.main.async {
                                            MBProgressHUD.hide(for: self.view, animated: true)
                                            
                                            urlData.write(toFile: filePath, atomically: true)
                                            PHPhotoLibrary.shared().performChanges({
                                                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(fileURLWithPath: filePath))
                                            }) { completed, error in
                                                if completed {
                                                    print("Video is saved!")
                                                    self.showAlert(message: "Video saved.")
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    } else {
                        
                        self.showAlert(message: "You are not allowed to access your Media Library.")
                    }
                })
            }
            
            
            
        }
        @IBAction func bttnmsgDeleteClicked(sender : UIButton)
        {
            overlayView.removeFromSuperview()
            // setBackMsgBackgroundColor()
            msgActionContainer.isHidden  = true
            
            let alertController = UIAlertController.init(title: "Delete message for me?", message: nil, preferredStyle: .alert)
            alertController.addAction(UIAlertAction.init(title: "Cancel", style: .default, handler: { (action) in
                self.selectedIndex = -1
            }))
            alertController.addAction(UIAlertAction.init(title: "Yes", style: .default, handler: { (action) in
                
                if(self.selectedIndex < self.msgArry.count && self.selectedIndex > 0)
                {
                    let chatObj : ChatUser = self.msgArry[self.selectedIndex]
                    self.showAlert(message: "Message deleted")
                    self.msgArry.remove(at: self.selectedIndex)
                    self.setDatewiseChatList()
                    
                    UIView.performWithoutAnimation {
                        let lastScrollOffset = self.chatTablView.contentOffset
                        self.chatTablView.beginUpdates()
                        self.chatTablView.deleteRows(at: [IndexPath(row: self.selectedIndex, section: 0)], with: .none)
                        self.chatTablView.endUpdates()
                        
                        
                        self.chatTablView.setContentOffset(lastScrollOffset, animated: false)
                    }
                    self.deleteMessage(messageID: String(format:"%@",chatObj.id!), userID: self.userID)
                }
            }))
            
            self.present(alertController, animated: true, completion: nil)
        }
        @IBAction func bttnmsgReportClicked(sender : UIButton)
        {
            self.view.endEditing(true)
            
            NSLog("width--bttnmsgReportClicked-\(UIScreen.main.bounds.size.width)")
            overlayView.removeFromSuperview()
            // setBackMsgBackgroundColor()
            txtreportReasonHeight.constant = 0
            txtreportReason.isHidden = true
            txtreportReason.text = ""
            viewreportReasonHeight.constant = 250
            
            reportTblView.reloadData()
            do
            {
                for i in 0..<reportOtions.count
                {
                    let index : IndexPath = IndexPath(row: i, section: 0)
                    let cell : UITableViewCell = reportTblView.cellForRow(at: index)!
                    cell.accessoryType = .none
                    
                }
            }
            
            msgActionContainer.isHidden  = true
            reportTblView.reloadData()
            
            reportContainer.isHidden = false
        }
        
        func widthForLabel(text:String, font:UIFont, height:CGFloat) -> CGFloat{
            let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width:
                CGFloat.greatestFiniteMagnitude, height: height))
            label.numberOfLines = 0
            label.lineBreakMode = NSLineBreakMode.byCharWrapping
            label.font = font
            label.text = text
            label.sizeToFit()
            return label.frame.width
        }
        
        func showAlert(message : String)
        {
            let alertcontroller = UIAlertController.init(title: message, message: nil, preferredStyle: .alert)
            
            self.present(alertcontroller, animated: true, completion: nil)
            
            
            let when = DispatchTime.now() + 0.5
            DispatchQueue.main.asyncAfter(deadline: when){
                
                alertcontroller.dismiss(animated: true, completion: nil)
            }
        }
        
        func showAttachmentPreview(image : UIImage)
        {
            imgViewContainer = UIView.init(frame: CGRect(x:0,y:0,width:UIScreen.main.bounds.size.width , height:UIScreen.main.bounds.size.height))
            
            let imgView = UIImageView.init(frame: imgViewContainer.bounds)
            
            do {
                imgView.contentMode = .scaleAspectFit
                imgView.image = image
            }
            
            let bttnClose = UIButton.init(frame: CGRect(x:15,y:25,width:32,height:22))
            bttnClose.setImage(UIImage(named:"close-icon_white"), for: .normal)
            bttnClose.addTarget(self, action: #selector(bttnCloseAtachmentPreview), for: .touchUpInside)
            
            let bttnSend = UIButton.init(frame: CGRect(x:imgViewContainer.frame.size.width-75,y:imgViewContainer.frame.size.height-75,width:40,height:40))
            bttnSend.setImage(UIImage(named:"send_icon"), for: .normal)
            bttnSend.addTarget(self, action: #selector(sendImageAttachment), for: .touchUpInside)
            imgViewContainer.addSubview(imgView)
            imgViewContainer.addSubview(bttnClose)
            imgViewContainer.addSubview(bttnSend)
            imgViewContainer.backgroundColor = UIColor.black
            UIApplication.shared.keyWindow?.addSubview(imgViewContainer)
        }
        @objc func sendImageAttachment()
        {
            imgViewContainer.removeFromSuperview()
            addAttachment(attachmentName: "Image")
        }
        @objc func bttnCloseAtachmentPreview()
        {
            imgViewContainer.removeFromSuperview()
            selectedImage = nil
        }
    }
    extension PChatVC : UINavigationControllerDelegate , UIImagePickerControllerDelegate
    {
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            self.imagePicker.dismiss(animated: true, completion: nil)
            selectedImage = nil
            selectedVideoURL = nil
        }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
            
            
            
            if let mediaType = info[UIImagePickerControllerMediaType] as? String {
                
                if mediaType == "public.movie" {
                    print("Video Selected")
                    //  let videoURL = info[UIImagePickerControllerMediaURL] as! URL
                    if let fileURL = info[UIImagePickerControllerMediaURL] as? NSURL {
                        if let videoData = NSData(contentsOf: fileURL as URL) {
                            print(videoData.length)
                            videoDataN = videoData
                            
                            let pathURL = self.getPathURL(name: String(format:"video_%d.mov",self.random9DigitString()))
                            
                            // but just copy from the video URL to the destination URL
                            do
                            {
                                
                                self.encodeVideo(videoURL: fileURL as URL , fileName : String(format:"video_%d.mov",self.random9DigitString()))
                                
                            }
                            catch
                            {
                            }
                            
                            
                        }
                    }
                    
                    
                }
                else
                {
                    let  choseImage = info[UIImagePickerControllerOriginalImage] as! UIImage
                    selectedImage = choseImage
                    if(picker.sourceType == UIImagePickerControllerSourceType.camera)
                    {
                        addAttachment(attachmentName: "Image")
                    }
                    else
                    {
                        showAttachmentPreview(image: choseImage)
                    }
                    
                    
                }
            }
            else
            {
                let  choseImage = info[UIImagePickerControllerOriginalImage] as! UIImage
                selectedImage = choseImage
                if(picker.sourceType == UIImagePickerControllerSourceType.camera)
                {
                    addAttachment(attachmentName: "Image")
                }
                else
                {
                    showAttachmentPreview(image: choseImage)
                }
            }
            
            
            self.dismiss(animated: true, completion: nil)
        }
        func encodeVideo(videoURL: URL , fileName : String){
            let avAsset = AVURLAsset(url: videoURL)
            let startDate = AppUtility.getDate()
            let exportSession = AVAssetExportSession(asset: avAsset, presetName: AVAssetExportPreset640x480)
            
            let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let myDocPath = NSURL(fileURLWithPath: docDir).appendingPathComponent(fileName)?.absoluteString
            
            let docDir2 = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as NSURL
            
            let filePath = docDir2.appendingPathComponent(String(format:"video_%d.mp4",self.random9DigitString()))
            deleteFile(filePath!)
            
            if FileManager.default.fileExists(atPath: myDocPath!){
                do{
                    try FileManager.default.removeItem(atPath: myDocPath!)
                }catch let error{
                    print(error)
                }
            }
            
            exportSession?.outputURL = filePath
            //        exportSession?.outputFileType = AVFileType.mp4
            exportSession?.outputFileType = AVFileTypeMPEG4
            exportSession?.shouldOptimizeForNetworkUse = true
            
            let start = CMTimeMakeWithSeconds(0.0, 0)
            let range = CMTimeRange(start: start, duration: avAsset.duration)
            exportSession?.timeRange = range
            
            exportSession!.exportAsynchronously{() -> Void in
                switch exportSession!.status{
                case .failed:
                    print("\(exportSession!.error!)")
                case .cancelled:
                    print("Export cancelled")
                case .completed:
                    let endDate = AppUtility.getDate()
                    let time = endDate.timeIntervalSince(startDate)
                    print(time)
                    print("Successful")
                    print(exportSession?.outputURL ?? "")
                    
                    DispatchQueue.main.async {
                        self.selectedVideoURL = exportSession?.outputURL
                        self.addAttachment(attachmentName: "Video")
                    }
                    
                default:
                    break
                }
                
            }
        }
        
        func deleteFile(_ filePath:URL) {
            guard FileManager.default.fileExists(atPath: filePath.path) else{
                return
            }
            do {
                try FileManager.default.removeItem(atPath: filePath.path)
            }catch{
                fatalError("Unable to delete file: \(error) : \(#function).")
            }
        }
        
        func getPathURL(name : String)-> URL
        {
            do
            {
                let documentsDirectoryURL = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                // create a name for your image
                let pathURL = documentsDirectoryURL.appendingPathComponent(name)
                return pathURL
            }
            
            
        }
        
        func encode(_ s: String) -> String {
            
            let data = s.data(using: .nonLossyASCII, allowLossyConversion: true)!
            return String(data: data, encoding: .utf8)!
        }
        
        func decode(_ s: String) -> String? {
            var stemp : String = s
            stemp = stemp.replacingOccurrences(of: "\\n", with: "\n")
            let data = stemp.data(using: .utf8)!
            return String(data: data, encoding: String.Encoding(rawValue: String.Encoding.nonLossyASCII.rawValue))
        }
}



