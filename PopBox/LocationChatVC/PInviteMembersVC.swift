//
//  PInviteMembersVC.swift
//  Popbox
//
//  Created by Ongraph on 2/22/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit

class PInviteMembersVC: UIViewController {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var btnInvite: UIButton!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var tblBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var headerView: UIView!
    var isLoading = false
    var locationProfileVC:PLocationProfileVC!
    var members = [PPeople]()
    var search_result = [PPeople]()
    var sel_Members = [PPeople]()
    var searchedText = ""
    var keyboardHeight:CGFloat! = 216.0
    var parentNavigationController : UINavigationController?
    var arrIndexSection : NSArray = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    let collation = UILocalizedIndexedCollation.current()
    
    var sections: [[AnyObject]] = []
    var objects: [AnyObject] = [] {
        didSet {
            let selector: Selector = "localizedTitle"
            sections = Array(repeating: arrIndexSection as [AnyObject], count: collation.sectionTitles.count)
            
            let sortedObjects = collation.sortedArray(from: objects, collationStringSelector: selector)
            for object in sortedObjects {
                let sectionNumber = collation.section(for: object, collationStringSelector: selector)
                sections[sectionNumber].append(object as AnyObject)
            }
            self.tblView.reloadData()
        }
    }
    
    var locationInfo:PLocationInfo!
    var header = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.errorView.isHidden = true
        self.headerView.isHidden = true
        self.btnSearch.isHidden = true
        header = "Select your friends who you would like to invite to the \(self.locationInfo.name) box."
        
        let w = header.widthOfString(usingFont: UIFont(name:fRobotoItalic,size:14)!)
        let h = header.heightOfString(usingFont: UIFont(name:fRobotoItalic,size:14)!)
        let lblSize = screenWidth()-28
        let height = ((Double(w/lblSize).rounded(.up))*Double(h))+50
//        headerView.frame = CGRect(x: 0, y: 0, width: screenW(), height: height)
        headerHeightConstraint.constant = CGFloat(height)
        headerView.backgroundColor = UIColor.white
        tblView.backgroundColor = UIColor.white
        let center: NotificationCenter = NotificationCenter.default
        center.addObserver(self, selector: #selector(PInviteMembersVC.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        center.addObserver(self, selector: #selector(PInviteMembersVC.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        center.addObserver(self, selector: #selector(PInviteMembersVC.keyboardDidChangeFrame(_:)), name: NSNotification.Name.UIKeyboardDidChangeFrame, object: nil)
        
        self.tblView.register(UINib(nibName: "PFindPeopleTVCell", bundle: nil), forCellReuseIdentifier: "PFindPeopleTVCell")
        
        self.tblView.estimatedRowHeight = 78
        self.tblView.rowHeight = UITableViewAutomaticDimension
        // Do any additional setup after loading the view.
//        btnInvite.isHidden = true
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        if kAppDelegate.objUserInfo.friends.count == 0 {
            kAppDelegate.getFriendsData(user_id: kAppDelegate.objUserInfo.id, completionBlock: { (success) in
                if success {
                   self.members.removeAll()
                   self.members.append(contentsOf: kAppDelegate.objUserInfo.friends)
                    for m in self.members {
                        m.invite_sent = false
                    }
                    DispatchQueue.main.async {
                        self.hideShowHeader()
                    }
                    
                    self.getInvitedMembers(place_id: self.locationInfo.place_id)
                }else{
                    DispatchQueue.main.async {
                        self.hideShowHeader()
                    }
                    if kAppDelegate.isReachable == false {
                        _ = AlertController.showToastAlert(kNoInternet, 0.5, completion: {
                        })
                    }
                }
            })
            
        }else{
            self.members.removeAll()
            self.members.append(contentsOf: kAppDelegate.objUserInfo.friends)
            for m in members {
                m.invite_sent = false
            }
            self.hideShowHeader()
            getInvitedMembers(place_id: self.locationInfo.place_id)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //====================================================================================================
    //MARK: -  IB Action
    //====================================================================================================
    @IBAction func btnSearchAction(_ sender: Any) {
        searchBar.isHidden = false
//        btnSearch.isHidden = true
        searchBar.becomeFirstResponder()
    }
    @IBAction func btnBackAction(_ sender: Any) {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnInviteAction(_ sender: Any) {
         sendInvites()
    }
    @IBAction func findPeopleAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "People", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "PPeopleVC") as! PPeopleVC
        self.navigationController?.pushViewController(viewController
            , animated: true)
    }
    
    func addFriendAction(_ sender:UIButton){
        
        let cell = sender.superview?.superview as! PFindPeopleTVCell
        if cell.people.invite_sent == true {
            return
        }
        if sel_Members.contains(cell.people){
            if let i = sel_Members.index(of: cell.people) {
                sel_Members.remove(at: i)
                cell.btnAddContact.setImage(#imageLiteral(resourceName: "checkbox_iPhone"), for: .normal)
            }
        }else{
            sel_Members.append(cell.people)
            cell.btnAddContact.setImage(#imageLiteral(resourceName: "checkbox_selected_iPhone"), for: .normal)
        }
        if sel_Members.count != 0 {
//            btnInvite.isHidden = false
            btnInvite.backgroundColor = hexStringToUIColor(cBlueTheme)
            btnInvite.isUserInteractionEnabled = true
        }else{
            btnInvite.backgroundColor = hexStringToUIColor(cDarkGrey)
            btnInvite.isUserInteractionEnabled = false
//           btnInvite.isHidden = true
        }
//        let indexPath = tblView.indexPath(for: cell)
    }
    //====================================================================================================
    //MARK: -  METHODS
    //====================================================================================================
    
    func hideShowHeader(){

        if self.members.count != 0 {
            self.errorView.isHidden = true
//            self.btnInvite.isHidden = true
            self.lblHeader.text = self.header
            self.lblHeader.textColor = hexStringToUIColor(cDarkGrey)
            self.lblHeader.font = UIFont(name:fRoboto,size:14)!
            self.headerView.isHidden = false
            self.btnSearch.isHidden = false
        }else{
            self.errorView.isHidden = false
            self.btnSearch.isHidden = true
        }
        
        if sel_Members.count != 0 {
//            btnInvite.isHidden = false
            btnInvite.backgroundColor = hexStringToUIColor(cBlueTheme)
            btnInvite.isUserInteractionEnabled = true
        }else{
            btnInvite.backgroundColor = hexStringToUIColor(cDarkGrey)
            btnInvite.isUserInteractionEnabled = false
//            btnInvite.isHidden = true
        }
    }
    
    func setUserStatus(cell:PFindPeopleTVCell, status:UserStatus){
        cell.imgStatus.image = kAppDelegate.setUserStatus(status: status)
    }
    
    func keyboardWillShow(_ notification: Notification) {
        
        if (notification as NSNotification).userInfo != nil {
            
            let info:NSDictionary = (notification as NSNotification).userInfo! as NSDictionary
            
            let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
            
            let keyboardHeight:CGFloat = keyboardSize.height
            self.keyboardHeight = keyboardHeight
            self.tblBottomConstraint.constant = keyboardHeight
            self.view.layoutIfNeeded()
            
        }
        
    }
    
    func keyboardWillHide(_ notification: Notification) {
        
        if (notification as NSNotification).userInfo != nil {
            
            let info:NSDictionary = (notification as NSNotification).userInfo! as NSDictionary
            
            let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
            
            let keyboardHeight:CGFloat = keyboardSize.height
            
            self.keyboardHeight = keyboardHeight
            
            self.tblBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
            
        }
        
    }
    
    func keyboardDidChangeFrame(_ notification: Notification) {
        
        if (notification as NSNotification).userInfo != nil {
            let info:NSDictionary = (notification as NSNotification).userInfo! as NSDictionary
            let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            let keyboardHeight:CGFloat = keyboardSize.height
            
            self.tblBottomConstraint.constant = keyboardHeight
            
            self.view.layoutIfNeeded()
        }
    }
    //====================================================================================================
    //MARK: -  SERVICE HELPER
    //====================================================================================================
 
    //Get Invited List
    func getInvitedMembers(place_id : String) {
        
        let paramDict = NSMutableDictionary()
            paramDict[pSender_id]       = kAppDelegate.objUserInfo.id
            paramDict[pPlace_id]        = place_id
        
        ServiceHelper.callAPIWithParameters(paramDict, method: .get, apiName: kApiGet_invite_details) { (response, error) in
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            if let _ = error {
                self.isLoading = false
                self.members.removeAll()
                DispatchQueue.main.async {
                    self.tblView.reloadData()
                }
                //                _ = AlertController.alert(title: "Error!", message: error.localizedDescription)
            } else {
                if let responseDict = response as? Dictionary<String, AnyObject> {
                    
                    if let successFull = responseDict[pSuccess] as? Bool {
                        if (successFull) {
                            // Success
                            //Update members Array Record
                            
                            if  let data = responseDict[pData] as? NSArray {
                            for p in data {
                               let m = p as! Dictionary<String, AnyObject>
                                if let id = m[pReceiver_id] as? String {
                                if  let index = self.members.index(where: { (people) -> Bool in
                                        if people.id == id {
                                            return true
                                        }
                                        return false
                                }) {
                                    self.members[index].invite_sent = true
                                    }
                                }
                            }
                            }
                            DispatchQueue.main.async {
                                self.hideShowHeader()
                                self.tblView.reloadData()
                            }
                            
                        } else {
                            
                            if let responseMessage = responseDict[pResponseMessage] as? String {
                                if responseMessage == kNoContent{
                                    
                                }else{
                                self.btnSearch.isHidden = true
                                self.errorView.isHidden = false
                                self.headerView.isHidden = true
                                self.members.removeAll()
                                
                                self.isLoading = false
                                _ = AlertController.showToastAlert(kNoInternet, 0.5, completion: {
                                        
                                    })
                                }
                                DispatchQueue.main.async {
                                    self.tblView.reloadData()
                                    
                                }
                            }
                        }
                        
                    }
                }
            }
        }
    }
    //Send Invitation
    func sendInvites() {
        if sel_Members.count == 0 {
            return
        }
        var mem = [String]()
        for id in sel_Members {
            mem.append(id.id)
        }
        let paramDict = NSMutableDictionary()
        paramDict[pSender_id]       = kAppDelegate.objUserInfo.id
        paramDict[pReceiver_id]     = mem.joined(separator: ",")
        paramDict[pPlace_id]        = locationInfo.place_id
        
        ServiceHelper.callAPIWithoutLoader(paramDict, method: .post, apiName: kApiInvite_friend) { (response, error) in
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            if let _ = error {
                //                _ = AlertController.alert(title: "Error!", message: error.localizedDescription)
            } else {
                if let responseDict = response as? Dictionary<String, AnyObject> {
                    
                    if let successFull = responseDict[pSuccess] as? Bool {
                        if (successFull) {
                            // Success
                            self.navigationController?.popViewController(animated: true)
                            var msg = ""
                            if self.sel_Members.count == 1 {
                               msg = "Invite sent."
                            }else{
                                msg = "Invites sent."
                            }
                            
                            _ = AlertController.showToastAlert(msg, 0.5, completion: {
                                
                            })
 
                        } else {
                            if let responseMessage = responseDict[pResponseMessage] as? String {
                                if responseMessage == kNoContent{
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
//====================================================================================================
//MARK: -  Table View DataSource and Delegate Method
//====================================================================================================
extension PInviteMembersVC: UITableViewDataSource, UITableViewDelegate  {
 
    public func numberOfSections(in tableView: UITableView) -> Int {
        
        if members.count == 0 {
            return 0
        }
        return 1
    }
    /*
    public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if members.count == 0 {
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
        if members.count == 0 {
            return 0
        }
        return collation.section(forSectionIndexTitle: index)
    }
    */
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth(), height: 40))
        v.backgroundColor = UIColor.white
        let lbl = UILabel(frame: CGRect(x: 14, y: 0, width: screenWidth()-14, height: 40))
        lbl.font = UIFont(name: fRobotoItalic, size: 14.0)
        lbl.textColor = hexStringToUIColor("999999")
         if self.searchedText != "" && self.search_result.count == 0{
            lbl.text = " No results found."
            lbl.textAlignment = .left
        }
        v.addSubview(lbl)
        return v
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.searchedText == ""{
           return 0.01
        }else{
            if self.search_result.count == 0 {
            return 40
            }
        }
        return 0.01
    }
 
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self.searchedText == ""{
         return members.count
        }else{
            return self.search_result.count
        }
//        let temp =  members.filter({ (people) -> Bool in
//            debugPrint(String(describing: people.full_name.first!))
//            debugPrint(arrIndexSection.object(at: section) as! String)
//            if String(describing: people.full_name.first!).uppercased() == arrIndexSection.object(at: section) as! String {
//                return true
//            }
//            return false
//        })
  
        return members.count
        
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
         if members.count > 0{
            let cell  = tableView.dequeueReusableCell(withIdentifier: "PFindPeopleTVCell") as! PFindPeopleTVCell
            cell.contentView.backgroundColor = UIColor.white
            cell.lblName.isHidden = false
            cell.btnAddContact.isHidden = false
            cell.imgProfile.isHidden = false
            cell.imgStatus.isHidden = false
            cell.lblStatus.isHidden = false
            cell.lblUserShortName.isHidden = false
            cell.lblUserShortName.adjustFont(font: UIFont(name: fRobotoBold, size: 22.2)!)
 
//            let temp =  members.filter({ (people) -> Bool in
//                if String(describing: people.full_name.first!).capitalized == arrIndexSection.object(at: indexPath.section) as! String {
//                    return true
//                }
//                return false
//            })
            
            var objModel:PPeople
            if self.searchedText == ""{
                objModel = members[indexPath.row]
            }else{
               objModel  = search_result[indexPath.row]
            }
            cell.people = objModel
 
            if self.searchedText != "" {
                let font = UIFont.boldSystemFont(ofSize: cell.lblName.font.pointSize)
                cell.lblName.attributedText = AppUtility.generateAttributedString(with: searchedText, targetString: objModel.full_name,font: font)
            }else{
                cell.lblName.text = objModel.full_name
            }
            cell.imgProfile.image = #imageLiteral(resourceName: "avatar")
            if sel_Members.contains(cell.people){
                cell.btnAddContact.setImage(#imageLiteral(resourceName: "checkbox_selected_iPhone"), for: .normal)
            }else{
                cell.btnAddContact.setImage(#imageLiteral(resourceName: "checkbox_iPhone"), for: .normal)
            }
            cell.lblStatus.text = ""
            if objModel.invite_sent == false {
                cell.btnAddContact.isHidden = false
            }else {
                 cell.lblStatus.text = "Invite sent"
                cell.btnAddContact.isHidden = true
            }
            if locationInfo.users.contains(where: { (p) -> Bool in
                if p.id == objModel.id {
                    return true
                }
                return false
            }) {
                cell.lblStatus.text = "Already a member"
            }
 
            cell.btnAddContact.tag = indexPath.row
            cell.btnAddContact.addTarget(self, action: #selector(PInviteMembersVC.addFriendAction(_:)), for: .touchUpInside)
            cell.imgProfile.maskImage = #imageLiteral(resourceName: "mask_blackwstroke")
            cell.lblUserShortName.text = objModel.full_name.getTwoString()
            cell.lblUserShortName.isHidden = false
            
            if objModel.common_friend_name.count == 1 {
                cell.lblStatus.text = String(objModel.common_friend_name.count) + " Mutual friend"
            }else if objModel.common_friend_name.count > 1 {
                cell.lblStatus.text = String(objModel.common_friend_name.count) + " mutual friends"
            }else{
                cell.lblStatus.text = "No mutual friends"
            }
            cell.lblStatus.text = ""
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
            cell.contentView.backgroundColor = UIColor.white
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! PFindPeopleTVCell
        addFriendAction(cell.btnAddContact)
//        let vc = UserProfileStoryboard.instantiateViewController(withIdentifier: "PUserProfileVC") as! PUserProfileVC
//        let f = PFriendsInfo()
//        f.id = cell.people.id
//        f.full_name = cell.people.full_name
//        f.profile_pic_thumb = cell.people.profile_pic_thumb
//        f.profile_pic = cell.people.profile_pic
//        f.status = cell.people.status
//        vc.friend = f
//        _ = self.navigationController?.pushViewController(vc, animated: true)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < -100 {
            if isLoading == false {
                isLoading = true
                viewWillAppear(true)
            }
        }
        debugPrint("scrollViewDidScroll")
    }
}
extension PInviteMembersVC:UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        filterResult(text: searchBar.text!)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.isHidden = true
//        btnSearch.isHidden = false
        self.searchedText = ""
        self.search_result.removeAll()
        self.tblView.reloadData()
        searchBar.resignFirstResponder()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            self.searchedText = ""
            self.search_result.removeAll()
            self.tblView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //        guard let searchText = searchBar.text else { break }
        let searchText = searchBar.text!
        let newLength = searchText.count + text.count - range.length
        
        let  char = text.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        var temp = ""
        if (isBackSpace == -92) {
            debugPrint("Backspace was pressed")
            //            temp = textView.text!
            if (searchText == "") {
                
            }else{
                temp = searchText.dropLast()
            }
            if newLength == 0 {
                self.searchedText = ""
                self.search_result.removeAll()
                self.tblView.reloadData()
                return true
            }
        }else{
            temp = searchText + text
        }
        self.searchedText = temp
        
        filterResult(text: temp )
        return true
    }
    func filterResult(text:String){
 
            if self.members.count > 0 {
                self.search_result =   self.members.filter{
 
                    if $0.full_name.lowercased().range(of: text.lowercased()) != nil {
                        return true
                    }else{
                        return false
                    }
                }
            }
        self.tblView.reloadData()
    }
}
