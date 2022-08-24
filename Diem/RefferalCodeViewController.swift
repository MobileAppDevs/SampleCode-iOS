//
//  ContactUsVC.swift
//  Requestor
//
//  Created by Nasim on 13/5/18.
//  Copyright © 2018 SMTech. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField
import ApiManagerLibrary
import FirebaseAuth

class RefferalCodeViewController: UIViewController {
    
    let titleLabel: UILabel = {
        let tl = UILabel()
        tl.font = UIFont(name: "telegrafico", size: 16)
        tl.text = "Please enter your referral code to receive 5% off your first order:"
        tl.textColor = .black
        tl.numberOfLines = 0
        return tl
    }()
    
    let submitButton: UIButton = {
        let iv = UIButton()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.setTitle("Submit", for: .normal)
        iv.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        iv.backgroundColor = #colorLiteral(red: 0.9058823529, green: 0.368627451, blue: 0.2235294118, alpha: 1)
        iv.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        iv.layer.cornerRadius = 5
        iv.layer.masksToBounds = true
        return iv
    }()
    
    
    let contactTextField: JVFloatLabeledTextField = {
        let tf = JVFloatLabeledTextField()
        tf.textColor = #colorLiteral(red: 0.3176470588, green: 0.4078431373, blue: 0.4588235294, alpha: 1)
        tf.font = UIFont(name: "telegrafico", size: 16)

        tf.isSecureTextEntry = false
        tf.floatingLabelActiveTextColor = #colorLiteral(red: 0.3176470588, green: 0.4078431373, blue: 0.4588235294, alpha: 1)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.attributedPlaceholder = NSAttributedString(string: "Enter Code Here",
                                                      attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.1764705882, green: 0.2274509804, blue: 0.2549019608, alpha: 1)])
        return tf
    }()
    
    let contactUnderLine: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.7607843137, green: 0.8, blue: 0.8235294118, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let attributedString = NSMutableAttributedString(string: "Please enter your referral code to receive 5% off your first order:")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10 // Whatever line spacing you want in points
        paragraphStyle.alignment = .left
        
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        titleLabel.attributedText = attributedString
        
        view.backgroundColor = .white
        
        navigationItem.largeTitleDisplayMode = .never
        
        navigationItem.title = "Referral Code"
        NavigationBarColour.sharedInstance.changeNavigationBarTintColor(navBarController: navigationController!)
        NavigationBarColour.sharedInstance.setUpNavigationBarBackButton(title: "Settings", navItem: navigationItem)
        
        NavigationBarColour.sharedInstance.button?.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        setupViews()
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.backgroundColor = .white
    }
    
    @objc func handleBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleSubmit(){
        //self.sendEmail()
        
        if self.contactTextField.text?.count == 0
        {
            return
        }
        
    
        
        if let data = UserDefaults.standard.value(forKey:"userData") as? Data {
            let user = try? PropertyListDecoder().decode(UserModel.self, from: data)
            
            
            let progressHUD = ProgressHUD(text: "Please wait")
            self.view.addSubview(progressHUD)
            progressHUD.show()
            
            
            UsersApiManager.sendDoorknockerInfowithUserId(uid: (user?.uid)!, code: self.contactTextField.text!, completion: { (result) in
                switch result{
                case .success(let data):
                    print(data)
                    progressHUD.hide()
                    
                    self.showAlertWith(title: "Success", message: "Refferal code applied successfully")
                    
                    
                    
                    break
                case .failure(let error):
                    print(error)
                    progressHUD.hide()
                    
                    print(error)
                    self.showAlertWith(title: "Error", message: error.localizedDescription)
                    
                    
                    
                }
            })
        }
        
       
        
       
    }
    
    func showAlertWith(title: String, message:String, style: UIAlertControllerStyle = .alert){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        
        let action2 = UIAlertAction(title: "OK", style: .cancel) { (action:UIAlertAction) in
            print("You've pressed cancel");
            
            self.navigationController?.popViewController(animated: true)
        }
        
        
        alertController.addAction(action2)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
   
    
    func setupViews(){
        view.addSubview(titleLabel)
        titleLabel.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 39, paddingLeft: 23, paddingRight: 57, paddingBottom: 0, width: 0, height: 70)
        
        view.addSubview(contactTextField)
        contactTextField.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 27, paddingLeft: 23, paddingRight: 23, paddingBottom: 0, width: 0, height: 63)
        
        contactTextField.addSubview(contactUnderLine)
        contactUnderLine.anchor(top: nil, left: contactTextField.leftAnchor, bottom: contactTextField.bottomAnchor, right: contactTextField.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 1)
        
        
        view.addSubview(submitButton)
        submitButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 24, paddingRight: 24, paddingBottom: 50, width: 0, height: 48)
    }
}

