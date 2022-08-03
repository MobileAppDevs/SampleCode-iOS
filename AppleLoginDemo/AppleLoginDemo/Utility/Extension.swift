//
//  Extension.swift
//  AppleLoginDemo
//
//  Created by Sumendra on 18/05/22.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showLoginViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let loginViewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController {
            self.navigationController?.pushViewController(loginViewController, animated: true)
        }
    }
}
