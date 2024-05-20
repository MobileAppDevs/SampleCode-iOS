//
//  ViewController.swift
//  SaveImage
//
//  Created by Amit Chauhan on 17/05/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    @IBAction func saveImage(_ sender: Any) {
//        let url = URL(string: "image url")
        
        let img = UIImage.init(named: "Icon-60@2x.png")
        SaveService.saveImage(img!) { error in
            if let error = error {
                print("Save image error", error.localizedDescription)
            } else {
                print("Save image Success")
            }
        }
    }
    
    
    @IBAction func saveVideo(_ sender: Any) {
        
//        let url = URL(string: "Video URL")
        
        let url = URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4")
        
//        let url = URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")

        
        SaveService.saveVideo(url!) { error in
            if let error = error {
                
                print("Save video error", error.localizedDescription)

//                switch error {
//
//                case .accessDenied : self.showAllowAccessMessage()
//                case .unknown : self.showSaveErrorMessage()
//                }
            } else {
                print("Save video Success")
//                self.showSaveCompleteMessage()
            }
        }

    }
    
    

}

