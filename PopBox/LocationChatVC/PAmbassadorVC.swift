//
//  PAmbassadorVC.swift
//  Popbox
//
//  Created by Ongraph on 2/13/18.
//  Copyright © 2018 mac. All rights reserved.
//
import  UserNotifications
import UserNotificationsUI
import UIKit

class PAmbassadorVC: UIViewController {
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblTitle: UILabel!
//    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var colView: UICollectionView!
    
    var step = 0
    var isCheck = false
    var content = ""
    var questions = [AmbassadorQue]()
    var locationInfo:PLocationInfo!
    var txtViewAnswer:UITextView!
    var btnAmbassador: UIButton!
    let requestIdentifier = "SampleRequest"
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

//        let q1 = AmbassadorQue()
//            q1.questions = "Why do you want to be a Popbox Ambassador at [University/College name]?"
//        questions.append(q1)
//        let q2 = AmbassadorQue()
//        q2.questions = "What do you like most about Popbox?"
//        questions.append(q2)
//        let q3 = AmbassadorQue()
//        q3.questions = "What can Popbox do better?"
//        questions.append(q3)
//        let q4 = AmbassadorQue()
//        q4.questions = "How would you go about acquiring new members?"
//        questions.append(q4)
//        let q5 = AmbassadorQue()
//        q5.questions = "How would you go about acquiring new members? How would you go about acquiring new members? How would you go about acquiring new members? How would you go about acquiring new members?"
//        questions.append(q5)
//        self.btnNext.isHidden = true
        self.lblTitle.text = "Ambassador Program"
        getQuestionDetails(json: [:]) {
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //====================================================================================================
    //MARK: -  IB Action
    //====================================================================================================
    
    @IBAction func btnBackAction(_ sender: Any) {
        if txtViewAnswer != nil {
            txtViewAnswer.resignFirstResponder()
        }
        if step == 0 {
            let _ = self.navigationController?.popViewController(animated: true)
        }else{
            if !isFormEdited() {
                self.showFirstScreen()
            }else{
            _ = AlertController.alert("Leave screen?", message: "The changes you have made will be lost if you decide to leave this screen.", buttons: ["Stay","Leave"], tapBlock: { (action, index) in
                if index == 0 {
                    
                }else{
                    self.showFirstScreen()
                    
                }
            })
            }
        }
    }
    
    func showFirstScreen(){
        self.step = 0
        isCheck = false
        //        self.btnNext.isHidden = false
        self.lblTitle.text = "Ambassador Program"
//        questions.removeAll()
//        questions.append(contentsOf: que)
//        for i in 0..<questions.count {
//            questions[i].answer = ""
//        }
        for obj in questions {
            if obj.answer != nil {
                obj.answer = ""
            }
        }
        self.colView.delegate = self
        self.colView.dataSource = self
        self.colView.reloadData()
    }
    @IBAction func nextAction(_ sender: Any) {
 
            if step == 0 && questions.count > 0{
                step = 1
                lblTitle.text = "Apply"
                colView.delegate = self
                colView.dataSource = self
                colView.reloadData()
            }else{
                step = 1
                getQuestionDetails(json: [:]) {
                    
                }
            }
    }
    func checkBoxAction(_ sender : UIButton)   {
        if sender.image(for:.normal) == #imageLiteral(resourceName: "checkbox_iPhone") {
           sender.setImage(#imageLiteral(resourceName: "checkbox_selected_iPhone"), for: .normal)
            isCheck = true
        }else{
           sender.setImage(#imageLiteral(resourceName: "checkbox_iPhone"), for: .normal)
            isCheck = false
        }
        let cell = sender.superview?.superview as! PAmbassadorCell
        if isFormCompleted(){
            cell.btnAmbassador.backgroundColor = hexStringToUIColor(cBlueTheme)
            cell.btnAmbassador.isUserInteractionEnabled = true
        }
        colView.delegate = self
        colView.dataSource = self
        colView.reloadData()
    }
    func ambassadorAction(_ sender : UIButton)   {
        if !isFormCompleted() {
            _ = AlertController.alert(title: kOops, message: "Please answer all question.")
            return
        }
        if !isCheck {
            _ = AlertController.alert(title: kOops, message: "Please confirm checkbox.")
            return
        }
        if isFormCompleted(){
            let paramDict = NSMutableDictionary()
            let ques = NSMutableArray()
            for q in questions {
                ques.add(q.getData())
            }
            paramDict["questions"] = ques
            paramDict[pUser_id] = kAppDelegate.objUserInfo.id
            paramDict[pPlace_id] = locationInfo.place_id
            let ambassador = ["ambassador" : paramDict]
            getQuestionDetails(json: ambassador, completion: {
                
            })
        }
        /*
        print("notification will be triggered in five seconds..Hold on tight")
        let content = UNMutableNotificationContent()
        content.title = "Intro to Notifications"
        content.subtitle = "Lets code,Talk is cheap"
        content.body = "Sample code from WWDC"
        content.sound = UNNotificationSound.default()
        
        //To Present image in notification
        if let path = Bundle.main.path(forResource: "add_friend_iPhone", ofType: "png") {
            let url = URL(fileURLWithPath: path)
            
            do {
                let attachment = try UNNotificationAttachment(identifier: "sampleImage", url: url, options: nil)
                content.attachments = [attachment]
            } catch {
                print("attachment not found.")
            }
        }
        
        // Deliver the notification in five seconds.
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 5.0, repeats: false)
        let request = UNNotificationRequest(identifier:requestIdentifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().add(request){(error) in
            
            if (error != nil){
                
                print(error?.localizedDescription)
            }
        }
        
//        print("Removed all pending notifications")
//        let center = UNUserNotificationCenter.current()
//        center.removePendingNotificationRequests(withIdentifiers: [requestIdentifier])
 */
    }
    func dismissKeyboard(){
        if txtViewAnswer != nil {
            txtViewAnswer.resignFirstResponder()
        }
         self.view.endEditing(true)
    }
    
    func isFormCompleted()-> Bool{
        var found = true
        for obj in questions {
            if obj.answer == nil {
                found = false
                break
            }
            if obj.answer.isEmpty{
                found = false
                break
            }
        }
        if found && isCheck {
            return found
        }else{
            return false
        }
    }
    func isFormEdited()-> Bool{
        var found = false
        for obj in questions {
            if obj.answer != nil {
                if !obj.answer.isEmpty {
                    found = true
                }
            }
        }
        return found
    }
    
    //====================================================================================================
    //MARK: -  SERVICE CALL
    //====================================================================================================
    //- Show message “Application sent.” for 1 second, then take user to Home screen
//    - Send applicant an auto-message notification as below:
//    Notifications profile pic: Golden P logo
//    Notification title: “Popbox Ambassador - thank you for your application”
//    Opening the notification will show a popup: “Thank you for your application to be a Popbox Ambassador at [Uni name].  We will review and revert to you soon!” with button for “OK”
    
    func getQuestionDetails(json : Dictionary<String,AnyObject>, completion:(() -> Void)?) {
        let paramDict = NSMutableDictionary()
        paramDict.addEntries(from: json)
        
        ServiceHelper.callAPIWithParameters(paramDict, method: .post, apiName: kApiQuestions) { (response, error) in
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            debugPrint("getQuestionDetails")
            if error  != nil{
                
            } else {
                if let responseDict = response as? Dictionary<String, AnyObject> {
                    if let successFull = responseDict[pSuccess] as? Bool {
                        if (successFull) {
                            // Success
                            
                            if let que = responseDict[pData] as? NSArray {
                                for user in que {
                                    self.questions.append(AmbassadorQue().initQue(infoDict: user as! Dictionary<String, AnyObject>))
                                    
                                }
//                                self.que.append(contentsOf: self.questions)
                            }
                            DispatchQueue.main.async {
                                MBProgressHUD.hide(for: self.view, animated: true)
                            
                            if !json.isEmpty{
                                //Go Back to Chat screen
                                
                                _ =  AlertController.showToastAlert("Application sent.", 1.0, completion: {
                                    NotificationCenter.default.post(name: .pRefreshMap, object: nil)
                                    self.navigationController?.popViewController(animated: true)
                                })                                
                            }else{
                                if self.step == 1 {
                                    self.colView.delegate = self
                                    self.colView.dataSource = self
                                    self.colView.reloadData()
                                }else{
                                self.showFirstScreen()
                                }
                            }
                            }
                            completion!()
                        } else {
                            //                            if let responseMessage = responseDict[pResponseMessage] as? String {
                            //
                            //                            }
                        }
                    }
                }
            }
        }
    }
}

//====================================================================================================
//MARK: -  Collection View DataSource and Delegate Method
//====================================================================================================
extension PAmbassadorVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout  {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
 
        return CGSize(width: screenWidth(), height: screenHeight() - 64)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if step == 0 {
            let item = collectionView.dequeueReusableCell(withReuseIdentifier: "PAmbassadorCVCell", for: indexPath) as! PAmbassadorCVCell
            
            let htmlFile = Bundle.main.path(forResource:"content", ofType: "html")
            if let html = try? String(contentsOfFile: htmlFile!, encoding: String.Encoding.utf8) {
                let attrString = NSMutableAttributedString(attributedString: html.html2AttributedString!)
                attrString.addAttribute(NSFontAttributeName, value: UIFont(name: fRoboto, size: 15.0)!, range: NSMakeRange(0, attrString.length))                
//                item.contentTxtView.attributedText = html.html2AttributedString!
                item.lblContent.attributedText = html.html2AttributedString!
            }
            item.btnNext.addTarget(self, action: #selector(PAmbassadorVC.nextAction(_:)), for: .touchUpInside)
            return item
        }else{
            let item = collectionView.dequeueReusableCell(withReuseIdentifier: "PAmbassadorCVQCell", for: indexPath) as! PAmbassadorCVCell
            item.tblView.delegate=self
            item.tblView.dataSource=self
            item.tblView.reloadData()
            item.tblView.estimatedRowHeight = 158
            item.tblView.rowHeight = UITableViewAutomaticDimension
            
           let header = "Thank you for your interest. We’d like to know more about you through a few simple questions below."
            
            let w = header.widthOfString(usingFont: UIFont(name:fRobotoItalic,size:14)!)
            let h = header.heightOfString(usingFont: UIFont(name:fRobotoItalic,size:14)!)
            let lblSize = screenWidth()-28
            let height = ((Double(w/lblSize).rounded(.up))*Double(h))+15
            item.lblHeight.constant = CGFloat(height)
            item.headerView.frame = CGRect(x: 0, y: 0, width: screenW(), height: height)
            
            return item
        }
        
    }
}

//====================================================================================================
//MARK: -  Table View DataSource and Delegate Method
//====================================================================================================
extension PAmbassadorVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cellID = ""
        if indexPath.section == 0 {
            cellID = "PAmbassadorCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! PAmbassadorCell
            cell.lblQuestion.text = questions[indexPath.row].name.replacingOccurrences(of: "[University/College name]", with: locationInfo.name)
            cell.lblSerial.text = String(indexPath.row+1) + "."
            cell.txtViewAnswer.delegate=self
            cell.txtViewAnswer.tag = indexPath.row
            cell.txtViewAnswer.text = questions[indexPath.row].answer
            cell.txtViewAnswer.tintColor = hexStringToUIColor(cBlueTheme)
            let toolbar = UIToolbar()
            toolbar.sizeToFit()
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
            
            let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(PAmbassadorVC.dismissKeyboard))
            
            toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
            cell.txtViewAnswer.inputAccessoryView = toolbar
            txtViewAnswer = cell.txtViewAnswer
            return cell
        }else  {
            cellID = "PAmbassadorFooterCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! PAmbassadorCell
            cell.lblQuestion.text = "By submitting your application, you confirm that you are a current student at " + locationInfo.name
            cell.btnAmbassador.addTarget(self, action: #selector(PAmbassadorVC.ambassadorAction(_:)), for: .touchUpInside)
            cell.btnCheckBox.addTarget(self, action: #selector(PAmbassadorVC.checkBoxAction(_:)), for: .touchUpInside)
            if isFormCompleted() {
                cell.btnAmbassador.backgroundColor = hexStringToUIColor(cBlueTheme)
                cell.btnAmbassador.isUserInteractionEnabled = true
            }else{
                cell.btnAmbassador.backgroundColor = hexStringToUIColor(cDarkGrey)
                cell.btnAmbassador.isUserInteractionEnabled = false
            }
            btnAmbassador = cell.btnAmbassador
            if isCheck{
                cell.btnCheckBox.setImage(#imageLiteral(resourceName: "checkbox_selected_iPhone"), for: .normal)
            }else{
                cell.btnCheckBox.setImage(#imageLiteral(resourceName: "checkbox_iPhone"), for: .normal)
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return questions.count
        }else {
            return 1
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}
extension PAmbassadorVC:UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if self.step != 0 {
        questions[textView.tag].answer = textView.text
        }
        if btnAmbassador != nil {
            if isFormCompleted() {
                btnAmbassador.backgroundColor = hexStringToUIColor(cBlueTheme)
                btnAmbassador.isUserInteractionEnabled = true
            }else{
                btnAmbassador.backgroundColor = hexStringToUIColor(cDarkGrey)
                btnAmbassador.isUserInteractionEnabled = false
            }
        }
        debugPrint("textViewDidChange")
    }
 
    func textViewDidEndEditing(_ textView: UITextView) {
        debugPrint("textViewDidEndEditing")
        if self.step != 0 {
        questions[textView.tag].answer = textView.text
        }
        if isFormCompleted() {
            colView.reloadData()
        }
    }
}
extension PAmbassadorVC:UNUserNotificationCenterDelegate{
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("Tapped in notification")
    }
    
    //This is key callback to present notification while the app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("Notification being triggered")
        //You can either present alert ,sound or increase badge while the app is in foreground too with ios 10
        //to distinguish between notifications
        if notification.request.identifier == requestIdentifier{
            
            completionHandler( [.alert,.sound,.badge])
            
        }
    }
}
