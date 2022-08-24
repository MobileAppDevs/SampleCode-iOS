//
//  PLocationProfileVC.swift
//  Popbox
//
//  Created by Chandan Kumar on 12/27/17.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit
import NYTPhotoViewer

protocol LocationProfileDelegate {
    func refreshData(info:PLocationInfo)
}
class PLocationProfileVC: UIViewController, UITableViewDataSource,UITableViewDelegate, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {    
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnInfo: UIButton!
    @IBOutlet weak var btnFav: UIButton!
    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet weak var imgLocationBanner: UIImageView!
    var mediaList = [String]()
    var peopleList = [PPeople]()
    var photos = PhotosProvider().photos
    var locationDelegate:LocationProfileDelegate!
    var locationInfo:PLocationInfo!
    var isContent = false
    var isLoading = false
    var navController: UINavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        mediaList = ["","","","","","","","","",""]
        refreshDetails()
        tblView.estimatedRowHeight = 75
        tblView.rowHeight = UITableViewAutomaticDimension
        tblView.delegate=self
        tblView.dataSource=self
    }
    override func viewWillAppear(_ animated: Bool) {

        getLocationDetails(placeId: locationInfo.place_id) {
            
        }
        tblView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //====================================================================================================
    //MARK: -  Table View DataSource and Delegate Method
    //====================================================================================================
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cellID = ""
        if indexPath.section == 0 {
            cellID = "PLocationMediaTVCell"
            let cell = tblView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! PLocationMediaTVCell
            cell.colView.delegate = self
            cell.colView.dataSource = self
            
            return cell
        }else {
            cellID = "PLocationPeopleTVCell"
            let cell = tblView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! PLocationPeopleTVCell
            if indexPath.row > self.peopleList.count-1 {
                return UITableViewCell()
            }
            cell.lblStatus.isHidden = true
            let people = self.peopleList[indexPath.row]
            if people.common_friend_name.count > 1 {
                cell.lblStatus.isHidden = false
                cell.lblStatus.text = String(people.common_friend_name.count) + " mutual friends"
            }else if people.common_friend_name.count == 1 {
                cell.lblStatus.isHidden = false
                cell.lblStatus.text = String(people.common_friend_name.count) + " mutual friend"
            }else {
                cell.lblStatus.isHidden = false
                cell.lblStatus.text = "No mutual friends"
            }
            
            if people.id == kAppDelegate.objUserInfo.id {
                //Self user updated image thumb
                people.profile_pic_thumb = kAppDelegate.objUserInfo.profileThumb
                people.status = kAppDelegate.objUserInfo.status
                cell.lblStatus.isHidden = true
                cell.lblStatus.text = ""
                cell.lblUserShortName.text = kAppDelegate.objUserInfo.fullName.getTwoString()
                cell.lblName.text = "You"
                cell.lblDegree.text = ""
                cell.lblDegree.isHidden = true
            }else{
                cell.lblDegree.isHidden = false
                cell.lblDegree.text = degreeofUser(people)
                cell.lblName.text = people.full_name.capitalized
                cell.lblUserShortName.text = people.full_name.getTwoString()
            }
            cell.separatorInset = UIEdgeInsets.init(top: cell.frame.height - 1 , left: 13, bottom: 1, right: 13)
            cell.lblUserShortName.adjustFont(font: UIFont(name: fRobotoBold, size: 22.2)!)
            cell.imgProfile.image = #imageLiteral(resourceName: "blue_theme")
            cell.lblUserShortName.isHidden = false
            cell.lblBumps.isHidden = true
             
            
            let url = URL(string: people.profile_pic_thumb)
            cell.imgProfile.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "blue_theme"), options: [SDWebImageOptions.refreshCached,SDWebImageOptions.highPriority,SDWebImageOptions.retryFailed]) { (image, error, cacheType, url) in
                if error != nil {
                    
                } else {
                    cell.lblUserShortName.isHidden = true
                    cell.imgProfile.image = image!
                }
            }
            
            if people.is_friend == Connection.Accept.rawValue {
                cell.btnFriend.isHidden = false
            }else{
                cell.btnFriend.isHidden = true
            }

            cell.imgStatus.image = kAppDelegate.setUserStatus(status: people.status)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PLocationPeopleHeaderTVCell") as! PLocationPeopleHeaderTVCell
        if section == 0 {
            cell.lblTitle.text = "Media"
            cell.lblTitle.textColor = hexStringToUIColor(cDarkGrey)
            cell.lblCount.isHidden = false
            cell.btnCount.addTarget(self, action: #selector(PLocationProfileVC.moreMediaAction(_:)), for: .touchUpInside)
        }else{
            cell.lblTitle.textColor = hexStringToUIColor("646464")
            if self.locationInfo.users.count > 1 {
                if peopleList.count == 1 {
                    cell.lblTitle.text = String(self.locationInfo.users.count) + " member. " + String(peopleList.count) + " is visible."
                }else{
                cell.lblTitle.text = String(self.locationInfo.users.count) + " members. " + String(peopleList.count) + " are visible."
                }
            }else{
                if self.locationInfo.users.count == 0 {
                     cell.lblTitle.text = String(peopleList.count) + " member."
                }else {
                    if peopleList.count == 1 {
                         cell.lblTitle.text = String(self.locationInfo.users.count) + " member. " + String(peopleList.count) + " is visible."
                    }else{
                        cell.lblTitle.text = String(self.locationInfo.users.count) + " member. " + String(peopleList.count) + " are visible."
                    }
                }
             }
            cell.lblCount.isHidden = true
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 44
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else {
            return self.peopleList.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 0){
            if mediaList.count < 6 {
                return 110
            }else {
                return 175
            }
        }else{
            return 75
//            return UITableViewAutomaticDimension
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = UserProfileStoryboard.instantiateViewController(withIdentifier: "PFriendListVC") as! PFriendListVC
//        let f = PFriendsInfo()
//        f.id = peopleList[indexPath.row].id
//        vc.friend = f
//        _ = self.navigationController?.pushViewController(vc, animated: true)
        
//        return
        if indexPath.section == 1 {
            let f = PFriendsInfo()
            //Here sender id is actuall user id
            f.id = peopleList[indexPath.row].id
            f.is_friend = peopleList[indexPath.row].is_friend
            f.full_name = peopleList[indexPath.row].full_name
            f.profile_pic_thumb = peopleList[indexPath.row].profile_pic_thumb
            if f.id != kAppDelegate.objUserInfo.id {
        let vc = UserProfileStoryboard.instantiateViewController(withIdentifier: "PUserProfileVC") as! PUserProfileVC
        vc.friend = f
        vc.locationInfo = locationInfo
       _ = self.navigationController?.pushViewController(vc, animated: true)
            }else{
                let vc = ProfileStoryboard.instantiateViewController(withIdentifier: "PMyProfileVC") as! PMyProfileVC
                 _ = self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    //====================================================================================================
    //MARK: -  Collection View DataSource and Delegate Method
    //====================================================================================================
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if mediaList.count > 9 {
            if screenW() > 320.0 {
                return 10
            }
            return 8
        }
        return mediaList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: 65, height: 75)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var more = false
        
        if screenW() > 320.0 {
            if indexPath.row > 8 {
                more = true
            }
        }else{
            if indexPath.row > 6 {
                more = true
            }
        }
        
        if more {
            let item = collectionView.dequeueReusableCell(withReuseIdentifier: "PLocationMoreCVCell", for: indexPath) as! PLocationMoreCVCell
            item.btnMore.addTarget(self, action: #selector(PLocationProfileVC.moreMediaAction(_:)), for: .touchUpInside)
            return item
        }else{
            
            let item = collectionView.dequeueReusableCell(withReuseIdentifier: "PLocationPlaceCVCell", for: indexPath) as! PLocationPlaceCVCell
            return item
        }
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < -100 {
            if isLoading == false {
                isLoading = true
                getLocationDetails(placeId: locationInfo.place_id) {
                    self.isLoading = false
                }
            }
        }
        debugPrint("scrollViewDidScroll")
    }
    
    //====================================================================================================
    //MARK: -  IB ACTION
    //====================================================================================================
    
    @IBAction func infoAction(_ sender: Any) {
    }
    
    @IBAction func tappedBack(_ sender: Any) {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    func moreMediaAction(_ sender: UIButton) {
       let vc = LocationChatStoryboard.instantiateViewController(withIdentifier: "PMediaVC") as! PMediaVC
 
        self.navController.pushViewController(vc, animated: false)
    }
    @IBAction func favouriteAction(_ sender: Any) {
        var is_fav = 1
        if  self.locationInfo.isFav == 1 {
            is_fav = 0
            self.btnFav.setImage(#imageLiteral(resourceName: "star_white_iPhone"), for: .normal)
        }else{
            self.btnFav.setImage(#imageLiteral(resourceName: "star_iPhone"), for: .normal)
        }
        self.locationInfo.isFav = is_fav
 
        kAppDelegate.addFavouriteRequest(user_id: kAppDelegate.objUserInfo.id, place_id: self.locationInfo.place_id, is_fav: is_fav) { (status,isFav) in
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            if status {
                
                if isFav == 0{
                    let i = kAppDelegate.objUserInfo.favourites.index(where: { (favItem) -> Bool in
                        if favItem.place_id == self.locationInfo.place_id {
                            return true
                        }
                        return false
                    })
                    if i  != nil {
                        kAppDelegate.objUserInfo.favourites.remove(at: i!)
                    }
                    DispatchQueue.main.async {
                        self.btnFav.setImage(#imageLiteral(resourceName: "star_white_iPhone"), for: .normal)
                    }
                    self.locationInfo.isFav = isFav
                    
                }else{

                kAppDelegate.objUserInfo.favourites.append(self.locationInfo)
                    DispatchQueue.main.async {
                        self.btnFav.setImage(#imageLiteral(resourceName: "star_iPhone"), for: .normal)
                    }
                    self.locationInfo.isFav = is_fav
 
                }
                self.locationDelegate.refreshData(info: self.locationInfo)
            }else{
                if  isFav == 1 {
                    self.locationInfo.isFav = 0
                    DispatchQueue.main.async {
                        self.btnFav.setImage(#imageLiteral(resourceName: "star_white_iPhone"), for: .normal)
                    }
                }else{
                    self.locationInfo.isFav = 1
                    DispatchQueue.main.async {
                        self.btnFav.setImage(#imageLiteral(resourceName: "star_iPhone"), for: .normal)
                    }
                }
                self.locationDelegate.refreshData(info: self.locationInfo)
            }
        }
    }
    //====================================================================================================
    //MARK: -  METHODS
    //====================================================================================================
    func refreshDetails(){
       
        peopleList = self.locationInfo.users.filter({ (people) -> Bool in
            if people.visible != .invisible {
                if people.visible == .everyone {
                    return true
                }else if people.visible == .friends {
                    if people.is_friend == 1 {
                        return true
                    }
                }
            }
             return false
        })
 
       let f  = peopleList.filter({ (people) -> Bool in
            if people.is_friend == 1 && people.visible != .invisible  {
                return true
            }
            return false
        })
        let friend = f.sorted { $0.f_name < $1.f_name }
        
        let o  = peopleList.filter({ (people) -> Bool in
            if people.is_friend != 1 && people.visible == .everyone && people.id != kAppDelegate.objUserInfo.id {
                return true
            }
            return false
        })
        let other = o.sorted { $0.f_name < $1.f_name }
        peopleList.removeAll()
        peopleList.append(contentsOf: friend)
        peopleList.append(contentsOf: other)
//        let cUser = self.locationInfo.users.last!
        let cUser = PPeople()
        cUser.id = kAppDelegate.objUserInfo.id
        cUser.f_name = "You"
        cUser.l_name = "You"
        cUser.full_name = "You"
        cUser.profile_pic_thumb = kAppDelegate.objUserInfo.profileThumb
        cUser.status = kAppDelegate.objUserInfo.status
        cUser.visible = kAppDelegate.objUserInfo.visibility
        
        if cUser.visible != .invisible {
          peopleList.append(cUser)
        }
                
        headerView.frame.size.height = (screenHeight() * headerRatio )/100
        self.lblTitle.text = self.locationInfo.name
        if self.locationInfo.isFav == 0 {
            btnFav.setImage(#imageLiteral(resourceName: "star_white_iPhone"), for: .normal)
        }else{
            btnFav.setImage(#imageLiteral(resourceName: "star_iPhone"), for: .normal)
        }
        if self.locationInfo.photo != "" {
            let url = URL(string: self.locationInfo.photo)
            imgLocationBanner.sd_setImage(with: url, placeholderImage: nil, options: [SDWebImageOptions.refreshCached,SDWebImageOptions.highPriority,SDWebImageOptions.retryFailed]) { (image, error, cacheType, url) in
                if error != nil {
                    debugPrint("Failed: \(error.debugDescription)")
                } else {
                    self.imgLocationBanner.image = image!
                }
            }
        }else{
            let url = URL(string: changeImageUrl(url: self.locationInfo.icon))
            imgLocationBanner.sd_setImage(with: url, placeholderImage: nil, options: [SDWebImageOptions.refreshCached,SDWebImageOptions.highPriority,SDWebImageOptions.retryFailed]) { (image, error, cacheType, url) in
                if error != nil {
                    debugPrint("Failed: \(error.debugDescription)")
                } else {
                    self.imgLocationBanner.image = image!
                }
            }
        }
        
       let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PLocationProfileVC.showImagePopUP(_:)))
        imgLocationBanner.isUserInteractionEnabled = true
        imgLocationBanner.addGestureRecognizer(tapGesture)
        tblView.reloadData()
    }
    
    //Show image in popup screens
    
    func showImagePopUP(_ sender: UITapGestureRecognizer) {
        
       let imgView = sender.view as! UIImageView
 
       self.photos.removeAll()
 
        if imgView.image?.cgImage == nil
        {
            return
        }
 
        let img = PPhoto(image: imgView.image, imageData: imgView.image?.highestQualityJPEGNSData as NSData?, attributedCaptionTitle: NSAttributedString(string: self.locationInfo.name))
            
        self.photos.append(img)
        
        let photosViewController = NYTPhotosViewController(photos: self.photos, initialPhoto: self.photos[0], delegate: self)
        photosViewController.delegate = self
        photosViewController.rightBarButtonItem = nil
        
        UIApplication.shared.isStatusBarHidden = true
        photosViewController.view.frame(forAlignmentRect: CGRect(x: 0.0, y: 20.0, width: screenWidth(), height: screenHeight()))
        
        present(photosViewController, animated: true, completion: nil)
        
        updateImagesOnPhotosViewController(photosViewController: photosViewController, afterDelayWithPhotos: photos)
    }
    
    //====================================================================================================
    //MARK: -  SERVICE CALL
    //====================================================================================================
    
    //Get location complete details
    
    func getLocationDetails(placeId : String, completion:(() -> Void)?) {
        if !isContent  {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        let paramDict = NSMutableDictionary()
        paramDict[pPlace_id]        = placeId
        paramDict[pUser_id]         = kAppDelegate.objUserInfo.id
        
        ServiceHelper.callAPIWithoutLoader(paramDict, method: .get, apiName: kApiPlacechatuserslist) { (response, error) in
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            debugPrint("getLocationDetails")
            if error != nil {
                //                _ = AlertController.alert(title: "Error!", message: error.localizedDescription)
            } else {
                if let responseDict = response as? Dictionary<String, AnyObject> {
                    if let successFull = responseDict[pSuccess] as? Bool {
                        if (successFull) {
                            // Success
                            self.isContent = true
                            let data = responseDict[pData] as! Dictionary<String, AnyObject>
                            let place = data[kPlace] as! Dictionary<String, AnyObject>
                            self.locationInfo.users.removeAll()
                            self.locationInfo.place_id = placeId
                            self.locationInfo.name = "\(place[pName]!)"
                            self.locationInfo.photo = "\(place[pPhoto]!)"
                            self.locationInfo.icon = "\(place[pThumbnail_img]!)"
                            
                            if let ambassador = place[pAmbassador_status] as? Int {
                                self.locationInfo.ambassador_status = ambassador
                            }else if let ambassador = place[pAmbassador_status] as? String, ambassador != "" {
                                self.locationInfo.ambassador_status = Int(ambassador)!
                            }
                            self.locationInfo.isFav = place[pIs_fav] as! Int
                            
                            if let users = data[pUsers] as? NSArray {
                                
                                for user in users {
                                    let p = PPeople().initPeopleProfileData(infoDict: user as! Dictionary<String, AnyObject>)
//                                    if p.status != .inactive {
                                        self.locationInfo.users.append(p)
//                                    }
                                }
                            }
                            let p = PPeople()
                            p.id = kAppDelegate.objUserInfo.id
                            p.f_name = "You"
                            p.l_name = "You"
                            p.full_name = "You"                            
                            p.profile_pic_thumb = kAppDelegate.objUserInfo.profileThumb
                            p.status = kAppDelegate.objUserInfo.status
                            p.visible = kAppDelegate.objUserInfo.visibility
                            p.is_friend = 0
                            self.locationInfo.users.append(p)
                            
                            DispatchQueue.main.async {
                                MBProgressHUD.hide(for: self.view, animated: true)
                                self.refreshDetails()
                            }
                            self.locationDelegate.refreshData(info: self.locationInfo)
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
    extension PLocationProfileVC : NYTPhotosViewControllerDelegate {
        
        
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
            
            if photo as! PPhoto == self.photos[CustomEverythingPhotoIndex] {
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
            
            if photo as! PPhoto == self.photos[Int(photoIndex)] {
                
                return photo.attributedCaptionTitle?.string
            }
            return ""
        }
    }

 
