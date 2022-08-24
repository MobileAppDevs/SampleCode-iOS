


import UIKit
import NYTPhotoViewer

class PUserProfileVC: UIViewController{
    
    @IBOutlet weak var lblUserShortName: UILabel!
    @IBOutlet weak var lblDegree: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var imgUserBanner: UIImageView!
    @IBOutlet weak var btnConnect: UIButton!
    @IBOutlet weak var btnChat: UIButton!
    @IBOutlet weak var imgStatus: UIImageView!
    @IBOutlet weak var lblUserCaption: UILabel!
    @IBOutlet weak var lblUserProfileViewedCount: UILabel!
    @IBOutlet weak var tblView: UITableView!
    var isLoading = false
    var sections = ["About me", "Mutual friends", "Profile"]
    var userDetail = [String]()
    var detailImg  = ["gender_iPhone", "married_iPhone", "dob_iPhone","flame_iPhone"]
    var mutualFriends = [PPeople]()
    var friend:PFriendsInfo!
    var photos = PhotosProvider().photos
    var imgUpdateType = 0
    var imgSender:UIImageView!

    var notification: PNotification!
    var locationInfo:PLocationInfo!
    var navController:UINavigationController!
    var isFromNotifcation = false
    
    enum ProfileSection:Int {
        case AboutMe = 0
        case MutualFriends
        case Profile
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(PUserProfileVC.receiveNotification(_:)), name: .pNotification, object: nil)
        if navController == nil {
            navController =  self.navigationController
        }
        
        getFriendInfo() {
            DispatchQueue.main.async {
                self.refreshScreen()
                if kAppDelegate.branchData != nil && kAppDelegate.branchData.count > 0 {
                    self.navigateActions()                    
                }
            }
        }
        
        // Do any additional setup after loading the view.
        lblUserName.text = friend.full_name.capitalized
        tblView.isHidden = true
        
        if isFromNotifcation{
            kAppDelegate.lessBadgeValue(badge: 1)
//            kAppDelegate.getNotificationData(completionBlock: { (_) in
//
//            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //====================================================================================================
    //MARK: -  METHODS
    //====================================================================================================
    
    //Notification callbacks
    func receiveNotification(_ notification: Notification){
        
        if notification.name == .pNotification {
            if notification.userInfo != nil {
                let userInfo = notification.userInfo as! Dictionary<String, AnyObject>
                if let senderId = userInfo[pId] as? String
                {
                    if senderId == friend.id {
                        
                        if userInfo[pFriend_status] != nil && userInfo[pFriend_status] as? String != "" {
                            let f_status = Int("\(userInfo[pFriend_status]!)")!
                            if f_status == Connection.Connect.rawValue {
                                self.friend.is_friend = f_status
                                self.friend.sender_id = senderId
                            }else{
                                self.friend.is_friend = f_status
                            }
                            getFriendInfo() {
                                DispatchQueue.main.async {
                                    self.refreshScreen()
                                }
                            }
                        }
                    }
                }
                
            }
            DispatchQueue.main.async{
                self.refreshScreen()
            }
        }
        
    }
    
    func formatEnableButton(title:String,btn:UIButton, bgColor:String, textColor:String, icon:UIImage){
        btn.backgroundColor = hexStringToUIColor(bgColor)
        btn.setTitleColor(hexStringToUIColor(textColor), for: .normal)
        btn.setTitle(title, for: .normal)
        btn.isUserInteractionEnabled = true
        btn.setImage(icon, for: .normal)
        btn.layer.borderColor = hexStringToUIColor(textColor).cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 5
    }
    func formatDisableButton(title:String,btn:UIButton, bgColor:String, textColor:String, icon:UIImage){
        btn.backgroundColor = hexStringToUIColor(bgColor)
        btn.setTitleColor(hexStringToUIColor(textColor), for: .normal)
        btn.setTitle(title, for: .normal)
        btn.isUserInteractionEnabled = false
        btn.setImage(icon, for: .normal)
        btn.layer.borderColor = hexStringToUIColor(textColor).cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 5
    }
    func refreshScreen(){
        
        tblView.isHidden = false
        tblView.isScrollEnabled = true
        switch friend.is_friend {
        case Connection.Unfriend.rawValue :
            formatEnableButton(title: " Add friend", btn: btnConnect, bgColor: cWhite, textColor: cBlueTheme, icon:#imageLiteral(resourceName: "add_friends_iPhone"))
            formatEnableButton(title: " Message", btn: btnChat, bgColor: cLightGreyNew, textColor: cWhite, icon:#imageLiteral(resourceName: "chat_white_iPhone"))
            break
        case  Connection.Accept.rawValue :
            formatEnableButton(title: " Friends", btn: btnConnect, bgColor: cWhite, textColor: cBlueTheme, icon:#imageLiteral(resourceName: "friends"))
            formatEnableButton(title: " Message", btn: btnChat, bgColor: cWhite, textColor: cBlueTheme, icon:#imageLiteral(resourceName: "chat_iPhone"))
            break
        case  Connection.Connect.rawValue :
            if friend.sender_id == kAppDelegate.objUserInfo.id {
                formatEnableButton(title: " Cancel Request ", btn: btnConnect, bgColor: cWhite, textColor: cBlueTheme, icon:#imageLiteral(resourceName: "cancel_request_iPhone"))
                formatEnableButton(title: " Message", btn: btnChat, bgColor: cLightGreyNew, textColor: cWhite, icon:#imageLiteral(resourceName: "chat_white_iPhone"))
            }else {
                formatEnableButton(title: " Confirm", btn: btnConnect, bgColor: cBlueTheme, textColor: cWhite, icon:#imageLiteral(resourceName: "confirm_iPhone"))
                formatEnableButton(title: " Ignore", btn: btnChat, bgColor: cWhite, textColor: cLightGreyNew, icon:#imageLiteral(resourceName: "cancel_iPhone"))
            }
            break
        case  Connection.Ignore.rawValue :
            if friend.sender_id == kAppDelegate.objUserInfo.id {
                formatEnableButton(title: " Cancel Request ", btn: btnConnect, bgColor: cWhite, textColor: cBlueTheme, icon:#imageLiteral(resourceName: "cancel_request_iPhone"))
                formatEnableButton(title: " Message", btn: btnChat, bgColor: cLightGreyNew, textColor: cWhite, icon:#imageLiteral(resourceName: "chat_white_iPhone"))
            }else {
                formatEnableButton(title: " Confirm", btn: btnConnect, bgColor: cBlueTheme, textColor: cWhite, icon:#imageLiteral(resourceName: "confirm_iPhone"))
                formatEnableButton(title: " Message", btn: btnChat, bgColor: cDarkGrey, textColor: cWhite, icon:#imageLiteral(resourceName: "chat_white_iPhone"))
            }
            break
        case  Connection.Cancel.rawValue :
            formatEnableButton(title: " Add friend", btn: btnConnect, bgColor: cWhite, textColor: cBlueTheme, icon:#imageLiteral(resourceName: "add_friends_iPhone"))
            formatEnableButton(title: " Message", btn: btnChat, bgColor: cLightGreyNew, textColor: cWhite, icon:#imageLiteral(resourceName: "chat_white_iPhone"))
            break
        default:
            break
        }
        
        mutualFriends = friend.mutualFriends
        //        mutualFriends.append(contentsOf: friend.mutualFriends)
        //        mutualFriends.append(contentsOf: friend.mutualFriends)
        //        mutualFriends.append(contentsOf: friend.mutualFriends)
        //        mutualFriends.append(contentsOf: friend.mutualFriends)
        //        mutualFriends.append(contentsOf: friend.mutualFriends)
        
        userDetail.removeAll()
        if friend.gender != 0 {
            userDetail.append(genderArr[friend.gender])
        }else{
            userDetail.append("Not selected")
        }
        if friend.marital_status != 0 {
            userDetail.append(relationArr[friend.marital_status])
        }else{
            userDetail.append("Not selected")
        }
        if friend.dob.contains("0000") || friend.dob.contains("<null>") || friend.dob.isEmpty {
            userDetail.append("Not selected")
        }else{
            userDetail.append((friend.dob.getDate_FromString()).getMonthDateFormat())
        }
        if friend.interests.count != 0 {
            userDetail.append(friend.interests.joined(separator: ", "))
        }else{
            userDetail.append("Not selected")
        }
        lblUserShortName.isHidden = false
        lblUserName.text = friend.full_name.capitalized
        tblView.estimatedRowHeight = 100
        tblView.rowHeight = UITableViewAutomaticDimension
        tblView.reloadData()
        
        let h = (screenHeight() * headerRatio )/100
        headerView.frame.size.height = h + 60
        lblUserName.text = friend.full_name
        lblUserShortName.adjustFont(font: UIFont(name: fRobotoBold, size: 28)!)
        lblUserShortName.text = friend.full_name.getTwoString()
        self.lblUserShortName.isHidden = false
        imgUserBanner.backgroundColor = hexStringToUIColor(cBlueTheme).withAlphaComponent(0.6)
        
        let url = URL(string: friend.profile_pic_thumb)
        
        imgUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "blue_theme"), options: [SDWebImageOptions.refreshCached,SDWebImageOptions.highPriority,SDWebImageOptions.retryFailed]) { (image, error, cacheType, url) in
            if error != nil {
                debugPrint("Failed: \(error)")
            } else {
                DispatchQueue.main.async {
                    self.imgUser.image = image!
                    self.lblUserShortName.isHidden = true
                }
                debugPrint("Success")
            }
        }
        imgUserBanner.sd_setImage(with: URL(string: friend.banner_image), placeholderImage: nil, options: [SDWebImageOptions.refreshCached,SDWebImageOptions.highPriority,SDWebImageOptions.retryFailed]) { (image, error, cacheType, url) in
            if error != nil {
                debugPrint("Failed: \(error)")
            } else {
                self.imgUserBanner.image = image!
                debugPrint("Success")
                self.imgUserBanner.backgroundColor = UIColor.white
            }
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PUserProfileVC.showImagePicker(_:)))
        imgUserBanner.isUserInteractionEnabled = true
        imgUserBanner.addGestureRecognizer(tapGesture)
        imgUserBanner.tag = 101
        
        let imgGesture = UITapGestureRecognizer(target: self, action: #selector(PUserProfileVC.showImagePicker(_:)))
        imgUser.isUserInteractionEnabled = true
        imgUser.addGestureRecognizer(imgGesture)
        imgUser.tag = 100
        
        imgStatus.image = kAppDelegate.setUserStatus(status: friend.status)
        let p = PPeople()
        p.is_friend = friend.is_friend
        for f in friend.mutualFriends {
            p.common_friend_name.append(f.full_name)
        }
        lblDegree.text = degreeofUser(p)
        lblDegree.isHidden = false
    }
    //Image viewer library
    func openNYTPicker(){
        let photosViewController = NYTPhotosViewController(photos: self.photos, initialPhoto: self.photos[0], delegate: self)
        photosViewController.delegate = self
        photosViewController.rightBarButtonItem = nil
        
        UIApplication.shared.isStatusBarHidden = true
        photosViewController.view.frame(forAlignmentRect: CGRect(x: 0.0, y: 20.0, width: screenWidth(), height: screenHeight()))
        
        present(photosViewController, animated: true, completion: nil)
        
        updateImagesOnPhotosViewController(photosViewController: photosViewController, afterDelayWithPhotos: photos)
    }
    
    // Show image in gallery view
    func showImagePicker(_ sender: UITapGestureRecognizer) {
        self.imgSender = sender.view as! UIImageView
        self.photos.removeAll()
        let imageInfo = JTSImageInfo()
        if imgSender.tag == 100 {
            if friend.profile_pic == ""  {  return   }
            MBProgressHUD.showAdded(to:self.view, animated: true)
            SDWebImageManager.shared().loadImage(with: URL(string: friend.profile_pic), options: SDWebImageOptions.refreshCached, progress: nil, completed: { (image, data, error, cache, status, url) in
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
                imageInfo.image = image
                if image?.cgImage != nil {
                    let img = PPhoto(image: imageInfo.image, imageData: imageInfo.image.highestQualityJPEGNSData as NSData?, attributedCaptionTitle: NSAttributedString(string: "Profile Photo"))
                    
                    self.photos.append(img)
                    self.openNYTPicker()
                }
            })
        }else {
            if friend.banner_image == ""  {  return   }
            imageInfo.image = imgUserBanner.image
            if imageInfo.image.cgImage != nil {
                let img = PPhoto(image: imageInfo.image, imageData: imageInfo.image.highestQualityJPEGNSData as NSData?, attributedCaptionTitle: NSAttributedString(string: "Cover Photo"))
                self.photos.append(img)
                self.openNYTPicker()
            }else{
                MBProgressHUD.showAdded(to:self.view, animated: true)
                SDWebImageManager.shared().loadImage(with: URL(string: friend.banner_image), options: SDWebImageOptions.refreshCached, progress: nil, completed: { (image, data, error, cache, status, url) in
                    DispatchQueue.main.async {
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                    imageInfo.image = image
                    if image?.cgImage != nil {
                        let img = PPhoto(image: imageInfo.image, imageData: imageInfo.image.highestQualityJPEGNSData as NSData?, attributedCaptionTitle: NSAttributedString(string: "Cover Photo"))
                        self.photos.append(img)
                        self.openNYTPicker()
                    }
                })
            }
            
        }
    }
    
    //====================================================================================================
    //MARK: -  IB Action
    //====================================================================================================
    func openFriendList(_ sender: UIButton) {
        let vc = UserProfileStoryboard.instantiateViewController(withIdentifier: "PFriendListVC") as! PFriendListVC
        vc.friend = self.friend
        vc.friendsList = self.mutualFriends
        _ = self.navController?.pushViewController(vc, animated: true)
    }
    
    //If user is connected then open chat screen only
    @IBAction func chatAction(_ sender: Any) {
        
        if friend.is_friend == Connection.Connect.rawValue {
            if friend.sender_id == kAppDelegate.objUserInfo.id {
                _ = AlertController.showToastAlert("You can message \(friend.full_name.capitalized) once you are friends.", 1,  completion: {
                    
                })
            }else{
                
                //Reject connection request functionality
                kAppDelegate.addFriendRequest(user_id: kAppDelegate.objUserInfo.id, people:  friend.id, status:Connection.Ignore.rawValue)
                { (s,msg) in
                    DispatchQueue.main.async {
                        MBProgressHUD.hide(for: self.view, animated: true)
                        if s {
                            self.friend.is_friend = Connection.Ignore.rawValue
                            //  self.isFromNotifcation = false
                            self.refreshScreen()
                        }
                    }
                }
            }
        }else if friend.is_friend == Connection.Unfriend.rawValue || friend.is_friend == Connection.Cancel.rawValue{
            //Show Alert for unfriend
            _ = AlertController.alert(kOops, message: "You can message \(friend.full_name.capitalized) once you are friends. Send friend request?", buttons: ["Cancel","Add friend"], tapBlock: { (alert, tag) in
                if tag == 1 {
                    self.updateFriend(status: Connection.Connect.rawValue,friendId: self.friend.id)
                }
            })
        }else if friend.is_friend == Connection.Ignore.rawValue {
            //Show Alert for unfriend
            _ = AlertController.showToastAlert("You can message \(friend.full_name.capitalized) once you are friends.", 1, completion: {
                
            })
        }else if friend.is_friend == 1 {
            //Chat user functionality
            let chatVC = LocationChatStoryboard.instantiateViewController(withIdentifier: "PChatVC") as! PChatVC
            chatVC.friend = self.friend
            self.navigationController?.pushViewController(chatVC, animated: false)
            
        }
    }
    //If user is not connected then it should be work only
    @IBAction func tappedConnectUser(_ sender: Any) {
        var status = -1
        //        var friendId = friend.id
        switch friend.is_friend {
        case Connection.Unfriend.rawValue :
            status = Connection.Connect.rawValue
            break
        case  Connection.Accept.rawValue :
            status = Connection.Unfriend.rawValue
            break
        case  Connection.Connect.rawValue :
            if friend.sender_id == kAppDelegate.objUserInfo.id {
                status = Connection.Cancel.rawValue
                //                friendId = friend.sender_id
            }else{
                status = Connection.Accept.rawValue
            }
            break
        case  Connection.Ignore.rawValue :
            if friend.sender_id == kAppDelegate.objUserInfo.id {
                status = Connection.Cancel.rawValue
                //             friendId = friend.sender_id
            }else{
                status = Connection.Accept.rawValue
            }
            break
        case  Connection.Cancel.rawValue :
            status = Connection.Connect.rawValue
            break
        default:
            break
        }
        
        if status == Connection.Unfriend.rawValue{
            //Show Alert for unfriend
            
            _ = AlertController.alert("", message: "Are you sure you want to remove \(friend.full_name.capitalized) as your friend?", buttons: ["Cancel","Confirm"], tapBlock: { (alert, tag) in
                if tag == 1 {
                    self.updateFriend(status: Connection.Unfriend.rawValue,friendId: self.friend.id)
                }
            })
        }else{
            self.updateFriend(status: status,friendId: friend.id)
        }
        
    }
    func updateFriend(status:Int, friendId:String){
        //Accept connection request functionality
        kAppDelegate.addFriendRequest(user_id: kAppDelegate.objUserInfo.id, people:  friendId, status:status)
        { (s,msg) in
            
            if s {
                if status == Connection.Accept.rawValue  {
                    let p = PPeople()
                    p.id = self.friend.id
                    p.is_friend = status
                    p.full_name = self.friend.full_name
                    p.profile_pic_thumb = self.friend.profile_pic_thumb
                    p.profile_pic = self.friend.profile_pic
                    p.banner_image = self.friend.banner_image
                    p.status = self.friend.status
                    kAppDelegate.objUserInfo.friends.append(p)
                }
                if status == Connection.Connect.rawValue {
                    self.friend.sender_id = kAppDelegate.objUserInfo.id
                    
                }
                if self.locationInfo != nil {
                    let i =  self.locationInfo.users.index(where: { (user) -> Bool in
                        if user.id == self.friend.id {
                            return true
                        }
                        return false
                    })
                    if i != nil {
                        self.locationInfo.users[i!].is_friend = self.friend.status.rawValue
                    }
                }
                if self.notification != nil {
                    if status == Connection.Accept.rawValue {
                        self.notification.notification_message = "You accepted \(self.notification.user.full_name.capitalized) friend request."
                    }else if status == Connection.Ignore.rawValue {
                        self.notification.notification_message = "You ignored \(self.notification.user.full_name.capitalized) friend request."
                    }
                    self.notification.notification_send_at = String(Date().timeIntervalSince1970)
                    let i =  kAppDelegate.objUserInfo.notifications.index(where: { (not) -> Bool in
                        if not.notification_id == self.notification.notification_id {
                            return true
                        }
                        return false
                    })
                    if i != nil {
                        kAppDelegate.objUserInfo.notifications[i!] = self.notification
                    }
                }
                self.friend.is_friend = status
                
                if kAppDelegate.branchData != nil && kAppDelegate.branchData.count > 0 {
                    kAppDelegate.branchData = [:]
                }
            }else{
                if msg == "Request cancelled"{
                    self.friend.is_friend = Connection.Cancel.rawValue
                }else if msg == "Friend"{
                    self.friend.is_friend = Connection.Accept.rawValue
                }
            }
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
                self.refreshScreen()
            }
        }
    }
    @IBAction func tappedBack(_ sender: Any) {
        if isFromNotifcation == true {
            self.dismiss(animated: true, completion: nil)
        }else{
            let _ = self.navigationController?.popViewController(animated: true)
        }
        // Register to receive notification
        NotificationCenter.default.removeObserver(self, name: .pNotification, object: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < -100 {
            if isLoading == false {
               isLoading = true
                getFriendInfo() {
                    DispatchQueue.main.async {
                        self.refreshScreen()
                        if kAppDelegate.branchData != nil && kAppDelegate.branchData.count > 0 {
                            self.navigateActions()
                        }
                    }
                    self.isLoading = false
                }
            }
        }
        debugPrint("scrollViewDidScroll")
    }
    func navigateActions(){

        if let nav_to = kAppDelegate.branchData[kNavTo] as? String {
            switch nav_to {
            case NavScreen.ViewProfile.rawValue:
                if let receiverId = kAppDelegate.branchData[pReceiver_id] as? String {
                    if kAppDelegate.objUserInfo.id == receiverId {
                        kAppDelegate.branchData = [:]
                    }
                }
            case NavScreen.Accept.rawValue:
                if let receiverId = kAppDelegate.branchData[pReceiver_id] as? String {
                    if kAppDelegate.objUserInfo.id == receiverId {
                        if friend.is_friend != Connection.Accept.rawValue{
                        self.tappedConnectUser(self)
                        }else{
                            kAppDelegate.branchData = [:]
                        }
                    }
                }
                break
            case NavScreen.AddFriend.rawValue:
            if let receiverId = kAppDelegate.branchData[pReceiver_id] as? String {
                if kAppDelegate.objUserInfo.id == receiverId {
                    if friend.is_friend != Connection.Connect.rawValue{
                        self.tappedConnectUser(self)
                    }else{
                        kAppDelegate.branchData = [:]
                    }
                }
            }
            case NavScreen.VisitBox.rawValue:break
            case NavScreen.Chat.rawValue:
                //Open chat screen
                self.chatAction(self)
                kAppDelegate.branchData = [:]
            case NavScreen.Read.rawValue:
                //Open chat screen
                self.chatAction(self)
                kAppDelegate.branchData = [:]
            case NavScreen.ViewMessage.rawValue:
                //Open chat screen
                self.chatAction(self)
            case NavScreen.ViewReply.rawValue:
                //Open chat screen
                self.chatAction(self)
            default:
                break
            }
        }
    }
}
//====================================================================================================
//MARK: -  Table View DataSource and Delegate Method
//====================================================================================================

extension PUserProfileVC:UITableViewDataSource, UITableViewDelegate  {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cellID = ""
        if indexPath.section == ProfileSection.AboutMe.rawValue {
            cellID = "aboutCell"
            let cell = tblView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! PUserProfileTVCell
            cell.separatorInset = UIEdgeInsets.init(top: cell.frame.height - 1 , left: 13, bottom: 1, right: 13)
            cell.lblUserInfo.text = ""
            cell.lblUserInfo.numberOfLines = 0
            return cell
        }else if indexPath.section == ProfileSection.MutualFriends.rawValue{
            cellID = "PUserProfileTVCell"
            let cell = tblView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! PUserProfileTVCell
            cell.separatorInset = UIEdgeInsets.init(top: cell.frame.height - 1 , left: 13, bottom: 1, right: 13)
            cell.colView.tag = indexPath.row
            cell.colView.delegate = self
            cell.colView.dataSource = self
            cell.colView.reloadData()
            return cell
        }else if indexPath.section == ProfileSection.Profile.rawValue {
            cellID = "profileCell"
            let cell = tblView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! PUserProfileTVCell
            cell.separatorInset = UIEdgeInsets.init(top: cell.frame.height - 1 , left: 13, bottom: 1, right: 13)
            
            cell.lblUserInfo.text = userDetail[indexPath.row]
            
            cell.imgUserProfile.image = UIImage(named:detailImg[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == ProfileSection.AboutMe.rawValue {
            return UIView()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "sectionCell") as! PUserProfileTVCell
        cell.lblUserInfo.text = sections[section]
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if section == ProfileSection.AboutMe.rawValue {
            return 0
        }else if section == ProfileSection.MutualFriends.rawValue {
            if friend.mutualFriends.count == 0 {
                return 0
            }
        }else if section == ProfileSection.Profile.rawValue {
            return 44
        }
        return 44
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == ProfileSection.MutualFriends.rawValue {
            if friend.mutualFriends.count != 0 {
                return 100
            }
            return 0
        } else if indexPath.section == ProfileSection.Profile.rawValue {
            return UITableViewAutomaticDimension
            return 45
        }
        return UITableViewAutomaticDimension
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == ProfileSection.AboutMe.rawValue {
            return 0
        } else if section == ProfileSection.MutualFriends.rawValue {
            return 1
        }else if section == ProfileSection.Profile.rawValue {
            return userDetail.count
        }
        return 1
    }
    
}
//====================================================================================================
//MARK: -  CollectionView DataSource and Delegate Method
//====================================================================================================
extension PUserProfileVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if screenWidth() > 320 {
            if mutualFriends.count > 5 {
                return 5
            }
            return mutualFriends.count
        }else{
            if mutualFriends.count > 4 {
                return 4
            }
            return mutualFriends.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var more = false
        
        if screenWidth() > 320 {
            if mutualFriends.count > 5 && indexPath.item == 4  {
                more = true
            }
        }else{
            if mutualFriends.count > 4 && indexPath.item == 3 {
                more = true
            }
        }
        if more{
            let item = collectionView.dequeueReusableCell(withReuseIdentifier: "PMutualFriendMoreCVCell", for: indexPath) as! PMutualFriendCVCell
            item.btnMore.addTarget(self, action: #selector(PUserProfileVC.openFriendList(_:)), for: .touchUpInside)
            return item
        }else{
            //Set user details here
            let item = collectionView.dequeueReusableCell(withReuseIdentifier: "PMutualFriendCVCell", for: indexPath) as! PMutualFriendCVCell
            let people = mutualFriends[indexPath.row]
            item.lblMutualFriendName.text = people.full_name
            
//            if people.full_name != "" && people.profile_pic == "" {
                //                item.lblShortName.text = people.full_name.getTwoString()
                //                item.lblShortName.adjustFont(font: UIFont(name: fRobotoBold, size: 24)!)
                //                item.lblShortName.isHidden = false
//                item.imgMutualFriend.image = #imageLiteral(resourceName: "avatar")
//            }else {
                //                item.lblShortName.isHidden = true
                let url = URL(string: people.profile_pic_thumb)
                item.imgMutualFriend.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "avatar"), options: [SDWebImageOptions.refreshCached,SDWebImageOptions.highPriority,SDWebImageOptions.retryFailed]) { (image, error, cacheType, url) in
                    if error != nil {
                        
                    } else {
                        item.imgMutualFriend.image = image
                    }
                }
//            }
            return item
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 66, height: 100)
        //        if screenWidth() > 320 {
        //
        //            return CGSize(width: screenWidth()/5, height: 100)
        //        }else{
        //
        //            return CGSize(width: screenWidth()/4, height: 100)
        //        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
 
        let vc = UserProfileStoryboard.instantiateViewController(withIdentifier: "PUserProfileVC") as! PUserProfileVC
        let f = PFriendsInfo()
        f.id = mutualFriends[indexPath.row].id
        f.is_friend = 1
        f.full_name = mutualFriends[indexPath.row].full_name
        f.profile_pic_thumb = mutualFriends[indexPath.row].profile_pic_thumb
        vc.friend = f
        _ = self.navController?.pushViewController(vc, animated: true)
    }
    //====================================================================================================
    //MARK: -  SERVICE CALL
    //====================================================================================================
    
    //    Mutual friend API url :
    //    http://api.gopopbox.com/api/Usersapi/getmutualfriendinfo?user_id=282&friend_id=298
    //    user_id and friend_id : required
    
    
    //Get Friend profile info
    
    func getFriendInfo(completion:(() -> Void)?) {
        if friend.id == "" {
            return
        }
        // Here sender_id is actually friend id
        let paramDict = NSMutableDictionary()
        paramDict[pUser_id]         = kAppDelegate.objUserInfo.id
        paramDict[pFriend_id]       = friend.id
        
        if !isLoading{
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        
        ServiceHelper.callAPIWithoutLoader(paramDict, method: .get, apiName: kApiGetmutualfriendinfo) { (response, error) in
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            debugPrint("getFriendInfo")
            if error  != nil{
                //                _ = AlertController.alert(title: "Error!", message: error.localizedDescription)
            } else {
                if let responseDict = response as? Dictionary<String, AnyObject> {
                    if let successFull = responseDict[pSuccess] as? Bool {
                        if (successFull) {
                            // Success
                            let data = responseDict[pData] as! Dictionary<String, AnyObject>
                            let f = PFriendsInfo().initProfileData(infoDict: data)
                            //                            f.is_friend = self.friend.is_friend
                            self.friend = f
                            completion!()
                        } else {
                            if let responseMessage = responseDict[pResponseMessage] as? String {
                                //                                let _ = AlertController.alert(message: responseMessage)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
}
//====================================================================================================
//MARK: -  NYTPhotosViewControllerDelegate
//====================================================================================================
extension PUserProfileVC: NYTPhotosViewControllerDelegate {
    
    func photosViewController(_ photosViewController: NYTPhotosViewController, maximumZoomScaleFor photo: NYTPhoto) -> CGFloat
    {
        return 1.0
    }
    
    
    func updateImagesOnPhotosViewController(photosViewController: NYTPhotosViewController, afterDelayWithPhotos: [PPhoto]) {
        delay(delay: 1) {
            for photo in self.photos {
                if photo.image == nil {
                    photo.image = UIImage(named: PrimaryImageName)
                    photosViewController.updateImage(for: photo)
                }
            }
        }
    }
    
    func photosViewController(_ photosViewController: NYTPhotosViewController, handleActionButtonTappedFor photo: NYTPhoto) -> Bool {
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            
            guard let photoImage = photo.image else { return false }
            
            return true
        }
        
        return false
    }
    func photosViewController(_ photosViewController: NYTPhotosViewController, captionViewFor photo: NYTPhoto) -> UIView? {
        
        if photo as! PPhoto == photos[CustomEverythingPhotoIndex] {
            let label = UILabel()
            label.text = ""
            label.textColor = UIColor.white
            label.backgroundColor = UIColor.clear
            return label
        }
        return nil
    }
    
    func photosViewController(_ photosViewController: NYTPhotosViewController, didNavigateTo photo: NYTPhoto, at photoIndex: UInt) {
        debugPrint("Did Navigate To Photo: \(photo) identifier: \(photoIndex)")
    }
    
    func photosViewController(_ photosViewController: NYTPhotosViewController, actionCompletedWithActivityType activityType: String?) {
        debugPrint("Action Completed With Activity Type: \(activityType)")
    }
    
    func photosViewControllerDidDismiss(_ photosViewController: NYTPhotosViewController) {
        debugPrint("Did dismiss Photo Viewer: \(photosViewController)")
        UIApplication.shared.isStatusBarHidden = false
    }
    func photosViewController(_ photosViewController: NYTPhotosViewController, titleFor photo: NYTPhoto, at photoIndex: UInt, totalPhotoCount: UInt) -> String? {
        
        if photo as! PPhoto == photos[Int(photoIndex)] {
            
            return photo.attributedCaptionTitle?.string
        }
        return ""
    }
}
