
import UIKit
import Alamofire
class MMLoginViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var emailField: MMTextField!
    
    @IBOutlet weak var passwordField: MMTextField!
    
    var shouldRemember = false
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = true
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func rememberButtonAction(sender: UIButton) {
        
        if(sender.selected == true)
        {
            sender.selected = false
            shouldRemember = false
        }
        else{
            sender.selected = true
            shouldRemember = true
        }
        
    }
    
  
    
    @IBAction func loginButtonAction(sender: AnyObject) {
        
        if(self.isValidCredentials() == true)
        {
            self.callLoginApi()
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
        
        if(textField == emailField)
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
    
    
    func callLoginApi()
    
    {
        MMUtility().startActivityIndicator(self)
        
        let parameters: [String: AnyObject] = [
            "user":
                [
                    "email" : emailField.text!,
                    "password": passwordField.text!
            ]
            
        ]
        
        debugPrint( parameters)
        
        
        Alamofire.request(.POST, "\(KbaseUrl)\(APIPaths.Klogin)", parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                
                
                MMUtility().stopActivityIndicator(self)
                
                debugPrint(response.result)
                
                switch response.result {
                case .Success(let JSON):
                    
                    let response = JSON as! NSDictionary
                    
                    if(response.objectForKey("success") as! Bool == true)
                    {
                       
                        MMAppData.sharedInstance.saveUserDetail(response.objectForKey("data")!)
                        
                        MMAppData.sharedInstance.isRemember(self.shouldRemember)
                        
                        MMUtility().setHomeViewController()
                        
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
    
    
    func isValidCredentials() -> Bool
    {
        if(self.emailField.text?.characters.count == 0)
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
        
        return true
    }
    


}

