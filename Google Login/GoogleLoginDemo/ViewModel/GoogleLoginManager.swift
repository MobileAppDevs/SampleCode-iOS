//
//  GoogleLoginManager.swift
//  GoogleLoginDemo
//
//  Created by Sumendra on 18/05/22.
//

import Foundation
import UIKit
import GoogleSignIn


class GoogleLoginManager{
    func getUserInfoFromGoogleSignIn(controller:UIViewController, completion:@escaping(_ user: UserDetail?)->Void){
        let signInConfig = GIDConfiguration.init(clientID: "733957831458-s27s9cedfv55ndh6rdvqda3n46kl7f48.apps.googleusercontent.com")
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: controller) { user, error in
            guard error == nil else { return }
            guard let user = user else { return }
            let userDetail = UserDetail(id: user.userID ?? "",name: user.profile?.name ?? "", email: user.profile?.email ?? "", image: user.profile?.imageURL(withDimension:320) ?? URL(fileURLWithPath: ""))
            completion(userDetail)
        }
    }
    
    func signOutFromGoogle(){
        GIDSignIn.sharedInstance.signOut()
    }
    
    func isUserGoogleLoggedIn(completion:@escaping(_ isLoggedIn:Bool)->Void){
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error != nil || user == nil {
                completion(false)
                // Show the app's signed-out state.
            } else {
                completion(true)
                // Show the app's signed-in state.
            }
        }
    }
    
}
