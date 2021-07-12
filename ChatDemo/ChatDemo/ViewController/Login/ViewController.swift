//
//  ViewController.swift
//  ChatDemo
//
//  Created by Amit Chauhan on 22/04/20.
//  Copyright © 2020 Amit Chauhan. All rights reserved.
//

import UIKit
import GoogleSignIn
import Foundation
import FirebaseDatabase
import Firebase


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance()?.delegate = self

        // Do any additional setup after loading the view.
    }

    //MARK:- Button action
    @IBAction func btn_googleSignInAction(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
    }

}

extension ViewController : GIDSignInDelegate{
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        //Sign in functionality will be handled here
        
        if let error = error {
            print(error.localizedDescription)
            return
        }
        guard let auth = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: auth.idToken,
                                                       accessToken: auth.accessToken)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Login Successful.", authResult?.user)
                //This is where you should add the functionality of successful login
                //i.e. dismissing this view or push the home view controller etc
                
                // po authResult?.user.uid / email / displayName / photoURL
                
                
                //update chat user
                let myString = authResult?.user.photoURL?.absoluteString
                
                FBDBManager.shared.registerAndUpdateUserList(userId: authResult?.user.uid, userName: authResult?.user.displayName, picURL: myString, email: authResult?.user.email)
                
                UserDefaultManager.sharedInstance.setuserID(id: authResult?.user.uid ?? "")
                
                let model = UserProfileModel(uid: authResult?.user.uid, email: authResult?.user.email, displayName : authResult?.user.displayName, photoURL: authResult?.user.photoURL)
                UserDefaultManager.sharedInstance.setUserProfileModel(model: model)
                
                let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController( withIdentifier: "HomeVC") as! HomeVC
                self.navigationController?.pushViewController(viewController, animated: true)

                
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
}
