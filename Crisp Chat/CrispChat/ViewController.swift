//
//  ViewController.swift
//  CrispChat
//
//  Created by Ongraph on 26/10/21.
//

import UIKit
import Crisp

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func btnChatAction(_ sender: Any) {
        self.present(ChatViewController(), animated: true)
        

    }
    
}

