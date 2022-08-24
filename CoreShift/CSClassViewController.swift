
import UIKit
import Alamofire
import ObjectMapper

class CSClassViewController: CSViewController {
    
    @IBOutlet weak var editClassTableView: UITableView!
    
    var trainer : userDetail!
    
    var trainerClass : Class!
    
    var classArray = NSMutableArray()
    
    var classID : Int!
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if(trainer.classes != nil && (trainer.classes?.count)! > 0)
        {
        trainerClass = trainer.classes?[0]
        }
        
         NotificationCenter.default.addObserver(self, selector: #selector(self.PaymentSucessNotification), name: paymentSuccessNotificationName, object: nil)
        
        self.callClassDetailAPI(ishowLoading: true)
        
        editClassTableView.register(CSCertificationCell.self, forCellReuseIdentifier: "Class_cell")
        
        self.title = "CLASSES"
        
        self.addLeftNavigationBarItem()
        self.addRightNavigationBarItem()
        
       
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func PaymentSucessNotification()
    {
            self.callTraineNowAPI()
    }
    
   
    @IBAction func tapOnImageScroll(_ sender: UITapGestureRecognizer) {
        
        let scrollview = sender.view as! UIScrollView
        
        // let page = scrollview.auk.con.page(atIndex: scrollview.auk.currentPageIndex!, scrollView: scrollview)
        
        
        if trainerClass != nil
        {
            
            let imageInfo = JTSImageInfo()
            imageInfo.image = scrollview.auk.images[scrollview.auk.currentPageIndex!]
            imageInfo.referenceRect = (sender.view?.frame)!
            imageInfo.referenceView = sender.view?.superview
            let imageViewer = JTSImageViewController(imageInfo: imageInfo, mode: JTSImageViewControllerMode.image, backgroundStyle: JTSImageViewControllerBackgroundOptions.blurred)
            imageViewer?.show(from: self, transition: JTSImageViewControllerTransition.fromOriginalPosition)
            
        }
        else
        {
            //self.editClassHeroImage(UIButton())
        }
        
    }
    
    
    
    @IBAction func plusButtonIcon(_ sender: UIButton) {
        
        editClassTableView.contentOffset = CGPoint.zero

        
        let classIndex = sender.tag
        trainerClass = trainer.classes?[classIndex]
        
        self.callClassDetailAPI(ishowLoading: true)

        
        editClassTableView.reloadData()
        
    }
    
    
    
    
    
    @IBAction func messageTrainerButtonAction(_ sender: UIButton) {
        
        let viewcontroller = storyboard?.instantiateViewController(withIdentifier: "CSChatViewController") as! CSChatViewController
        viewcontroller.senderId = CSAppConstant.sharedInstance.user.uid
        viewcontroller.receiverID = trainer.uid
        viewcontroller.receiverName = trainer.fullname?.uppercased()

        _ = self.navigationController?.pushViewController(viewcontroller, animated: true)
        
        

    }
    
   
    
    @IBAction func trainNowBtnAction(_ sender: UIButton) {
        
        if(trainerClass.trainingId != nil)
        {
            CSUtility().showAlert(message: "You are already taking training of this class", sender: self)
        }
            
//        else if(trainer.payPalID == nil)
//        {
//            CSUtility().showAlert(message: "\(trainer.fullname!) doesn't set up paypal account yet, You can send message trainer to inform about this", sender: self)
//        }
        else{
            
            let paymentController = PaymentViewController()
            paymentController.receipent = "shahrukh.jain@ongraph.com"
            //paymentController.receipent = trainer.payPalID!
            paymentController.itemName = trainerClass.name!
            paymentController.itemDescription = trainerClass.description!
            paymentController.merchantName = trainer.fullname!
            paymentController.itemAmount = "\(trainerClass.fees!)"
            
           
            _ = self.navigationController?.pushViewController(paymentController, animated: true)
            

        }
    }
    
    
    
    func callTraineNowAPI()
    {
        
        _ = CSUtility().startActivityIndicator(sender: self, andMessage: "Requesting")
        
        debugPrint("updateUserLocationToServer")
        let parameters: [String: Any] = [
            "user_id": CSAppConstant.sharedInstance.user.uid!,
            "trainer_id": trainer.uid!,
            "class_id": trainerClass.classId!,
            ]
        
        debugPrint(" parameters : \(parameters)")
        
        
        
        let URL = "http://demo2.ongraph.com/demo/coreshift/api/requestfortraining"
        
        debugPrint(" URL : \(URL)")
        
        
        Alamofire.request(URL, method: .post, parameters: parameters, headers: nil)
            .responseJSON { response in
                debugPrint(response)
                
                
                
                if let json = response.result.value {
                    print("JSON: \(json)")
                    
                    let dataDict = json as! NSDictionary
                    
                    if(dataDict.object(forKey: "success") as! NSNumber == 1)
                    {
                        DispatchQueue.main.async {
                            self.callClassDetailAPI(ishowLoading: false)
                        }

                        CSUtility().showAlert(message: "Train now request successed", sender: self)
                    }
                    
                }
        }
    

    }
    
    
    func callClassDetailAPI(ishowLoading : Bool)
    {
        debugPrint("callEditClassAPI")
        
    
        if(ishowLoading == true)
        {
            _ = CSUtility().startActivityIndicator(sender: self, andMessage: "Please wait")

        }
        
        let parameters: [String: Any] = [
            "class_id": (classID != nil) ? classID! : trainerClass.classId!,
            "trainer_id": trainer.uid!,
            "user_id" : CSAppConstant.sharedInstance.user.uid!
        ]
        
        debugPrint(" parameters : \(parameters)")
        
        
        let URL = "http://demo2.ongraph.com/demo/coreshift/api/class_detail"
        
        debugPrint(" URL : \(URL)")
        
        
        Alamofire.request(URL, method: .post, parameters: parameters, headers: nil)
            .responseObject { (response: DataResponse<classResponse>) in
                
                
                DispatchQueue.main.async {
                    CSUtility().stopActivityIndicator(sender: self)
                }
                
                if(response.result.isSuccess)
                {
                    let addedClassResposne = response.result.value
                    
                    debugPrint(" Response : \(addedClassResposne?.toJSON())")
                    
                    if(addedClassResposne?.success == 1)
                    {
                        
                        
                        self.trainerClass = addedClassResposne?.classData
                        self.editClassTableView.reloadData()
                       
                    }
                    else{
                        
                    CSUtility().showAlert(message: (addedClassResposne?.message)!, sender: self)
                    }
                    
                }
                else{
                    
                    debugPrint(response.result.error!.localizedDescription)
                    CSUtility().showAlert(message: response.result.error!.localizedDescription, sender: self)
                }
                
                
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
    
}

extension  CSClassViewController: UITableViewDelegate, UITableViewDataSource
    
{
    // MARK: - UITableViewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        switch indexPath.section {
        case 0:
            return 273
        case 1:
            return 70
        case 2:
            
            if(trainerClass == nil || trainerClass.description == nil || trainerClass.description?.characters.count == 0)
            {
                return 0
            }
            else{
                return (trainerClass.description?.heightWithConstrainedWidth(width: UIScreen.main.bounds.size.width - 30, font: UIFont(name: "Lato-Light", size: 14)!))! + 30
            }
            
        case 3:
            return 70
            
        case 4 :
            
            if(trainerClass == nil || trainerClass.cancellationPolicy == nil || trainerClass.cancellationPolicy?.characters.count == 0)
            {
                return 80
            }
            else{
                return (trainerClass.cancellationPolicy?.heightWithConstrainedWidth(width: UIScreen.main.bounds.size.width - 30, font: UIFont(name: "Lato-Light", size: 14)!))! + 90
            }
            
       
            
            
        case 5 :
            
            
            
            let headerSize : CGFloat = 35.0
            let count = (trainer.classes?.count)!
            let cellHeight = ((UIScreen.main.bounds.size.width - 24 ) / 2 + 10 )
            if(count == 0)
            {
                return 0
            }
            else{
                var height : CGFloat = cellHeight
                let remainingCellCount = count / 2
                if(count % 2 == 0)
                {
                    height = height + cellHeight * CGFloat(remainingCellCount)
                    
                }
                else{
                    height = height + cellHeight * (CGFloat(remainingCellCount) +  1)
                    
                }
                
                return height + 20.0 + CGFloat((remainingCellCount - 1) * 10) + headerSize
                
            }
            
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if(indexPath.section == 0)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "user_images", for: indexPath) as! CSUserImagesCell
            
            if trainerClass != nil && trainerClass.image != nil &&  trainerClass.image?.characters.count != 0
            {
                cell.showUserImages(imageGallery: [trainerClass.image!])
            }
            else{
                cell.showUserImages(imageGallery: [String]())
                
            }
            
            return cell
        }
            
            
            
        else  if(indexPath.section == 1){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "class_info", for: indexPath) as! CSClassInfoCell
            
            if(trainerClass != nil)
            {
                cell.setBasicInfo(trainerClass: self.trainerClass)
                
            }
            
            
            return cell
            
        }
            
        else  if(indexPath.section == 2) {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "class_description", for: indexPath) as! CSClassDecriptionCell
            
            if(trainerClass != nil)
            {
                cell.showBasicDetail(trainerClass: trainerClass)
            }
            return cell
            
        }
            
            
        else  if(indexPath.section == 3) {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "fee_cell", for: indexPath)
            
            let feeLabel = cell.contentView.viewWithTag(200) as! UILabel
            
            if(trainerClass.fees != nil)
            {
                feeLabel.text = "$\(trainerClass.fees!)    "
            }
            
            return cell
            
        }
            
        else  if(indexPath.section == 4) {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cancellaion_policy_cell", for: indexPath) as! CSCancellationPolicyCell
            
            if(trainerClass != nil)
            {
                cell.showBasicInfo(trainerClass: trainerClass)
            }
            
            return cell
            
        }
   
        else  if(indexPath.section == 5) {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "class_cell", for: indexPath) as! CSTrainerClassCell
            
            
            return cell
        }
            
        else {
            
            let cell = UITableViewCell()
            
            return cell
            
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let tableViewCell = cell as? CSTrainerClassCell else { return }
        
        tableViewCell.setCollectionViewDataSourceDelegate(self, forSection: indexPath.section)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    
}




extension  CSClassViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        
        return 2
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        if(section == 0)
        {
            return ((trainer.classes?.count)! > 0) ? 1 : 0
            
        }
        else{
            return ((trainer.classes?.count)! > 0) ? ((trainer.classes?.count)! - 1 ) : 0
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if(indexPath.section == 0)
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "classCollection2_cell", for: indexPath) as! CSTrainerCollectionCell
            
            let trainerClass = trainer.classes?[indexPath.item]
            cell.clasName.text = trainerClass?.name
            cell.classSubtitle.text = trainerClass?.subtitle
            cell.classDecription.text = trainerClass?.description
            
            cell.classImage.sd_setImage(with: URL(string: (trainerClass?.image)!), placeholderImage: KPlaceholderImage)
            
            cell.editButton.tag = indexPath.item

            
            return cell
        }
            
        else{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "classCollection_cell", for: indexPath) as! CSTrainerCollectionCell
            
            let trainerClass = trainer.classes?[indexPath.item + 1]
            
            cell.clasName.text = trainerClass?.name
            cell.classSubtitle.text = trainerClass?.subtitle
            
            cell.classImage.sd_setImage(with: URL(string: (trainerClass?.image)!), placeholderImage: KPlaceholderImage)
            
            cell.editButton.tag = indexPath.item + 1

            
            return cell
            
            
        }
        
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        
        
        if(indexPath.section == 0)
        {
            return CGSize(width: UIScreen.main.bounds.size.width - 16, height: (UIScreen.main.bounds.size.width - 24 ) / 2 + 10)
        }
        else{
            return CGSize(width: (UIScreen.main.bounds.size.width - 24 ) / 2, height: (UIScreen.main.bounds.size.width - 24 ) / 2 + 10)
            
        }
    }
    
    
    
}



