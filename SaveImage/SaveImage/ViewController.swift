//
//  ViewController.swift
//  SaveImage
//
//  Created by Amit Chauhan on 17/06/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    @IBAction func saveImage(_ sender: Any) {
//        let url = URL(string: "https://meeturfriends.s3.amazonaws.com/uploads/user/1153/posts/1255/image0_1622809808.png")
//
        
        
        let img = UIImage.init(named: "Icon-60@2x.png")
        SaveService.saveImage(img!) { error in
            if let error = error {
                print("Save image error", error.localizedDescription)
//                switch error {
//                case .accessDenied : self.showAllowAccessMessage()
//                case .unknown : self.showSaveErrorMessage()
//                }
            } else {
                print("Save image Success")

//                self.showSaveCompleteMessage()
            }
        }
    }
    
    
    @IBAction func saveVideo(_ sender: Any) {
        
//        let url = URL(string: "https://meeturfriends.s3.amazonaws.com/uploads/user/20/posts/1320/image1623727629833_1623727647.mp4")
        
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

