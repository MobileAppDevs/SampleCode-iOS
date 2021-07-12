//
//  HomeVC.swift
//  ChatDemo
//
//  Created by Amit Chauhan on 22/04/20.
//  Copyright © 2020 Amit Chauhan. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import MapKit

class HomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK:- Button Action
    @IBAction func btn_userListAction(_ sender: Any) {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController( withIdentifier: "UserListVC") as! UserListVC
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func btn_recentMessageListAction(_ sender: Any) {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController( withIdentifier: "RecentMessageListVC") as! RecentMessageListVC
        self.navigationController?.pushViewController(viewController, animated: true)

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
