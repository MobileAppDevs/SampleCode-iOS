

import UIKit
import Alamofire
import AlamofireObjectMapper
import SDWebImage

//Delegate
protocol BASignUpViewControllerDelegate {
    
    func showSignInViewController()
  
}

class BASignUpViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate {

    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var genderButton: UIButton!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet var userImageButton: UIButton!
    @IBOutlet var userProfileImageView: UIImageView!
    @IBOutlet var firstNameTextField: CustomTextField!
    @IBOutlet var lastNameTextfield: CustomTextField!
    @IBOutlet var scrollViewContentView: UIView!
    @IBOutlet var passwordTextfield: CustomTextField!
    @IBOutlet var emailTextfield: CustomTextField!
    @IBOutlet var dateOfBirthPickerToolbar: UIToolbar!
    @IBOutlet var dateOfBirthPicker: UIDatePicker!
    @IBOutlet var genderTextfield: CustomTextField!
    @IBOutlet var confirmTextField: CustomTextField!
    var user_image_file_name = String()
    var user_image_file_url = String()
    
    @IBOutlet var scrollViewContentViewHeight: NSLayoutConstraint!
    
    let picker = UIImagePickerController()
    var choosenImg = UIImage()
    var imageName : String!
    let genderDropDown = DropDown()
    var dateStr = NSString()
    lazy var dropDowns: [DropDown] = {
        return [
            self.genderDropDown,
        ]
    }()
    @IBOutlet var dateOfBirthTextField: UITextField!
    //Delegate
    var delegate:BASignUpViewControllerDelegate? = nil
    
//====================================================================================================
//MARK: VIEW LIFE CYCLE
//====================================================================================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        textfieldSetup()
        initialFrameSetup()
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if UIScreen.main.bounds.size.height == 736{
        
        
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
//====================================================================================================
//MARK: BUTTON ACTION
//====================================================================================================
    @IBAction func uploadImageButtonTapped(_ sender: UIButton) {

      showPhotoChooseOptions()
        
    }
    
    @IBAction func crossButtonTapped(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
       
    }
    
    @IBAction func dateOfBirthButtonTapped(_ sender: UIButton) {
      
        self.view.endEditing(true)
        scrollViewContentView.isUserInteractionEnabled = false
           scrollViewContentView.alpha = 0.7
        
        UIView.animate(withDuration: 0.3) {

            self.dateOfBirthPickerToolbar.frame = CGRect(x:0,y:UIScreen.main.bounds.size.height - 260,width:UIScreen.main.bounds.size.width,height:44)
            self.dateOfBirthPicker.frame = CGRect(x:0,y:self.dateOfBirthPickerToolbar.frame.origin.y + self.dateOfBirthPickerToolbar.frame.size.height,width:UIScreen.main.bounds.size.width,height:216)
        }
        
    }
    @IBAction func toolbarDoneButtonOntap(_ sender: UIBarButtonItem) {
        
        scrollViewContentView.isUserInteractionEnabled = true
        scrollViewContentView.alpha = 1
        self.view.endEditing(true)
        
        if dateStr == ""{
            
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            dateOfBirthTextField.text = formatter.string(from: date)

        }
        else{
          
              dateOfBirthTextField.text = dateStr as String?
        }

        UIView.animate(withDuration: 0.3) {
            
            self.dateOfBirthPickerToolbar.frame = CGRect(x:0,y:UIScreen.main.bounds.size.height+44,width:UIScreen.main.bounds.size.width,height:44)
             self.dateOfBirthPicker.frame = CGRect(x:0,y:self.dateOfBirthPickerToolbar.frame.origin.y + self.dateOfBirthPickerToolbar.frame.size.height,width:UIScreen.main.bounds.size.width,height:216)
            
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            self.genderButton.sendActions(for: .touchUpInside)
        }

        
    }
    
    @IBAction func datePickerAction(_ sender: UIDatePicker) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
    
        dateStr = formatter.string(from: dateOfBirthPicker.date) as NSString!
    }
    
    @IBAction func genderButtonTapped(_ sender: UIButton) {
        
        
        let editbutton = sender 
        
        self.setupGenderDropDown(editButton: editbutton)
        
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        
        self.view.endEditing(true)
        if isValid() == true{
        
        callSignUpAPI()
        
        }
        
    }
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
        //Delegate
        dismiss(animated: true, completion: nil)
        
        delegate?.showSignInViewController()
       
    }
    
//====================================================================================================
//MARK: DROPDOWN SETUP
//====================================================================================================
    
    func setupGenderDropDown(editButton : UIButton) {
        
        genderDropDown.anchorView = editButton
        genderDropDown.width = 100
        genderDropDown.bottomOffset = CGPoint(x: 0, y: editButton.bounds.height)
        // You can also use localizationKeysDataSource instead. Check the docs.
        genderDropDown.dataSource  = ["male", "female"]
        // Action triggered on selection
        genderDropDown.selectionAction = { (index, item) in
            
            debugPrint(item)
            if(item == "male")
            {
                
                self.genderTextfield.text = "male"
                 self.emailTextfield.becomeFirstResponder()
                
            }
            else if(item == "female")
            {
                
                 self.genderTextfield.text = "female"
                 self.emailTextfield.becomeFirstResponder()
            }
            
            
        }
        
       
        genderDropDown.show()
    }
    
//====================================================================================================
//MARK: NETWORK CALL METHOD
//====================================================================================================
    
    func callSignUpAPI()
    {
        
//        debugPrint(userType)
        
     let hud = CAUtilities().startActivityIndicator(sender: self, andMessage: "Registering")
        
        /*
         {
                 }
         */
        let parameters : [String:Any] = [
           
                "first_name": firstNameTextField.text!,
                "last_name": lastNameTextfield.text!,
                "dob": (dateOfBirthTextField.text?.count !=  0 ) ? dateOfBirthTextField.text! : "NA",
                "gender": (genderTextfield.text?.count !=  0 ) ? genderTextfield.text! : "NA",
                "email": emailTextfield.text!,
                "password": passwordTextfield.text!,
                "device_token": CAAppConstant.sharedInstance.deviceToken == "" ? "" : CAAppConstant.sharedInstance.deviceToken,                "os": 1,
                "profileimage": self.imageName!,
                "refer_user_id": CAAppConstant.sharedInstance.defaults.value(forKey: "refer")  == nil ? "" : CAAppConstant.sharedInstance.defaults.value(forKey: "refer")! as! String
        ]
        
        
       
        
        debugPrint(" parameters : \(parameters)")
        
        var url : String!
        
            url = "\(AppBaseUrl)\(SignUpUrl)"
        
        debugPrint(" URL : \(url)")
        
        let header = ["content-type" : "application/json"]
        
//        Alamofire.request(url!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: header).response { (response) in
//            
//            do{
//                
//                let jsonResult = (try JSONSerialization.jsonObject(with: response.data!, options:
//                    JSONSerialization.ReadingOptions.mutableContainers))
//                
//                print(jsonResult)
//            }
//            catch{
//                
//                
//                
//            }
//        }
        
        
        
        Alamofire.request(url!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: header).responseObject { (response: DataResponse<user>) in
            
            if (response.result.isSuccess){
                
                let user = response.result.value
               
                let httpStatusCode = response.response?.statusCode
                if httpStatusCode == 200 || httpStatusCode == 201{
                    
                    CAUtilities().stopActivityIndicator(sender:self)
                    CAAppConstant.sharedInstance.defaults.removeObject(forKey: "refer")
                    
                    let alert = UIAlertController(title: "Free Beer", message: "You have Registered successfully, Please login with registered email adress to continue", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
                       
                        DispatchQueue.main.async {
                            
                            self.dismiss(animated: true, completion: nil)
                            self.delegate?.showSignInViewController()
                        }
                    })
                    
                    self.show(alert, sender: self)
         

                }
                else{
                    //handle case 422
                CAUtilities().stopActivityIndicator(sender: self)
               
                 CAUtilities().showAlert(message: (user?.message)!, sender: self)
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
    
    func uploadImageToServer(image : UIImage)
    {
        let hud = CAUtilities().startProgressIndicator(sender: self, andMessage:"Uploading...")
        
        //users/profiles/banner_image
        
        var URL = ""
        
      
            
            URL = "\(AppBaseUrl)\(ImageUploadUrl)"
      
     
        
        let imageData = UIImageJPEGRepresentation(image, 1.0)
        let header = ["content-type" : "application/json"]
        
        if (NetworkReachabilityManager()?.isReachable == false){
            
            CAUtilities().stopActivityIndicator(hud: hud, andMessage: "No Internet Connection", sender: self)
            
        }
        else{
        
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(imageData!, withName: "upload_image", fileName: "file.jpeg", mimeType: "image/jpeg")
            }, to: URL, method:.post, headers: header)
            { (result) in
                //
                switch result {
                case .success(let upload, _, _):
                    upload.uploadProgress { progress in
                        
                        print("completed : \(progress.fractionCompleted) ")
                        hud.progress = Float(progress.fractionCompleted)
                        
                    }
                    
                    upload.responseJSON { response in
                        debugPrint(response)
                        
                        if(response.result.isSuccess)
                        {
                            let responseData  = response.result.value as? NSDictionary
                            let httpStatusCode = response.response?.statusCode
                            if httpStatusCode == 201{
                                
                                CAUtilities().stopActivityIndicator(hud: hud, andMessage: "Uploaded", sender: self)
                                //change
                                
                                CAAppConstant.sharedInstance.userImageFileName = (((responseData?.value(forKey: "data") as! NSDictionary).value(forKey: "file_name")) as? String)!
                                CAAppConstant.sharedInstance.userImageFileUrl = (((responseData?.value(forKey: "data") as! NSDictionary).value(forKey: "file_url")) as? String)!
                              
                                self.imageName = ((responseData?.value(forKey: "data") as! NSDictionary).value(forKey: "file_name")) as? String
                                SDImageCache.shared().store(image, forKey: self.user_image_file_url)
                                
                                self.userProfileImageView.image = self.choosenImg
                                
                            }
                            else{
                                CAUtilities().stopActivityIndicator(sender: self)
                                CAUtilities().showAlert(message: "Error", sender: self)
                            }
                            
                        }
                        else
                        {
                            debugPrint(response.result.error!.localizedDescription)
                            CAUtilities().stopActivityIndicator(sender: self)
                            CAUtilities().showAlert(message: response.result.error!.localizedDescription, sender: self)
                        }
                        
                        
                        
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
            }
            
        }
    }
//====================================================================================================
//MARK: IMAGEPICKER METHOD
//====================================================================================================
    func showPhotoChooseOptions(){
    
    let alert = UIAlertController(title: nil, message: "Choose your option", preferredStyle: UIAlertControllerStyle.actionSheet)
    
    alert.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
    print("Camera selected")
    self.openCamera()
    
    })
    alert.addAction(UIAlertAction(title: "Photos", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
    print("Photo selected")
    self.openGallery()
    
    })
    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
    print("cancel")
    // self.isRestaurentImageUpload = false
    alert.dismiss(animated: true, completion: nil)
    })
    
//    alert.popoverPresentationController?.sourceView = createMenuTable for Ipad
    present(alert, animated: true, completion: nil)
    
}

    func openCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraCaptureMode = .photo
            picker.delegate = self
            
            picker.modalPresentationStyle = .fullScreen
            self.present(picker,animated: true,completion: nil)
        } else {
            noCamera()
        }
    }
    
    func openGallery()
    {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        picker.delegate = self
        
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        self.present(picker, animated: true, completion: nil)
    }
    
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        self.present(
            alertVC,
            animated: true,
            completion: nil)
    }
//====================================================================================================
//MARK: IMAGEPICKER DELEGATES
//====================================================================================================
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        
        choosenImg = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.uploadImageToServer(image: choosenImg)
        
        

        self.dismiss(animated:true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {

        self.dismiss(animated: true, completion: nil)
        
    }
    
//====================================================================================================
//MARK: TEXTFIELD DELEGATES
//====================================================================================================
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        
        dateButton.isUserInteractionEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        
        
        dateButton.isUserInteractionEnabled = true
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == firstNameTextField{
            
            lastNameTextfield.becomeFirstResponder()
        }
        else if textField == lastNameTextfield{
        
            lastNameTextfield.resignFirstResponder()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                
                self.dateButton.sendActions(for: .touchUpInside)
            }
        
        }
        else if textField == emailTextfield{
            
           passwordTextfield.becomeFirstResponder()
            
        }
        else if textField == passwordTextfield{
            
            confirmTextField.becomeFirstResponder()
            
        }
        else{
            
         signUpButton.sendActions(for: .touchUpInside)
 
        }
        
        return true
    }
    
//====================================================================================================
//MARK: USER DEFINED METHODS
//====================================================================================================
    
    func isValid() -> Bool{
        
        if firstNameTextField.text?.isBlank ==  false ||  lastNameTextfield.text?.isBlank ==  false || passwordTextfield.text?.isBlank ==  false &&  confirmTextField.text?.isBlank ==  false
        {
            CAUtilities().showAlert(message: "Please fill the mandatory fields", sender: self)
            return false
        }
        else if (self.firstNameTextField.text?.characters.count)! < 3
        {
            CAUtilities().showAlert(message: "First name should have least 3 char", sender: self)
            return false
        }
        else if (self.lastNameTextfield.text?.characters.count)! == 0
        {
            CAUtilities().showAlert(message: "Last name can't be empty", sender: self)
            return false
        }
        else if (emailTextfield.text?.isValidEmail)! == false
        {
            CAUtilities().showAlert(message: "Email is not valid", sender: self)
            return false
        }
        else if (self.passwordTextfield.text?.characters.count)! < 6
        {
            CAUtilities().showAlert(message: "Password should have atleast 6 char", sender: self)
            return false
        }
        else if self.confirmTextField.text != self.passwordTextfield.text
        {
            CAUtilities().showAlert(message: "Passwords don't match", sender: self)
            return false
        }
//        else if genderTextfield.text?.characters.count == 0
//        {
//            CAUtilities().showAlert(message: "Select gender", sender: self)
//            return false
//        }
//        else if dateOfBirthTextField.text?.characters.count == 0
//        {
//            CAUtilities().showAlert(message: "Select Date of Birth", sender: self)
//            return false
//        }
        else if imageName == nil
        {
            CAUtilities().showAlert(message: "Upload your profile picture", sender: self)
            return false
        }
        else if firstNameTextField.text?.isBlank ==  false &&  lastNameTextfield.text?.isBlank ==  false && passwordTextfield.text?.isBlank ==  false &&  confirmTextField.text?.isBlank ==  false
        {
            CAUtilities().showAlert(message: "Please fill the mandatory fields", sender: self)
            return false
        }
        else
        {
            
            return true
            
        }
        
    }

    
    func textfieldSetup(){
    
        firstNameTextField.delegate = self
        lastNameTextfield.delegate = self
        genderTextfield.delegate = self
        dateOfBirthTextField.delegate = self
        emailTextfield.delegate = self
        confirmTextField.delegate = self
        passwordTextfield.delegate = self
        
        
    }
    
    func initialFrameSetup(){
        
        dateOfBirthPicker.backgroundColor = UIColor.lightGray
        userProfileImageView.layer.cornerRadius = userProfileImageView.frame.size.height/2
        userProfileImageView.clipsToBounds = true
        userImageButton.layer.cornerRadius = userProfileImageView.frame.size.height/2
        userImageButton.clipsToBounds = true

        self.dateOfBirthPickerToolbar.frame = CGRect(x:0,y:UIScreen.main.bounds.size.height+44,width:UIScreen.main.bounds.size.width,height:44)
        self.dateOfBirthPicker.frame = CGRect(x:0,y:self.dateOfBirthPickerToolbar.frame.origin.y + self.dateOfBirthPickerToolbar.frame.size.height,width:UIScreen.main.bounds.size.width,height:216)

    }
    
    
}

