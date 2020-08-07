

import UIKit
import Alamofire

class MMSignupViewController: UIViewController {
    
    
    @IBOutlet weak var acceptTCBtn: UIButton!
    
    @IBOutlet weak var nameField: MMTextField!
    
    @IBOutlet weak var surnameField: MMTextField!
    

    @IBOutlet weak var emailField: MMTextField!
    
    @IBOutlet weak var passwordField: MMTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = true


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func alreadyRegisterButtonAction(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    
    @IBAction func registerButtonAction(sender: AnyObject) {

        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)
        })
        if(isValidCredentials() == true)
        {
            self.callRegisterApi()
        }
    }
    
    
    
    // MARK:- UITextFieldDelegate
    
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool
    {
        if CGRectGetMaxY(UIScreen.mainScreen().bounds) == 480 {
            
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.view.frame = CGRectMake(0, -90, self.view.bounds.size.width, self.view.bounds.size.height)
            })
        }
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {

        if(textField == nameField)
        {
            surnameField.becomeFirstResponder()
        }
            
        else if(textField == surnameField)
        {
            emailField.becomeFirstResponder()
        }
            
        else if(textField == emailField)
        {
            passwordField.becomeFirstResponder()
        }
            
        else{
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)
            })
            passwordField.resignFirstResponder()
        }
        return true
    }
    

    
    
    func isValidCredentials() -> Bool
    {
        if(self.nameField.text?.characters.count == 0)
        {
            MMUtility().showAlert("Please enter your name", sender: self)
            return false
        }
            
        else if(self.surnameField.text?.characters.count == 0)
        {
            MMUtility().showAlert("Please enter your surname", sender: self)
            return false
        }
            
        else if(self.emailField.text?.characters.count == 0)
        {
            MMUtility().showAlert("Please enter email address", sender: self)
            return false
        }
        else if(self.passwordField.text?.characters.count == 0)
        {
            MMUtility().showAlert("Please enter your password", sender: self)
            return false
        }
            
        else if(self.emailField.text?.isValidEmail == false){
            
            MMUtility().showAlert("Please enter valid email address", sender: self)
            return false
        }
        
        else if(self.acceptTCBtn.selected == false){
            
            MMUtility().showAlert("Por favor acepte el acuerdo legal con MYMA", sender: self)
            return false
        }
        
        return true
    }

    
    
    func callRegisterApi()
    {
        MMUtility().startActivityIndicator(self)
        
        let parameters: [String: AnyObject] = [
            "user":
                [
                    "email" : emailField.text!,
                    "password": passwordField.text!,
                    "name" : nameField.text!,
                    "surname": surnameField.text!
                ]
            
        ]
        
        debugPrint( parameters)

        
        Alamofire.request(.POST, "\(KbaseUrl)\(APIPaths.kRegister)", parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                
                
                dispatch_async(dispatch_get_main_queue(),{
                    MMUtility().stopActivityIndicator(self)
                })
                
                
                switch response.result {
                case .Success(let JSON):
                    
                    let response = JSON as! NSDictionary
                    
                    debugPrint( response)

                    
                    if(response.objectForKey("success") as! Bool == true)
                    {
                        debugPrint( response)
                        
                        
                        MMAppData.sharedInstance.isRemember(true)
                        MMAppData.sharedInstance.saveUserDetail(response.objectForKey("data")!)
                        self.performSegueWithIdentifier("signup-userdetail", sender: self)
                        
                        MMAppData.sharedInstance.fetchUserData()
                        
                        MMAppData.sharedInstance.callUpdateTokenAPI()


                        
                    }
                    else{
                        MMUtility().showAlert(response.objectForKey("message") as! String, sender: self)
                    }
                    
                    
                    
                case .Failure(let error):
                    debugPrint("Request failed with error: \(error.localizedDescription)")
                    MMUtility().showAlert(error.localizedDescription, sender: self)
                }
                
                
               
        }

    }
    
    
    @IBAction func acceptTCBtnAction(sender: AnyObject) {
        
       if acceptTCBtn.selected == false
       {
        acceptTCBtn.selected = true
        }
       else{
        acceptTCBtn.selected = false
        }
        
        
    }
    
    
    
    @IBAction func openTCBtnAction(sender: AnyObject) {
        
        let aboutUrlString = "http://www.6steps.es/condiciones-legales/"
        let url  = NSURL(string: aboutUrlString)!
        
        UIApplication.sharedApplication().openURL(url)
    }
    
   

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


