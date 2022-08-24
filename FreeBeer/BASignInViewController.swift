
import UIKit

import Alamofire

protocol BASignInViewControllerDelegate {
    func showSignUpViewController()
    
}


class BASignInViewController: UIViewController,UITextFieldDelegate {
    
  
    @IBOutlet var signInButton: UIButton!
    @IBOutlet var emailTextField: CustomTextField!
    @IBOutlet var passwordTextfield: CustomTextField!
    var delegate:BASignInViewControllerDelegate? = nil
    
//====================================================================================================
//MARK: VIEW LIFE CYCLE
//====================================================================================================
    
    override func viewDidLoad() {
        emailTextField.delegate = self
        passwordTextfield.delegate = self
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
//====================================================================================================
//MARK: BUTTON ACTION
//====================================================================================================
    @IBAction func crossButtonTapped(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if isValid() == true{
            
            networkCallForSignUpAPI()
        }
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
        
        delegate?.showSignUpViewController()

    }
    
    @IBAction func forgotPasswordButtonTapped(_ sender: UIButton) {
        
        DispatchQueue.main.async {
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "BAForgetPasswordViewController") as! BAForgetPasswordViewController
            self.present(viewController, animated: true) {}
            
        }
    }
    
//====================================================================================================
//MARK: UITEXTFIELD DELEGATE METHODS
//====================================================================================================
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailTextField{
        
            passwordTextfield.becomeFirstResponder()
        }
        else{
        
       
            
            signInButton.sendActions(for: .touchUpInside)
            
        }
        
        return true
    }
    
//====================================================================================================
//MARK: NETWORK CALL
//====================================================================================================
    func networkCallForSignUpAPI()
    {
        
        //        debugPrint(userType)
        
        let hud = CAUtilities().startActivityIndicator(sender: self, andMessage: "Sign in")
        
       
        let parameters : [String:Any] = [
            
            "login_type": "email",
            "device_token":CAAppConstant.sharedInstance.deviceToken == "" ? "" : CAAppConstant.sharedInstance.deviceToken,
            "os": "iOS",
            "email": emailTextField.text!,
            "password": passwordTextfield.text!,
            "social_id": 0,
            "first_name": "string",
            "last_name": "string",
            "facebook_token": "string",
            "twitter_secret": "string"
        ]
        
        debugPrint(" parameters : \(parameters)")
        
        var url : String!
        
        url = "\(AppBaseUrl)\(SignInUrl)"
        
        debugPrint(" URL : \(url)")
        
        let header = ["content-type" : "application/json"]
        
        Alamofire.request(url!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: header).responseObject { (response: DataResponse<user>) in
            
            if (response.result.isSuccess){
                
                let user = response.result.value
                
                let httpStatusCode = response.response?.statusCode
                if httpStatusCode == 200 || httpStatusCode == 201{
                    
                    CAAppConstant.sharedInstance.saveUserDetail(activeuser: user!)
                    
                    CAUtilities().stopActivityIndicator(hud: hud, andMessage: "", sender: self)
                    
                    DispatchQueue.main.async {
                     
                        CAUtilities().setHomeViewController()
                    }
                    
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
//====================================================================================================
//MARK: USER DEFINED METHODS
//====================================================================================================
    
    
    func isValid() -> Bool
    {
        if emailTextField.text?.isBlank ==  false ||  passwordTextfield.text?.isBlank ==  false
        {
            CAUtilities().showAlert(message: "Please fill the mandatory fields", sender: self)
            return false
        }
        
        else if emailTextField.text?.isValidEmail ==  false
        {
            CAUtilities().showAlert(message: "Email not valid", sender: self)
            return false
        }
      
        else if (self.passwordTextfield.text?.characters.count)! < 6
        {
            CAUtilities().showAlert(message: "Password should have atleast 6 char", sender: self)
            return false
        }
        else if emailTextField.text?.isBlank ==  false &&  passwordTextfield.text?.isBlank ==  false
        {
            CAUtilities().showAlert(message: "Please fill the mandatory fields", sender: self)
            return false
        }
        else
        {
            return true
        }
    }
}
