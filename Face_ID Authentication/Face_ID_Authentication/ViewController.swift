//
//  ViewController.swift
//  Face_ID_Authentication
//
//  Created by Ongraph Technologies on 15/07/22.
//

import UIKit
import LocalAuthentication


// Added to info plist = Privacy - Face ID Usage Description

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func btnFaceId(_ sender: Any) {
        let context : LAContext = LAContext()
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil){
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "No Reason") { (response, error) in
                if error == nil {
                    print("Face id matched")
                }
                else{
                    print("Face didn't match")
                }
            }
        }
        else{
            print("Unable to Authenticate")
        }
    }
    
}

