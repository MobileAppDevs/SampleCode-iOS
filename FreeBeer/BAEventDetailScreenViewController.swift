
import UIKit
import Alamofire


class BAEventDetailScreenViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var eventNameLabel: UILabel!
  
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var bannerLabel: UILabel!
    
    var eventId = String()
    var eventDict = eventArray()
    var time = Timer()
    var timeCounter = 0
    let cell = BAEventCollectioneViewCell()
    
    var diff = 0


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.networkCallForRateDrinkList()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func menuButtonOnTap(_ sender: UIButton) {
        
        DispatchQueue.main.async {
            
            _ =  self.navigationController?.popViewController(animated: true)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //====================================================================================================
    //MARK: - NETWORK CALL
    //====================================================================================================
    
    func networkCallForRateDrinkList(){
        
        
        let hud = CAUtilities().startActivityIndicator(sender: self, andMessage: "Please wait" )
        
        var url : String!
        
        url = "\(AppBaseUrl)event/\(self.eventId)?uid=\(String(describing: CAAppConstant.sharedInstance.activeuser.id!))"
        
        print(" URL : \(url)")
        
        let header = ["content-type" : "application/json" ,"accesskey":"\(String(describing: CAAppConstant.sharedInstance.activeuser.access_token!))"]
        print(String(describing: CAAppConstant.sharedInstance.activeuser.access_token!))
        
        Alamofire.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseObject { (response: DataResponse<EventDetailMap>) in
            
            if (response.result.isSuccess){
                
                let httpStatusCode = response.response?.statusCode
                if httpStatusCode == 200 || httpStatusCode == 201{
                    
                    CAUtilities().stopActivityIndicator(sender: self)
                    
                    if let eventDetail = response.result.value
                    {
                        if let currentEvent = eventDetail.data
                        {
                            let event = currentEvent[0]
                            DispatchQueue.main.async {
                                
                                if let desc = event.description, let eventName = event.event_name, let location = event.event_location, let startTime = event.event_start_dt, let endTime = event.event_end_dt
                                {
                                    self.titleLabel.text = eventName
                                    self.eventNameLabel.text = eventName
                                    self.locationLabel.text = location
                                    self.descriptionLabel.text = desc
                                    self.timeLabel.text = self.calculateDate(startTimeString: startTime, endTimeString: endTime)
                                    self.getTimerOnBanner()
                                    
                                }
                                if let imageUrl = event.event_img
                                {
                                    self.eventImage.sd_setImage(with: URL(string: imageUrl))
                                }
                            }
                        }
                    }
                }
                else{
                    //handle case 422
                    CAUtilities().stopActivityIndicator(sender: self)
                    if let eventDetail = response.result.value
                    {
                        if let message = eventDetail.message
                        {
                            CAUtilities().showAlert(message: message, sender: self)
                        }
                    }
                }
            }
            else{
                
                if (NetworkReachabilityManager()?.isReachable == false){
                    
                    CAUtilities().stopActivityIndicator(hud: hud, andMessage: "No Internet Connection", sender: self)
                    
                }
                    
                else{
                    
                    debugPrint(response.result.error!.localizedDescription)
                    
                    CAUtilities().stopActivityIndicator(sender: self)
                    CAUtilities().showAlert(message: response.result.error!.localizedDescription, sender: self)
                    
                }
            }
            
        }
    }
    
    // MARK: - Calculate date
    
    func calculateDate(startTimeString: String, endTimeString: String) -> String
    {
        let startTime = Double(startTimeString)
        let endTime = Double(endTimeString)
        
        let DateFormatter1 = DateFormatter()
        DateFormatter1.dateFormat = "dd/MMM/yyyy"
        let enUSPOSIXLocale = Locale(identifier: "en_US_POSIX")
        DateFormatter1.locale = enUSPOSIXLocale
        DateFormatter1.timeZone = TimeZone.autoupdatingCurrent
        
        let DateFormatter2 = DateFormatter()
        DateFormatter2.dateFormat = "h:mm a"
        DateFormatter2.locale = enUSPOSIXLocale
        DateFormatter2.timeZone = TimeZone.autoupdatingCurrent
        
        let baEditVC = BAEditViewController()
        
        let time: String = "\(DateFormatter1.string(from: baEditVC.convertTimeStampIntoDate(startTime!)))" + "," + "\(DateFormatter2.string(from: baEditVC.convertTimeStampIntoDate(startTime!)))" + " " + "to" + " " + "\(DateFormatter2.string(from: baEditVC.convertTimeStampIntoDate(endTime!)))"
        
        return time
    }
    
    func getTimerOnBanner()
    {
        let startTime = Double(eventDict.event_start_dt!)
        let endTime = Double(eventDict.event_end_dt!)
        // ---------------------Time Banner------------------
        let eventVC = BAEditViewController()
        let currentTimeStamp = Date().timeIntervalSince1970
        
        var numberOfDays = eventVC.convertTimeStampIntoDate(startTime!).daysBetweenDate(toDate: eventVC.convertTimeStampIntoDate(currentTimeStamp))
        if numberOfDays == 0
        {
            if startTime! > Double(currentTimeStamp)
            {
                let createdAt = Double(eventDict.event_start_dt!)
                let diff =  createdAt! - currentTimeStamp
//                cell.timerOnCell(difference: Int(diff))
                self.timerOnBanner(difference: Int(diff))
            }
            else
            {
                self.bannerLabel.text = "Ongoing"
                cell.time.invalidate()
            }
        }
        else if numberOfDays < 0
        {
            numberOfDays = abs(numberOfDays)
            self.bannerLabel.text = "\(numberOfDays) days left"
            cell.time.invalidate()
        }
        else
        {
            self.bannerLabel.text = "Ongoing"
            cell.time.invalidate()
        }

    }
    
    func timerOnBanner(difference: Int)
    {
        self.bannerLabel.text = "Wait..."
        timeCounter = difference
        time.invalidate()
        time = Timer.scheduledTimer(timeInterval: 1.0,
                                    target: self,
                                    selector: #selector(self.advanceTimer(timer:)),
                                    userInfo: nil,
                                    repeats: true)
    }
    
    
    func advanceTimer(timer: Timer)
    {
        if timeCounter > 0
        {
            timeCounter -= 1
            
            let h = timeCounter/3600
            let m = timeCounter/60-h*60
            let s = timeCounter % 60
            
            let hStr = CAUtilities().checkNumberOfDigits(h: h)
            let mStr = CAUtilities().checkNumberOfDigits(h: m)
            let sStr = CAUtilities().checkNumberOfDigits(h: s)
            
            let timeToEvent = "\(hStr):\(mStr):\(sStr)"
            
            self.bannerLabel.text = timeToEvent
        }
        else
        {
            self.bannerLabel.text = "00:00:00"
        }
        
    }

}
