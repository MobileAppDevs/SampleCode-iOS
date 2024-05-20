//
//  ViewController.swift
//  VideoPlayerWithPIPMode
//
//  Created by Ongraph Technologies on 11/03/24.
//

import UIKit
import AVKit

class ViewController: UIViewController {

  
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func nextBTN(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VideoPlayerVCViewController") as! VideoPlayerVCViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}

