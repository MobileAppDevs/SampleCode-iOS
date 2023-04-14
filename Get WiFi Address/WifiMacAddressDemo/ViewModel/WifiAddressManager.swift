//
//  WifiAddressManager.swift
//  WifiMacAddressDemo
//
//  Created by Sumendra on 18/05/22.
//

import Foundation
import SystemConfiguration.CaptiveNetwork
import UIKit


class WifiAddressManager {
    
    
    func getConnectedWifiMacAddress()->(String,String){
            var macAddress = ""
            var networkName = ""
            let informationArray:NSArray? = CNCopySupportedInterfaces()
            if let information = informationArray {
                let dict:NSDictionary? = CNCopyCurrentNetworkInfo(information[0] as! CFString)
                if let temp = dict {
                    macAddress = String(temp["BSSID"] as? String ?? "")
                    networkName = String(temp["SSID"] as? String ?? "")
                    return (macAddress,networkName)
                }
            }
        return (macAddress,networkName)
        }
}

extension ViewController{
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
}
