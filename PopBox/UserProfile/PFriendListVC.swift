
import UIKit

class PFriendListVC:UIViewController, UITableViewDataSource, UITableViewDelegate  {
 
        @IBOutlet weak var tblView: UITableView!
        var friend:PFriendsInfo!
        var friendsList = [PPeople]()
        var isLoading = false

        var arrIndexSection : NSArray = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
        let collation = UILocalizedIndexedCollation.current()
        
        var sections: [[AnyObject]] = []
        var objects: [AnyObject] = [] {
            didSet {
                let selector: Selector = #selector(getter: UIApplicationShortcutItem.localizedTitle)
                sections = Array(repeating: arrIndexSection as [AnyObject], count: collation.sectionTitles.count)
                
                let sortedObjects = collation.sortedArray(from: objects, collationStringSelector: selector)
                for object in sortedObjects {
                    let sectionNumber = collation.section(for: object, collationStringSelector: selector)
                    sections[sectionNumber].append(object as AnyObject)
                }
                self.tblView.reloadData()
                
            }
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()

            self.tblView.register(UINib(nibName: "PFindPeopleTVCell", bundle: nil), forCellReuseIdentifier: "PFindPeopleTVCell")
            self.tblView.estimatedRowHeight = 78
            self.tblView.rowHeight = UITableViewAutomaticDimension
            // Do any additional setup after loading the view.
        }
        override func viewWillAppear(_ animated: Bool) {
            if self.tblView != nil {
                self.tblView.reloadData()
            }
//            if friendsList.count == 0  {
//                MBProgressHUD.showAdded(to: self.view, animated: true)
//                getFriendsData(user_id: kAppDelegate.objUserInfo.id)
//            }else{
//                getFriendsData(user_id: kAppDelegate.objUserInfo.id)
//            }
            
        }
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        //====================================================================================================
        //MARK: -  IB ACTION
        //====================================================================================================
 
        @IBAction func btnBackAction(_ sender: Any) {
 
        _ =  self.navigationController?.popViewController(animated: true)
 
        }

        //====================================================================================================
        //MARK: -  Table View DataSource and Delegate Method
        //====================================================================================================
        
        // Side List in tableview
        public func numberOfSections(in tableView: UITableView) -> Int {
            if friendsList.count == 0 {
                return 1
            }
            return 26
        }
        
        public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
            if friendsList.count == 0 {
                return [""]
            }
            else{
                return self.arrIndexSection as? [String] //Side Section title
            }
        }
 
        func sectionIndexTitlesForTableView(tableView: UITableView) -> [String] {
            return collation.sectionIndexTitles
        }
        
        func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
            if friendsList.count == 0 {
                return 0
            }
            return collation.section(forSectionIndexTitle: index)
        }
 
        
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let v = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth(), height: 40))
            v.backgroundColor = UIColor.white
            let lbl = UILabel(frame: CGRect(x: 14, y: 0, width: screenWidth()-14, height: 40))
            lbl.font = UIFont(name: fRobotoItalic, size: 14.0)
            lbl.textColor = hexStringToUIColor("999999")
            
            if friendsList.count == 0{
                lbl.text = " No friends"
                lbl.textAlignment = .left
                if section == 1 {
 
                }
            }
            v.addSubview(lbl)
            return v
        }
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            if friendsList.count == 0 {
                return 40
            }
            return 0.01
        }
        //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //        return 76.5
        //    }
        public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        {
            if friendsList.count == 0 {
                return 0
            }
            
            let temp =  friendsList.filter({ (people) -> Bool in
                debugPrint(String(describing: people.full_name.first!))
                debugPrint(arrIndexSection.object(at: section) as! String)
                if String(describing: people.full_name.first!).uppercased() == arrIndexSection.object(at: section) as! String {
                    return true
                }
                return false
            })
            debugPrint(temp.count)
            
            return temp.count
            
        }
        public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
        {
 
                let cell  = tableView.dequeueReusableCell(withIdentifier: "PFindPeopleTVCell") as! PFindPeopleTVCell
                cell.contentView.backgroundColor = UIColor.white
                cell.lblName.isHidden = false
                cell.btnAddContact.isHidden = false
                cell.imgProfile.isHidden = false
                cell.imgStatus.isHidden = false
                cell.lblStatus.isHidden = false
                cell.lblUserShortName.isHidden = false
                cell.btnAddContact.setImage(#imageLiteral(resourceName: "user_tick_Big_iPhone"), for: .normal)
                cell.lblUserShortName.adjustFont(font: UIFont(name: fRobotoBold, size: 22.2)!)

                let temp =  friendsList.filter({ (people) -> Bool in
                    if String(describing: people.full_name.first!).capitalized == arrIndexSection.object(at: indexPath.section) as! String {
                        return true
                    }
                    return false
                })
                
                let objModel = temp[indexPath.row]
                cell.people = objModel
                cell.lblName.text = objModel.full_name
                cell.imgProfile.image = #imageLiteral(resourceName: "avatar")
                cell.imgProfile.maskImage = #imageLiteral(resourceName: "mask_blackwstroke")
                cell.lblUserShortName.text = objModel.full_name.getTwoString()
                cell.lblUserShortName.isHidden = false
                cell.lblStatus.text = ""
                if objModel.common_friend_name.count == 1 {
                    cell.lblStatus.text = String(objModel.common_friend_name.count) + " Mutual friend"
                }else if objModel.common_friend_name.count > 1 {
                    cell.lblStatus.text = String(objModel.common_friend_name.count) + " mutual friends"
                }else{
                    cell.lblStatus.text = "No mutual friends"
                }
                setUserStatus(cell: cell, status: objModel.status)
                let url = URL(string: objModel.profile_pic_thumb)
                cell.imgProfile.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "blue_theme"), options: [SDWebImageOptions.refreshCached,SDWebImageOptions.highPriority,SDWebImageOptions.retryFailed]) { (image, error, cacheType, url) in
                    if error != nil {
                        
                        cell.imgProfile.image = #imageLiteral(resourceName: "blue_theme")
                        cell.lblUserShortName.isHidden = false
                    } else {
                        cell.lblUserShortName.isHidden = true
                        cell.imgProfile.maskImage = #imageLiteral(resourceName: "mask_blackwstroke")
                        cell.imgProfile.image = image!
                    }
                }
                return cell
 
        }
        
        func configureCellData(cell:PFindPeopleTVCell, indexPath:IndexPath){
            // Configure the cell...
            let contact = friendsList[indexPath.row]
            cell.people = contact
            cell.btnAddContact.setImage(#imageLiteral(resourceName: "add_people"), for: .normal)
            cell.imgProfile.isHidden = false
            cell.imgStatus.isHidden = false
            cell.lblName.isHidden = false
            cell.btnAddContact.isHidden = false
            cell.lblStatus.isHidden = false
            cell.lblUserShortName.isHidden = false
            cell.lblUserShortName.adjustFont(font: UIFont(name: fRobotoBold, size: 22.2)!)
            cell.imgProfile.maskImage = #imageLiteral(resourceName: "mask_blackwstroke")
            
            cell.lblName.attributedText = nil
            cell.lblName.text = contact.full_name
            if contact.full_name != ""{
                cell.lblUserShortName.text = contact.full_name.getTwoString()
            }else{
                cell.lblUserShortName.text = ""
                if contact.phone_no != ""{
                    // cell.lblName.text = contact.phone_no
                }else{
                    //   cell.lblName.text = contact.email
                }
            }
            cell.lblStatus.text = contact.phone_code + contact.phone_no
            cell.lblUserShortName.isHidden = false
            setUserStatus(cell: cell, status: contact.status)
            if indexPath.section == 1 {
                if (contact.common_friend_name).count == 0 {
                    cell.lblStatus.text = "In your Contacts"
                }else if (contact.common_friend_name).count == 1 {
                    cell.lblStatus.text = (contact.common_friend_name)[0] + " in common"
                }else{
                    cell.lblStatus.text = String((contact.common_friend_name).count) + " common friends"
                }
            }else{
                cell.imgStatus.isHidden = true
            }
            let url = URL(string: contact.profile_pic)
            
            cell.imgProfile.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "blue_theme"), options: [SDWebImageOptions.continueInBackground, SDWebImageOptions.lowPriority, SDWebImageOptions.refreshCached, SDWebImageOptions.handleCookies, SDWebImageOptions.retryFailed]) { (image, error, cacheType, url) in
                if error != nil {
                    cell.imgProfile.image = #imageLiteral(resourceName: "blue_theme")
                    cell.lblUserShortName.isHidden = false
                } else {
                    cell.lblUserShortName.isHidden = true
                    cell.imgProfile.image = image
                    cell.imgProfile.maskImage = #imageLiteral(resourceName: "mask_blackwstroke")
                }
            }
        }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            let cell = tableView.cellForRow(at: indexPath) as! PFindPeopleTVCell
            let vc = UserProfileStoryboard.instantiateViewController(withIdentifier: "PUserProfileVC") as! PUserProfileVC
            let f = PFriendsInfo()
            f.id = cell.people.id
            f.full_name = cell.people.full_name
            f.profile_pic_thumb = cell.people.profile_pic_thumb
            f.profile_pic = cell.people.profile_pic
            f.status = cell.people.status
            vc.friend = f
            _ = self.navigationController?.pushViewController(vc, animated: true)
        }
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            if scrollView.contentOffset.y < -100 {
                if isLoading == false {
                    isLoading = true
//                    getFriendsData(user_id: kAppDelegate.objUserInfo.id)
                }
            }
            debugPrint("scrollViewDidScroll")
        }
        //====================================================================================================
        //MARK: -  METHODS
        //====================================================================================================

        func setUserStatus(cell:PFindPeopleTVCell, status:UserStatus){
            cell.imgStatus.image = kAppDelegate.setUserStatus(status: status)
        }

        //====================================================================================================
        //MARK: -  SERVICE CALL
        //====================================================================================================
        //Get Friends List
        func getFriendsData(user_id : String) {
            
            let paramDict = NSMutableDictionary()
            paramDict[pUser_id]        = user_id
            ServiceHelper.callAPIWithoutLoader(paramDict, method: .get, apiName: kApiGetfriends) { (response, error) in
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.isLoading = false
                }
                if error  != nil{
                    //                _ = AlertController.alert(title: "Error!", message: error.localizedDescription)
                } else {
                    if let responseDict = response as? Dictionary<String, AnyObject> {
                        
                        if let successFull = responseDict[pSuccess] as? Bool {
                            if (successFull) {
                                // Success 
                                self.friendsList.removeAll()
                                let data = responseDict[pData] as! NSArray
                                for p in data {
                                    kAppDelegate.objUserInfo.friends.append(PPeople().initPeopleData(infoDict: p as! Dictionary<String, AnyObject>))
                                    self.friendsList.append(PPeople().initPeopleData(infoDict: p as! Dictionary<String, AnyObject>))
                                }
 
                                DispatchQueue.main.async {
                                    self.tblView.reloadData()
                                }
                            } else {
                                if let responseMessage = responseDict[pResponseMessage] as? String {
                                    if responseMessage == kNoContent{
                                        self.friendsList.removeAll()
                                        DispatchQueue.main.async {
                                            self.tblView.reloadData()
                                        }
                                    }else{
                                        //                                    let _ = AlertController.alert(message: responseMessage)
                                    }
                                }
                            }
                            
                        }
                    }
                }
            }
        }
        
}

