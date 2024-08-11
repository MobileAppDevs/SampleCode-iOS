//
//  ViewController.swift
//  FaceID_Authentication
//
//  Created by Amit on 24/07/24.
//

import UIKit

class ViewController: UIViewController {
    
    private let biometricIDAuthObj = BiometricIDAuthClass()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Button action
    
    /*
     User will click on Auth button then here we will found the FaceID data using complition
     */
    
    @IBAction func authBtnAction(_ sender: UIButton) {
        // This function 
        biometricIDAuthObj.canEvaluate { (canEvaluate, _, canEvaluateError) in
            guard canEvaluate else {
                self.alert(title: "Error",
                      message: canEvaluateError?.localizedDescription ?? "Face/Touch ID may not be configured",
                      okActionTitle: "OK")
                return
            }
            
            biometricIDAuthObj.evaluate { [weak self] (success, error) in
                guard success else {
                    self?.alert(title: "Error",
                                message: error?.localizedDescription ?? "Face/Touch ID may not be configured",
                                okActionTitle: "OK")
                    return
                }
                
                self?.alert(title: "Success",
                            message: "You have a free pass, now",
                            okActionTitle: "OK")
            }
        }
    }
    
    func alert(title: String, message: String, okActionTitle: String) {
        let alertView = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: .alert)
        let okAction = UIAlertAction(title: okActionTitle, style: .default)
        alertView.addAction(okAction)
        present(alertView, animated: true)
    }
    
}

