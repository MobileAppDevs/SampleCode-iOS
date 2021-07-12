//
//  AlertController.swift
//  CANINE BUDS
//
//  Created by Ongraph on 20/08/19.
//  Copyright © 2019 Ongraph. All rights reserved.
//

import UIKit

open class AlertController {
    
    // MARK: - Singleton
    class func getInstance() -> AlertController {
        struct Static {
            static let instance : AlertController = AlertController()
        }
        return Static.instance
    }
    
    // MARK: - Private Functions
    
    fileprivate func topMostController() -> UIViewController? {
        
        var presentedVC = UIApplication.shared.keyWindow?.rootViewController
        while let pVC = presentedVC?.presentedViewController {
            presentedVC = pVC
        }
        
        if presentedVC == nil {
            //print("AlertController Error: You don't have any views set. You may be calling in viewdidload. Try viewdidappear.")
        }
        return presentedVC
    }
    
    // MARK: - Class Functions
    
    
    func showToastAlert(_ title : String, _ delayTime : Double, completion:(() -> Void)?)  -> UIAlertController {
        
        let alert = UIAlertController(title: "", message: title, preferredStyle: UIAlertController.Style.alert)
        if let _ = AlertController.getInstance().topMostController() as? UIAlertController {
            
        }else {
            AlertController.getInstance().topMostController()?.present(alert, animated: true, completion: nil)
        }
        
        let delay = delayTime * Double(NSEC_PER_SEC)
        let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: {
            alert.dismiss(animated: true, completion: nil)
            if let com = completion {
                com()
            }
        })
        //        let attributedString = NSAttributedString(string: "", attributes: [
        //            NSFontAttributeName : UIFont(name: fRoboto, size: 15.0),
        //            NSForegroundColorAttributeName : hexStringToUIColor(cLightGreyNew)
        //            ])
        //
        //        alert.setValue(attributedString, forKey: "attributedTitle")
        
        return alert
        
    }
    
    func alert(title: String) -> UIAlertController {
        return alert(title: title, message: "")
    }
    
    func alert(message: String) -> UIAlertController {
        return alert(title: "", message: message)
    }
    
    func alert(title: String, message: String) -> UIAlertController {
        return alert(title, message: message, acceptMessage: "OK") { () -> () in
            // Do nothing
        }
    }
    
    func alert(_ title: String, message: String, acceptMessage: String, acceptBlock: @escaping () -> ()) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let acceptButton = UIAlertAction(title: acceptMessage, style: .default, handler: { (action: UIAlertAction) in
            acceptBlock()
        })
        alert.addAction(acceptButton)
        //        let attributedString = NSAttributedString(string: "", attributes: [
        //            NSFontAttributeName : UIFont(name: fRoboto, size: 15.0),
        //            NSForegroundColorAttributeName : hexStringToUIColor(cLightGreyNew)
        //            ])
        //
        //        alert.setValue(attributedString, forKey: "attributedTitle")
        
        AlertController.getInstance().topMostController()?.present(alert, animated: true, completion: nil)
        return alert
    }
    
    func alert(_ title: String, message: String, buttons:[String], tapBlock:((UIAlertAction,Int) -> Void)?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert, buttons: buttons, tapBlock: tapBlock)
        
        AlertController.getInstance().topMostController()?.present(alert, animated: true, completion: nil)
        return alert
    }
    
    
   func showAlert(message : String, sender : UIViewController){
        
        let alert: UIAlertController = UIAlertController(title: Bundle.main.infoDictionary!["CFBundleName"] as? String, message:message, preferredStyle: .alert)
        
        //Create and add first option action
        let action: UIAlertAction = UIAlertAction(title: "OK", style: .default) { action -> Void in
            //Code for action here
        }
        alert.addAction(action)
        sender.present(alert, animated: true, completion: nil)
    }
    
    func notifyUser(_ title: String, message: String, alertButtonTitles: [String], alertButtonStyles: [UIAlertAction.Style], vc: UIViewController, completion: @escaping (Int)->Void) -> Void
    {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        
        for title in alertButtonTitles {
            let actionObj = UIAlertAction(title: title,
                                          style: alertButtonStyles[alertButtonTitles.firstIndex(of: title)!], handler: { action in
                                            completion(alertButtonTitles.firstIndex(of: action.title!)!)
            })
            
            alert.addAction(actionObj)
        }
        //vc will be the view controller on which you will present your alert as you cannot use self because this method is static.
        vc.present(alert, animated: true, completion: nil)
    }

    
    
    func actionSheet(_ title: String, message: String, sourceView: UIView, actions: [UIAlertAction]) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.actionSheet)
        for action in actions {
            alert.addAction(action)
        }
        
        alert.popoverPresentationController?.sourceView = sourceView
        alert.popoverPresentationController?.sourceRect = sourceView.bounds
        AlertController.getInstance().topMostController()?.present(alert, animated: true, completion: nil)
        return alert
    }
    
    func actionSheet(_ title: String, message: String, sourceView: UIView, buttons:[String], tapBlock:((UIAlertAction,Int) -> Void)?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet, buttons: buttons, tapBlock: tapBlock)
        alert.popoverPresentationController?.sourceView = sourceView
        alert.popoverPresentationController?.sourceRect = sourceView.bounds
        AlertController.getInstance().topMostController()?.present(alert, animated: true, completion: nil)
        return alert
    }
    
}


private extension UIAlertController {
    convenience init(title: String?, message: String?, preferredStyle: UIAlertController.Style, buttons:[String], tapBlock:((UIAlertAction,Int) -> Void)?) {
        self.init(title: title, message: message, preferredStyle:preferredStyle)
        var buttonIndex = 0
        for buttonTitle in buttons {
            let action = UIAlertAction(title: buttonTitle, preferredStyle: .default, buttonIndex: buttonIndex, tapBlock: tapBlock)
            buttonIndex += 1
            self.addAction(action)
        }
    }
}

private extension UIAlertAction {
    convenience init(title: String?, preferredStyle: UIAlertAction.Style, buttonIndex:Int, tapBlock:((UIAlertAction,Int) -> Void)?) {
        self.init(title: title, style: preferredStyle) {
            (action:UIAlertAction) in
            if let block = tapBlock {
                block(action,buttonIndex)
            }
        }
    }
}
