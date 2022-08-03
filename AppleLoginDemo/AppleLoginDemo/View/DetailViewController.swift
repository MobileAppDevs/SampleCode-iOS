//
//  DetailViewController.swift
//  AppleLoginDemo
//
//  Created by Sumendra on 18/05/22.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblUserEmail: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    
    var user : UserDetail?


    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let user = user else {
            return
        }
        lblUserName?.text = user.name
        lblUserEmail?.text = user.email
        showUserImage()

        // Do any additional setup after loading the view.
    }
    
    func showUserImage(){
        if let url = user?.image{
            if let data = try? Data(contentsOf: url){
             imgUser?.image = UIImage(data: data)
            }
        }
    }
    
    @IBAction func btnLogoutPressed(_ sender:UIButton){
        // For the purpose of this demo app, delete the user identifier that was previously stored in the keychain.
        KeychainItem.deleteUserIdentifierFromKeychain()
        goToHomeViewController()
    }
    
    func goToHomeViewController(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateInitialViewController() as! UINavigationController
        loginVC.navigationBar.isHidden = true
        self.view.window?.rootViewController = loginVC
    }
    


}
