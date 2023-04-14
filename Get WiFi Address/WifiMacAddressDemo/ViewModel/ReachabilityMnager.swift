//
//  ReachabilityManager.swift
//  WifiMacAddressDemo
//
//  Created by Sumendra on 19/05/22.
//

import Foundation

class ReachabilityManager{
    
    
    private var wifiManager = WifiAddressManager()
    
    static  let shared = ReachabilityManager()

    func setNetworkNameWhenComeFromBackround(){
        let reachability =  Reachability()
        if reachability?.currentReachabilityStatus == .reachableViaWiFi{
            //print("Ready to write Mac address")
            DispatchQueue.main.asyncAfter(deadline: .now()) {[weak self] in
                if let ssid = self?.wifiManager.getConnectedWifiMacAddress(){
                            
                            NotificationCenter.default.post(
                                name: Notification.Name("updateNetworkName"),
                                object: nil,
                                userInfo: ["name":ssid.1,"bssid":ssid.0]
                            )
                        }
                    }
                }
            }
}
