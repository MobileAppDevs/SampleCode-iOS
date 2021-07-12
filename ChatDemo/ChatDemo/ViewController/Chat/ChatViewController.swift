//
//  HomeVC.swift
//  ChatDemo
//
//  Created by Amit Chauhan on 22/04/20.
//  Copyright © 2020 Amit Chauhan. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import SDWebImage
import Photos
import FirebaseStorage
import Alamofire
import MapKit
import Contacts
import WebKit


class ChatViewController: UIViewController {
    @IBOutlet weak var img_user                     : UIImageView!
    @IBOutlet weak var lbl_userName                 : UILabel!
    @IBOutlet weak var table_view                   : UITableView!
    @IBOutlet weak var view_header                  : UIView!
    @IBOutlet weak var textView_message             : UITextView!
    @IBOutlet weak var cons_textViewBottom          : NSLayoutConstraint!
    @IBOutlet weak var cons_heightForBottomView     : NSLayoutConstraint!
    @IBOutlet weak var lbl_noDataFound              : UILabel!
    @IBOutlet weak var viewOnlineOffline: UIView!
    
    @IBOutlet weak var btn_attachment: UIButton!
    var arr_chatData                                : [Message]?       = []
    var userData                                    : UserProfileModel?
    
    var senderId                                    : String         = ""
    var receverId                                   : String         = ""
    
    private var otherUser : User?
    
    var isUserOnline                                : Bool           = false
    
    var picker = UIImagePickerController()

    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        userData = UserDefaultManager.sharedInstance.getUserProfileModel()
        
        self.senderId = userData?.uid ?? ""
        
        FBDBManager.shared.getuserWith(uid: self.receverId) {[weak self] (user) in
            self?.otherUser = user
            if let name = self?.otherUser?.name{
                self?.lbl_userName.text = name
            }
            
            if let image = self?.otherUser?.image{
                self?.img_user.sd_imageIndicator = SDWebImageActivityIndicator.white
                self?.img_user.sd_setImage(with: URL(string: image), completed: nil)
            }
        }
        
        registerCell()
        self.gettingDataAndRenderingOnScreen()
        
        
        DispatchQueue.main.async {
            //            self.view_header.addShadowView(width: 0.0, height: 0.0, opacity: 0.5, maskToBounds: true, radius: 0.3, color: UIColor.black)
            self.scrollToTheBottom(animated: false, position: .bottom)
            self.view.layoutIfNeeded()
            self.view.layoutSubviews()
            self.view.setNeedsUpdateConstraints()
        }
        
        let center: NotificationCenter = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardDidChangeFrame(_:)), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
        
//        let tapGestureKeypad = UITapGestureRecognizer.init(target: self, action: #selector(handleKeypadTapGesture(sender:)))
//        table_view.addGestureRecognizer(tapGestureKeypad)
        
        FBDBManager.shared.readAllMessagesFor(receiverId: receverId, isOnline: 1)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        FBDBManager.shared.readAllMessagesFor(receiverId: receverId, isOnline: 0)
    }
    
    
    func registerCell(){
        let messageNib = UINib(nibName: "RMessageCell", bundle: nil)
        table_view.register(messageNib, forCellReuseIdentifier: "RMessageCell")
        
        let rMessageNib = UINib(nibName: "LMessageCell", bundle: nil)
        table_view.register(rMessageNib, forCellReuseIdentifier: "LMessageCell")
        
        let lImageCell = UINib(nibName: "LImageTableViewCell", bundle: nil)
        table_view.register(lImageCell, forCellReuseIdentifier: "LImageTableViewCell")
        
        let rImageCell = UINib(nibName: "RImageTableCell", bundle: nil)
        table_view.register(rImageCell, forCellReuseIdentifier: "RImageTableCell")

        let lLocationCell = UINib(nibName: "LLocationTableCell", bundle: nil)
        table_view.register(lLocationCell, forCellReuseIdentifier: "LLocationTableCell")
        
        let rLocationCell = UINib(nibName: "RLocationTableCell", bundle: nil)
        table_view.register(rLocationCell, forCellReuseIdentifier: "RLocationTableCell")

    }
    
    func gettingDataAndRenderingOnScreen(){
        
        FBDBManager.shared.getAllChatMessage(senderId: senderId, recId: receverId) { (result) in
            
            if result?.count ?? 0 > 0{
                self.table_view.isHidden = false
                self.arr_chatData = result
                self.table_view.reloadData()
                self.lbl_noDataFound.isHidden = true
                self.table_view.scroll(to: .bottom, animated: true)
            }else{
                self.table_view.isHidden = true
                self.lbl_noDataFound.isHidden = false
            }
        }
        
        FBDBManager.shared.observeOtherUser(uid: receverId) {[weak self] (user) in
            if (user?.isOnline ?? 0) == 1{
                // online
                self!.viewOnlineOffline.backgroundColor = UIColor.green
                //viewOnlineOffline.backgroundColor =
                print("user online")
                self!.isUserOnline = true
            }else{
                //ofline
                print("user offline")
                self!.isUserOnline = false
                self!.viewOnlineOffline.backgroundColor = UIColor.lightGray
            }
        }
    }
    
    
    @objc func handleKeypadTapGesture(sender : UITapGestureRecognizer){
        textView_message.resignFirstResponder()
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = (notification as Notification).userInfo, let value = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        var keyboardHeight: CGFloat
        if #available(iOS 11.0, *) {
            keyboardHeight = value.cgRectValue.height - view.safeAreaInsets.bottom
        } else {
            keyboardHeight = value.cgRectValue.height
        }
        let duration: TimeInterval = ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSNumber)?.doubleValue) ?? 0.4
        self.cons_textViewBottom.constant = -keyboardHeight
        
        //        UIView.animate(withDuration: duration) {
        //            self.view.layoutIfNeeded()
        //            self.scrollToTheBottom(animated: false,position: .bottom)
        //        }
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: duration) {
                self.view.layoutIfNeeded()
                self.view.setNeedsUpdateConstraints()
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        guard let userInfo = (notification as Notification).userInfo, let _ = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        //        self.scrollToTheBottom(animated: false,position: .bottom)
        
        DispatchQueue.main.async {
            self.cons_textViewBottom.constant = 0
            UIView.performWithoutAnimation {
                self.view.layoutIfNeeded()
                self.view.setNeedsUpdateConstraints()
            }//keyboardFrameEndUserInfoKey
        }
    }
    
    @objc func keyboardDidChangeFrame(_ notification: Notification) {
        guard let userInfo = (notification as Notification).userInfo, let value = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        var keyboardHeight: CGFloat
        if #available(iOS 11.0, *) {
            keyboardHeight = value.cgRectValue.height - view.safeAreaInsets.bottom
        } else {
            keyboardHeight = value.cgRectValue.height
        }
        //        self.scrollToTheBottom(animated: false,position: .bottom)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    //MARK:- Button Action
    @IBAction func btn_backAction(_ sender: Any) {
        /*FBDBManager.shared.disconnectAllObserver()
         NotificationCenter.default.post(name: Notification.Name("CheckMessageCount"), object: nil)*/
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btn_attachmentAction(_ sender: Any) {
        self.textView_message.resignFirstResponder()
        
            let alert = UIAlertController(title: nil, message: "Choose your option", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Camera", style: .default) { (result : UIAlertAction) -> Void in
                print("Camera selected")
                self.openCamera()
            })
            alert.addAction(UIAlertAction(title: "Gallery", style: .default) { (result : UIAlertAction) -> Void in
                print("Photo selected")
                self.openGallery()
            })
        alert.addAction(UIAlertAction(title: "Video", style: .default) { (result : UIAlertAction) -> Void in
            print("Video selected")
            self.openGalleryOrPickVideo()
        })
        alert.addAction(UIAlertAction(title: "Document", style: .default) { (result : UIAlertAction) -> Void in
            print("Docuent selected")
            self.openDocumentBrowser()
        })

        alert.addAction(UIAlertAction(title: "Contacts", style: .default) { (result : UIAlertAction) -> Void in
            self.openContactScreen()
        })
        alert.addAction(UIAlertAction(title: "Location", style: .default) { (result : UIAlertAction) -> Void in
            self.openMapScreen()
        })

        alert.addAction(UIAlertAction(title: "Cancel", style: .default) { (result : UIAlertAction) -> Void in
            print("cancel")
            alert.dismiss(animated: true, completion: nil)
        })
        present(alert, animated: true, completion: nil)

//        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController( withIdentifier: "SelectFileViewController") as! SelectFileViewController
//        viewController.delegate = self
//        self.present(viewController, animated: true, completion: nil)
    }
    
    func openCamera(){
        //    alert.dismiss(animated: true, completion: nil)
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            picker.delegate = self
            picker.allowsEditing = false
            self.present(picker, animated: true, completion: nil)
        } else {
            _ = AlertController.getInstance().alert(title: "Warning", message: "You don't have camera")
        }
    }
    
    func openGallery(){
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }

    func openGalleryOrPickVideo()  {
        
        picker =  UIImagePickerController()
        //
        picker.sourceType = .photoLibrary
        picker.modalPresentationStyle = .fullScreen
        picker.mediaTypes = ["public.movie"]
        picker.delegate = self
        DispatchQueue.main.async(execute: {
            self.present(self.picker, animated: true, completion: nil)
        })
    }
    
    func openDocumentBrowser(){
        let contoller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DocumentBrowserViewController") as! DocumentBrowserViewController
        //        navigationControllerInstance =  UINavigationController()
        contoller.documentDelegate = self
        self.navigationController?.present(contoller, animated: true, completion: nil)
    }

    func openContactScreen(){
        let contoller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ContactListVC") as! ContactListVC
        contoller.contactDelegate = self
        self.present(contoller, animated: true, completion: nil)
        //self.navigationController?.present(contoller, animated: true, completion: nil)
    }
    
    func openMapScreen(){
        let contoller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        contoller.locationDelegate = self
        self.present(contoller, animated: true, completion: nil)
        //self.navigationController?.present(contoller, animated: true, completion: nil)
    }


    @IBAction func btn_sendAction(_ sender: Any) {
        DispatchQueue.main.async {
            let (isValidate, errorMessage) = self.getValidate()
            if isValidate{
                
                //                if self.isUserOnline == false{
                //
                //                    self.sendChatPushNotification(notificationType: "CHAT_MESSAGE", message: self.textView_message.text!, title: self.trippie_title, receiverUserId: self.receverId, trippieId: self.trippie_id) { (isSuccess, message) in
                //                        print("issuccess >>", isSuccess)
                //                        print("message >>", message)
                //                    }
                //                }
                
                FBDBManager.shared.sendMessages(senderId: self.senderId, recId: self.receverId, text: self.textView_message.text!, type: MessageType.text, imageURL: "", latitude: 0.0, longitude: 0.0)
                
                self.textView_message.text = ""
                self.view.layoutIfNeeded()
                self.view.layoutSubviews()
                self.view.setNeedsUpdateConstraints()
                self.cons_heightForBottomView.constant = 82
                self.textView_message.isScrollEnabled = false
            }else{
                AlertController.getInstance().showAlert(message: errorMessage, sender: self)
            }
        }
    }
    
    
    
    
    
    //MARK:- send Push Notification and update notification collection firestore
    //    func sendChatPushNotification(notificationType: String, message: String, title: String, receiverUserId: String, trippieId: String, completionHandler: @escaping (_ isSuccess: Bool, _ error: String) -> Void) {
    //
    //        let userModel = UserDefaultManager.sharedInstance.getProfileModel()
    //
    //        let requestDict: [String: Any] = ["message": message,
    //                                          "notificationType": notificationType,
    //                                          "platform": "iOS",
    //                                          "receiverUserId": receiverUserId,
    //                                          "senderUserId": userModel?.userId ?? "",
    //                                          "title": title,
    //                                          "trippieId": trippieId
    //        ]
    //        print("request dict >", requestDict)
    //        NotificationManager.sharedInstance.callSendChatNotification(requestDict: requestDict) { (isSuccess, response, errorMessage) in
    //            print(isSuccess)
    //            print(errorMessage)
    //            completionHandler(isSuccess, errorMessage)
    //        }
    //    }
    
    
    //MARK: - Validate Form
    private func getValidate() -> (Bool, String){
        var error : (Bool, String) = (false, "")
        if(self.textView_message.text == "") || (self.textView_message.text == "type..."){
            error = (false, "Please Enter message")
        }
        else{
            error = (true, "")
        }
        return error
    }
    
    
    internal let DEFAULT_MIME_TYPE = "application/octet-stream"
    
    internal let mimeTypes = [
        "html": "text/html",
        "htm": "text/html",
        "shtml": "text/html",
        "css": "text/css",
        "xml": "text/xml",
        "gif": "image/gif",
        "jpeg": "image/jpeg",
        "jpg": "image/jpeg",
        "js": "application/javascript",
        "atom": "application/atom+xml",
        "rss": "application/rss+xml",
        "mml": "text/mathml",
        "txt": "text/plain",
        "jad": "text/vnd.sun.j2me.app-descriptor",
        "wml": "text/vnd.wap.wml",
        "htc": "text/x-component",
        "png": "image/png",
        "tif": "image/tiff",
        "tiff": "image/tiff",
        "wbmp": "image/vnd.wap.wbmp",
        "ico": "image/x-icon",
        "jng": "image/x-jng",
        "bmp": "image/x-ms-bmp",
        "svg": "image/svg+xml",
        "svgz": "image/svg+xml",
        "webp": "image/webp",
        "woff": "application/font-woff",
        "jar": "application/java-archive",
        "war": "application/java-archive",
        "ear": "application/java-archive",
        "json": "application/json",
        "hqx": "application/mac-binhex40",
        "doc": "application/msword",
        "pdf": "application/pdf",
        "ps": "application/postscript",
        "eps": "application/postscript",
        "ai": "application/postscript",
        "rtf": "application/rtf",
        "m3u8": "application/vnd.apple.mpegurl",
        "xls": "application/vnd.ms-excel",
        "eot": "application/vnd.ms-fontobject",
        "ppt": "application/vnd.ms-powerpoint",
        "wmlc": "application/vnd.wap.wmlc",
        "kml": "application/vnd.google-earth.kml+xml",
        "kmz": "application/vnd.google-earth.kmz",
        "7z": "application/x-7z-compressed",
        "cco": "application/x-cocoa",
        "jardiff": "application/x-java-archive-diff",
        "jnlp": "application/x-java-jnlp-file",
        "run": "application/x-makeself",
        "pl": "application/x-perl",
        "pm": "application/x-perl",
        "prc": "application/x-pilot",
        "pdb": "application/x-pilot",
        "rar": "application/x-rar-compressed",
        "rpm": "application/x-redhat-package-manager",
        "sea": "application/x-sea",
        "swf": "application/x-shockwave-flash",
        "sit": "application/x-stuffit",
        "tcl": "application/x-tcl",
        "tk": "application/x-tcl",
        "der": "application/x-x509-ca-cert",
        "pem": "application/x-x509-ca-cert",
        "crt": "application/x-x509-ca-cert",
        "xpi": "application/x-xpinstall",
        "xhtml": "application/xhtml+xml",
        "xspf": "application/xspf+xml",
        "zip": "application/zip",
        "bin": "application/octet-stream",
        "exe": "application/octet-stream",
        "dll": "application/octet-stream",
        "deb": "application/octet-stream",
        "dmg": "application/octet-stream",
        "iso": "application/octet-stream",
        "img": "application/octet-stream",
        "msi": "application/octet-stream",
        "msp": "application/octet-stream",
        "msm": "application/octet-stream",
        "docx": "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
        "xlsx": "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
        "pptx": "application/vnd.openxmlformats-officedocument.presentationml.presentation",
        "mid": "audio/midi",
        "midi": "audio/midi",
        "kar": "audio/midi",
        "mp3": "audio/mpeg",
        "ogg": "audio/ogg",
        "m4a": "audio/x-m4a",
        "ra": "audio/x-realaudio",
        "3gpp": "video/3gpp",
        "3gp": "video/3gpp",
        "ts": "video/mp2t",
        "mp4": "video/mp4",
        "mpeg": "video/mpeg",
        "mpg": "video/mpeg",
        "mov": "video/quicktime",
        "webm": "video/webm",
        "flv": "video/x-flv",
        "m4v": "video/x-m4v",
        "mng": "video/x-mng",
        "asx": "video/x-ms-asf",
        "asf": "video/x-ms-asf",
        "wmv": "video/x-ms-wmv",
        "avi": "video/x-msvideo"
    ]
    
    func MimeTypeURL(ext: String?) -> String {
        if ext != nil && mimeTypes.contains(where: { $0.0 == ext!.lowercased() }) {
            return mimeTypes[ext!.lowercased()]!
        }
        return DEFAULT_MIME_TYPE
    }
}


extension ChatViewController : UITextViewDelegate{
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == "type..."{
            textView.text = ""
            textView.textColor  = UIColor.black
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        DispatchQueue.main.async {
            if textView.text == "type..."{
                textView.text = ""
                self.textView_message.textColor = UIColor.black
            }else{
                
            }
            self.scrollToTheBottom(animated: false, position: .bottom)
            self.view.layoutIfNeeded()
            self.view.layoutSubviews()
            self.view.setNeedsUpdateConstraints()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""{
            textView_message.text = "type..."
            textView_message.textColor = UIColor.lightGray
        }else{
            
        }
    }
    
    func scrollToTheBottom(animated: Bool, position: UITableView.ScrollPosition)
    {
        let numberOfSections = table_view.numberOfSections
        let numberOfRows = table_view.numberOfRows(inSection: numberOfSections-1)
        if numberOfRows > 0 {
            let indexPath = NSIndexPath(row: numberOfRows-1,section: (numberOfSections-1))
            table_view.scrollToRow(at: indexPath as IndexPath, at: position, animated: false)
            self.view.layoutIfNeeded()
            self.view.layoutSubviews()
            self.view.setNeedsUpdateConstraints()
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if targetContentOffset.pointee.y < scrollView.contentOffset.y{
            //UP
            self.textView_message.resignFirstResponder()
            //            self.view.endEditing(true)
        }else{
            //DOWN
        }
    }
    //   amit.chauhan332@gmail.com       AMIT@charu143 
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let  char = text.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        var temp = ""
        
        if (isBackSpace == -92) {
            if (textView.text! == "") {
                //                debugPrint("text 1 ",textView.text!)
            }else{ // backgroud typing
                let nsString = textView.text as NSString?
                let newString = nsString?.replacingCharacters(in: range, with: text)
                temp = newString!
                let size = textView_message.contentSize.height
                if size > 100{
                    textView_message.isScrollEnabled = true
                }else{
                    textView_message.isScrollEnabled = false
                }
            }
        }else{ // forward typing
            
            let nsString = textView.text as NSString?
            let newString = nsString?.replacingCharacters(in: range, with: text)
            temp = newString!
            let size = textView_message.contentSize.height
            if size > 100{
                textView_message.isScrollEnabled = true
            }else{
                textView_message.isScrollEnabled = false
            }
        }
        
        return true
    }
}


extension ChatViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if arr_chatData?.count ?? 0 > 0{
            self.table_view.isHidden = false
            self.lbl_noDataFound.isHidden = true
        }else{
            self.table_view.isHidden = true
            self.lbl_noDataFound.isHidden = false
        }
        return arr_chatData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = self.arr_chatData?[indexPath.row]

        if data?.type == MessageType.text{
            switch data?.cellType {
            case .my:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "RMessageCell", for: indexPath) as? RMessageCell else {
                    return UITableViewCell()
                }
                
                cell.roundCorner()
                
                cell.lbl_text.text = data?.text ?? ""
                
                if let time = data?.time{
                    cell.lbl_time.isHidden = false
                    cell.lbl_time.text = FunctionConstants.getInstance().GetDateFromTimestamp(TimeStamp: time, DateFormat: "MMM dd,hh:mm a")
                }else{
                    cell.lbl_time.isHidden = true
                }
                
                return cell
                
            case .friend:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "LMessageCell", for: indexPath) as? LMessageCell else {
                    return UITableViewCell()
                }
                cell.roundCorner()
                cell.lbl_message.text = data?.text ?? ""
                if let time = data?.time{
                    cell.lbl_time.isHidden = false
                    cell.lbl_time.text = FunctionConstants.getInstance().GetDateFromTimestamp(TimeStamp: time, DateFormat: "MMM dd,hh:mm a")
                }else{
                    cell.lbl_time.isHidden = true
                }
                
                return cell
                
            default:
                return UITableViewCell()
                
            }
        }else if data?.type == MessageType.image{ // image
            switch data?.cellType {
            case .my:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "RImageTableCell", for: indexPath) as? RImageTableCell else {
                    return UITableViewCell()
                }
                
                cell.roundCorner()
                
//                self.btnSelectImage.sd_imageIndicator = SDWebImageActivityIndicator.white
//                self.btnSelectImage.sd_setImage(with: URL(string: image), for: .normal, completed: nil)

                let filename = self.getImageName(imageURL: data?.ImageURL ?? "")

                self.getImageExist(fileNmae: filename) { (image, isexist) in
                    if isexist{
                        cell.img_Rimage.image = image
                    }else{
                        if let url = data?.ImageURL{
                            cell.img_Rimage.sd_setImage(with:  URL(string: url), completed: nil)
                        }else{
                            cell.img_Rimage.image = UIImage(named: "user_icon")
                        }
                    }
                }

                if let time = data?.time{
                    cell.lbl_time.isHidden = false
                    cell.lbl_time.text = FunctionConstants.getInstance().GetDateFromTimestamp(TimeStamp: time, DateFormat: "MMM dd,hh:mm a")
                }else{
                    cell.lbl_time.isHidden = true
                }
                
                return cell
                
            case .friend:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "LImageTableViewCell", for: indexPath) as? LImageTableViewCell else {
                    return UITableViewCell()
                }
                cell.roundCorner()

                let filename = self.getImageName(imageURL: data?.ImageURL ?? "")

                self.getImageExist(fileNmae: filename) { (image, isexist) in
                    if isexist{
                        cell.img_Limage.image = image
                        cell.view_blur.isHidden = true
                        cell.btn_download.isHidden = true
                    }else{
                        cell.view_blur.isHidden = false
                        cell.btn_download.isHidden = false

                    }
                }
                                
                if let url = data?.ImageURL{
                    cell.img_Limage.sd_setImage(with:  URL(string: url), completed: nil)
                }else{
                    cell.img_Limage.image = UIImage(named: "user_icon")
                }

                if let time = data?.time{
                    cell.lbl_time.isHidden = false
                    cell.lbl_time.text = FunctionConstants.getInstance().GetDateFromTimestamp(TimeStamp: time, DateFormat: "MMM dd,hh:mm a")
                }else{
                    cell.lbl_time.isHidden = true
                }
                
                cell.btn_download.tag = indexPath.row
                cell.btn_download.addTarget(self,action:#selector(btn_downloadAction),
                                          for:.touchUpInside)

                return cell
                
            default:
                return UITableViewCell()
            }
        }else if data?.type == MessageType.location { // Location
            switch data?.cellType {
            case .my:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "RLocationTableCell", for: indexPath) as? RLocationTableCell else {
                    return UITableViewCell()
                }
                
                cell.roundCorner()
                
                
                let filename = self.getLocationImageName(imageURL: data?.ImageURL ?? "")
                
                self.getImageExist(fileNmae: filename) { (image, isexist) in
                    if isexist{
                        cell.imgLocationImage.image = image
                    }else{
                        if let url = data?.ImageURL{
                            cell.imgLocationImage.sd_setImage(with:  URL(string: url), completed: nil)
                        }else{
                            cell.imgLocationImage.image = UIImage(named: "user_icon")
                        }
                    }
                }
                
                if let time = data?.time{
                    cell.lblTime.isHidden = false
                    cell.lblTime.text = FunctionConstants.getInstance().GetDateFromTimestamp(TimeStamp: time, DateFormat: "MMM dd,hh:mm a")
                }else{
                    cell.lblTime.isHidden = true
                }
                
                return cell
                
            case .friend:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "LLocationTableCell", for: indexPath) as? LLocationTableCell else {
                    return UITableViewCell()
                }
                cell.roundCorner()
                
                let filename = self.getLocationImageName(imageURL: data?.ImageURL ?? "")
                
                self.getImageExist(fileNmae: filename) { (image, isexist) in
                    if isexist{
                        cell.imgLocationImage.image = image
                    }else{
                        if let url = data?.ImageURL{
                            cell.imgLocationImage.sd_setImage(with:  URL(string: url), completed: nil)
                        }else{
                            cell.imgLocationImage.image = UIImage(named: "user_icon")
                        }
                    }
                }
                if let time = data?.time{
                    cell.lblTime.isHidden = false
                    cell.lblTime.text = FunctionConstants.getInstance().GetDateFromTimestamp(TimeStamp: time, DateFormat: "MMM dd,hh:mm a")
                }else{
                    cell.lblTime.isHidden = true
                }
                return cell
                
            default:
                return UITableViewCell()
            }
        }else{ // Contact
            switch data?.cellType {
            case .my:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "RLocationTableCell", for: indexPath) as? RLocationTableCell else {
                    return UITableViewCell()
                }
                
                cell.roundCorner()
                
                self.getcontactOnFirebase(urlstr: data?.ImageURL ?? "")
                
//                let header = ["content-type" : "application/json"]
//                WebService().request(parameter: [:], callType: HTTPMethod.get, Url: data?.ImageURL ?? "", isAnimated: false, extraVariable: "", headerParam: header) { (response, error) in
//                    debugPrint("error >>", error)
//                    debugPrint("respon >>", response)
//                    debugPrint("respon >>", response?.value)
//
//                }
                
                
                return cell
                
            case .friend:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "LLocationTableCell", for: indexPath) as? LLocationTableCell else {
                    return UITableViewCell()
                }
                cell.roundCorner()
                
                return cell
                
            default:
                return UITableViewCell()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        debugPrint("didSelectRowAt>")
        let dict = self.arr_chatData?[indexPath.row]
        
        if dict?.type == MessageType.location{
            
            self.openMapForPlace(lat: dict!.latitude!, long: dict!.longitude!)
        }
    }
    
    
    func getcontactOnFirebase(urlstr : String){
           var semaphore = DispatchSemaphore (value: 0)

           var request = URLRequest(url: URL(string: urlstr)!,timeoutInterval: Double.infinity)
           request.httpMethod = "GET"

           let task = URLSession.shared.dataTask(with: request) { data, response, error in
             guard let data = data else {
               print(String(describing: error))
               return
             }
             print(String(data: data, encoding: .utf8))

            
//            let con = data as? CNMutableContact
            
            
             semaphore.signal()
           }
           task.resume()
           semaphore.wait()
       }
    
    func openMapForPlace(lat : Double, long : Double) {

        let latitude: CLLocationDegrees = lat
        let longitude: CLLocationDegrees = long

        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
//        mapItem.name = "Place Name"
        mapItem.openInMaps(launchOptions: options)
    }

    
    @objc func btn_downloadAction(sender:UIButton){
        print("sender tag", sender.tag)
        
        let dict = self.arr_chatData?[sender.tag]
        let fileName = self.getImageName(imageURL: dict?.ImageURL ?? "")
        let indexpath = IndexPath(row: sender.tag, section: 0)
        let cell = table_view.cellForRow(at: indexpath) as! LImageTableViewCell
        
        self.saveImageDocumentDirectory(image: (cell.img_Limage.image!), imageName: fileName) { (saved) in
            if saved{
                cell.btn_download.isHidden = true
                cell.view_blur.isHidden = true
            }else{
                AlertController.getInstance().showAlert(message: "Something went wrong", sender: self)
            }
        }
    }
    
    func getImageName(imageURL : String)-> String{
        let arrImg = imageURL.components(separatedBy: "images")
        let str = arrImg[1].components(separatedBy: "?alt")
        return str[0]
    }
    
    func getLocationImageName(imageURL : String)-> String{
        let arrImg = imageURL.components(separatedBy: "locations")
        let str = arrImg[1].components(separatedBy: "?alt")
        return str[0]
    }

    func saveImageDocumentDirectory(image : UIImage, imageName : String, completion:@escaping ( _ issaved: Bool) -> Void){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
//        let image = UIImage(named: "apple.jpg")
        print(paths)
        let imageData = image.jpegData(compressionQuality: 0.5)
        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
    }
    
    func deleteDirectory(){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("customDirectory")
        if fileManager.fileExists(atPath: paths){
            try! fileManager.removeItem(atPath: paths)
        }else{
            print("Something wronge.")
        }
    }

    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func getImageExist(fileNmae : String, completion:@escaping ( _ image: UIImage?, _ exist: Bool) -> Void) {
        let fileManager = FileManager.default
        let imagePAth = (self.getDirectoryPath() as NSString).appendingPathComponent(fileNmae)
        if fileManager.fileExists(atPath: imagePAth){
            completion(UIImage(contentsOfFile: imagePAth), true)
//            self.imageView.image = UIImage(contentsOfFile: imagePAth)
        }else{
//            print("No Image")
            completion(nil, false)
        }
    }
}

extension UITableView {
    
    func scroll(to: Position, animated: Bool) {
        let sections = numberOfSections
        let rows = numberOfRows(inSection: numberOfSections - 1)
        switch to {
        case .top:
            if rows > 0 {
                let indexPath = IndexPath(row: 0, section: 0)
                self.scrollToRow(at: indexPath, at: .top, animated: animated)
            }
            break
        case .bottom:
            if rows > 0 {
                let indexPath = IndexPath(row: rows - 1, section: sections - 1)
                self.scrollToRow(at: indexPath, at: .bottom, animated: animated)
            }
            break
        }
    }
    
    enum Position {
        case top
        case bottom
    }
}


extension ChatViewController : SelectFileDelegate{
    func selctFileItemwith(item: String) {
        if item == "Gallery"{
            print("gallery")
            
            ImagePicker.openImagePicker { (image, name) in
                print("gallery name > ",name)

            }
        }else{
            
        }
    }
}


extension ChatViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion:nil)

        if let _ = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{

        }
        else if let capturedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            {
                if let data = capturedImage.jpegData(compressionQuality: 0.25){ // convert your UIImage into Data object using png representation
//                    self.saveFileInDocumentAndUplaod(capturedImage: capturedImage, imgExt: "jpeg")

                    let randomInt = Int.random(in: 0..<100000000)
                    let serverfileName = "Image\(randomInt).jpeg"
                    
                    FirebaseStorageManager().uploadImageDataonfirebaseStorage(data: data, uid: UserDefaultManager.sharedInstance.getUserProfileModel()?.uid ?? "", serverFileName: serverfileName) { (isSuccess, url) in
                        if isSuccess{

                            print("url >> ", url)
                            
                            FBDBManager.shared.sendMessages(senderId: self.senderId, recId: self.receverId, text: "", type: MessageType.image, imageURL: url ?? "", latitude: 0.0, longitude: 0.0)
                            
                            let filename = self.getImageName(imageURL: url ?? "")
                            self.saveImageDocumentDirectory(image: capturedImage, imageName: filename) { (issaved) in
                            }
                            
                            self.textView_message.text = ""
                            self.view.layoutIfNeeded()
                            self.view.layoutSubviews()
                            self.view.setNeedsUpdateConstraints()
                            self.cons_heightForBottomView.constant = 82
                            self.textView_message.isScrollEnabled = false

                        }else{
                            _ = AlertController.getInstance().alert(title: "Error", message: "Something went wrong. Please try again")
                        }
                    }
                }else{
                    _ = AlertController.getInstance().alert(title: "Error", message: "Something went wrong. Please try again")
                }
            }
            else
            {
                if let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? URL{
                    print("videourl: ", videoUrl)
                    //trying compression of video
                    let data = NSData(contentsOf: videoUrl)!
                    //print("File size before compression: \(Double(data.length / 1048576)) mb")

//                    FirebaseStorageManager().uploadVideoDataonFirebaseStorage(data: data, fileName: "") { (success, url) in
//
//                    }

                }
                else{
                    //print("Something went wrong in  video")
                }
                
                picker.dismiss(animated: true) {
                }

        }

    }
}


extension ChatViewController : documentBrowserDelegate{
    
    func sendUrlForSelectedDocument(selectedUrl: URL) {
        debugPrint("url >>>", selectedUrl)
        do {
            let data = try Data.init(contentsOf: selectedUrl)
            print("data:\(data)")
            
            let mineType = MimeTypeURL(ext: selectedUrl.pathExtension)
//            let mineType11 = selectedUrl.MimeTypeURL(self.pathExtension)
//            let mineType = selectedUrl.mimeType()
            debugPrint("mineType >>>", mineType)

            let arr = selectedUrl.absoluteString.split(separator: "/")
            print(arr)
            let filename = arr[arr.count-1]
            
            
            
            
        } catch let err {
            print("Error:\(err.localizedDescription)")
        }
    }
    
}


extension ChatViewController : LocationDelegate{
    func selectLocationwith(latitude: Double, longitude: Double, mapImageURL: String) {
        
        let escapedAddress = mapImageURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        Alamofire.request(escapedAddress!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: [:]).responseJSON { (response) in
            
            guard let data = response.data else{
                return
            }
            
            let locationImage: UIImage = UIImage(data: data)!
            print("uiImage >> ",locationImage)
            //uiImage >>  <UIImage:0x600001365f80 anonymous {600, 300}>
            
            if let data = locationImage.jpegData(compressionQuality: 0.25){ // convert your UIImage into Data object using png representation
                //                    self.saveFileInDocumentAndUplaod(capturedImage: capturedImage, imgExt: "jpeg")
                
                let randomInt = Int.random(in: 0..<100000000)
                let serverfileName = "locationImage\(randomInt).jpeg"
                
                FirebaseStorageManager().uploadLocationImageDataonfirebaseStorage(data: data, uid: UserDefaultManager.sharedInstance.getUserProfileModel()?.uid ?? "", serverFileName: serverfileName) { (isSuccess, url) in
                    if isSuccess{
                        
                        FBDBManager.shared.sendMessages(senderId: self.senderId, recId: self.receverId, text: "", type: MessageType.location, imageURL: url ?? "", latitude: latitude, longitude: longitude)
                        
                        let filename = self.getLocationImageName(imageURL: url ?? "")
                        self.saveImageDocumentDirectory(image: locationImage, imageName: filename) { (issaved) in
                        }
                        
                        self.textView_message.text = ""
                        self.view.layoutIfNeeded()
                        self.view.layoutSubviews()
                        self.view.setNeedsUpdateConstraints()
                        self.cons_heightForBottomView.constant = 82
                        self.textView_message.isScrollEnabled = false
                        
                    }else{
                        _ = AlertController.getInstance().alert(title: "Error", message: "Something went wrong. Please try again")
                    }
                }
            }else{
                _ = AlertController.getInstance().alert(title: "Error", message: "Something went wrong. Please try again")
            }

        }
    }
}

extension ChatViewController : contactDelegate{
    func selectContactwith(dict: Contact) {
        
        let contact = createContact(dict: dict)

        do {
            try shareContacts(dict: dict, contacts: [contact])
        }
        catch {
            // Handle error
        }
    }
    
}


extension ChatViewController{
    
    func createContact(dict : Contact) -> CNContact {

        // Creating a mutable object to add to the contact
        let contact = CNMutableContact()

        contact.imageData = Data() // The profile picture as a NSData object

        contact.givenName = dict.name ?? ""
        contact.familyName = dict.countryCode ?? ""
        

        contact.phoneNumbers = [CNLabeledValue(
            label:CNLabelPhoneNumberiPhone,
            value:CNPhoneNumber(stringValue:dict.number ?? ""))]

        return contact
    }

    
    func shareContacts(dict: Contact, contacts: [CNContact]) throws {

        let data = try CNContactVCardSerialization.data(with: contacts)

        let randomInt = Int.random(in: 0..<100000000)
        let fileName = "\(dict.name ?? "")_\(randomInt).vcf"
        
        FirebaseStorageManager().uploadcontactDataFirebaseStorage(data: data, uid: UserDefaultManager.sharedInstance.getUserProfileModel()?.uid ?? "", fileName: fileName) { (isSuccess, url) in
            if isSuccess{
                
                FBDBManager.shared.sendMessages(senderId: self.senderId, recId: self.receverId, text: "", type: MessageType.contact, imageURL: url ?? "", latitude: 0.0, longitude: 0.0)
                
                self.textView_message.text = ""
                self.view.layoutIfNeeded()
                self.view.layoutSubviews()
                self.view.setNeedsUpdateConstraints()
                self.cons_heightForBottomView.constant = 82
                self.textView_message.isScrollEnabled = false
                
            }else{
                _ = AlertController.getInstance().alert(title: "Error", message: "Something went wrong. Please try again")
            }
        }
        
        
        //                FirebaseStorageManager().uploadLocationImageDataonfirebaseStorage(data: data, uid: UserDefaultManager.sharedInstance.getUserProfileModel()?.uid ?? "", serverFileName: serverfileName) { (isSuccess, url) in

    }

}
