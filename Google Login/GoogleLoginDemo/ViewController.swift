//
//  ViewController.swift
//  GoogleLoginDemo
//
//  Created by Sumendra on 18/05/22.
//

import UIKit

class ViewController: UIViewController {
    
    var googleManager = GoogleLoginManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        googleManager.isUserGoogleLoggedIn {[weak self] isLoggedIn in
            if isLoggedIn{
                guard let user = getUserDetail() else{
                    return
                }
                self?.goToNextViewController(user: user)
            }
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func googleSignInClicked(){
        googleManager.getUserInfoFromGoogleSignIn(controller: self) {[weak self] user in
            guard let user = user else{
                return
            }
            user.saveUserDetails()
            self?.goToNextViewController(user: user)
        }
    }
    
    func goToNextViewController(user:UserDetail){
        let story = UIStoryboard(name: "Main", bundle: nil)
        let vc = story.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        vc.user = user
        vc.googleManager = googleManager
        self.navigationController?.pushViewController(vc, animated: true)
    }


}

