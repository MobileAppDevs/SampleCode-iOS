//
//  VideoPlayerVCViewController.swift
//  VideoPlayerWithPIPMode
//
//  Created by Ongraph Technologies on 11/07/22.
//

import UIKit
import AVKit
import AVFoundation


class VideoPlayerVCViewController: UIViewController, AVPictureInPictureControllerDelegate {

    @IBOutlet weak var viewForVideoPlayer: UIView!
    let url = URL(string:"http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4")
    var playerAV = AVPlayer()
    let vc = AVPlayerViewController()
    var pip  : AVPictureInPictureController!
    override func viewDidLoad() {
        super.viewDidLoad()
        playerAV = AVPlayer(url: url! as URL)
        let playerLayerAV = AVPlayerLayer(player: playerAV)
        playerLayerAV.frame = self.viewForVideoPlayer.bounds
        playerLayerAV.videoGravity = .resizeAspectFill
        
//        self.viewForVideoPlayer.layer.addSublayer(playerLayerAV)
//        playerAV.play()
//        pip = AVPictureInPictureController(playerLayer: playerLayerAV)
//        playerLayerAV.isHidden =  true
        vc.player = playerAV
//        present(vc, animated: true) {
//            vc.player?.play()
//        }
        vc.player?.play()

        self.addChild(vc)
        vc.allowsPictureInPicturePlayback = true
      //  NotificationCenter.default.addObserver(self, selector: #selector(self.didfinishPlaying(note:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerAV.currentItem)
        vc.didMove(toParent: self)
        vc.view?.frame = self.viewForVideoPlayer.bounds
        viewForVideoPlayer.insertSubview(vc.view, belowSubview: self.viewForVideoPlayer)
        if #available(iOS 14.2, *) {
            vc.canStartPictureInPictureAutomaticallyFromInline = true
        }
        if #available(iOS 13.0, *) {
            vc.showsTimecodes = true
        }
//        let piplayer  =  AVPlayerLayer(player: vc.player)
//         pip = AVPictureInPictureController(playerLayer: piplayer)
//     //   pip = AVPictureInPictureController(playerLayer: playerLayerAV)
//        pip.delegate = self

    }
    
    
    @IBAction func backBTN(_ sender: Any) {
        if (playerAV.rate != 0 && playerAV.error == nil) {
           
             }
        
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func didfinishPlaying(note : NSNotification)  {
           
           let alertView = UIAlertController(title: "Finished", message: "Video finished", preferredStyle: .alert)
           alertView.addAction(UIAlertAction(title: "Okey", style: .default, handler: nil))
           self.present(alertView, animated: true, completion: nil)
    }
    
    func playerViewController(_ playerViewController: AVPlayerViewController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
            
        let currentviewController = self.navigationController?.visibleViewController
            
            if currentviewController != playerViewController{
                
                currentviewController?.present(playerViewController, animated: true, completion: nil)
            }
        }
}

extension VideoPlayerVCViewController {
    
    

    func pictureInPictureControllerWillStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        print("pictureInPictureControllerWillStartPictureInPicture")
    }

    public func pictureInPictureControllerDidStartPictureInPicture(
        _ pictureInPictureController: AVPictureInPictureController
    ) {
        print("pictureInPictureControllerDidStartPictureInPicture")
    }

    func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
        print("pictureInPictureController") // when back to normal videw
        pictureInPictureController.stopPictureInPicture()
        topMostController()?.navigationController?.popViewController(animated: false)
    }

    func pictureInPictureControllerWillStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        print("pictureInPictureControllerWillStopPictureInPicture")


    }

    func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, failedToStartPictureInPictureWithError error: Error){
        print("failedToStartPictureInPictureWithError ==== \(error.localizedDescription)")
    }
    
    
    func topMostController() -> UIViewController? {
        guard let window = UIApplication.shared.keyWindow, let rootViewController = window.rootViewController else {
            return nil
        }

        var topController = rootViewController

        while let newTopController = topController.presentedViewController {
            topController = newTopController
        }

        return topController
    }
}

