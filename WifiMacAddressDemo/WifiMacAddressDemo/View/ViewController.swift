//
//  ViewController.swift
//  WifiMacAddressDemo
//
//  Created by Sumendra on 18/05/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var lblMacAddress:UILabel!
    @IBOutlet weak var lblNetworkName: UILabel!
    
    let wifiManager = WifiAddressManager()
    let reachable = Reachability()

    override func viewDidLoad() {
        super.viewDidLoad()
        if reachable?.currentReachabilityStatus == .reachableViaWiFi{
            let wifiMac = wifiManager.getConnectedWifiMacAddress()
            if wifiMac.1 != ""{
                lblMacAddress?.text = wifiMac.0
                lblNetworkName?.text = wifiMac.1
            }
            debugPrint(wifiMac.0,wifiMac.1)
        }else{
            DispatchQueue.main.async {[weak self] in
                self?.lblMacAddress?.text = ""
                self?.lblNetworkName?.text = ""
                self?.showAlert(title: "Alert", message: "Please connect to wifi network")
            }

        }
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.updateNetworkName(notification:)),
                                               name:Notification.Name(rawValue: "updateNetworkName") ,
                                               object: nil)
        
    }
    
    
    @objc func updateNetworkName(notification:NSNotification){
        if let name = notification.userInfo?["name"] as? String,
           let bssid = notification.userInfo?["bssid"] as? String{
            if name != "" || bssid != ""{
                DispatchQueue.main.async {[weak self] in
                    self?.lblMacAddress?.text = bssid
                    self?.lblNetworkName?.text = name
                }
            }
        }
    }

}

