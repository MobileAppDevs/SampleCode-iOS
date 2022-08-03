//
//  ViewController.swift
//  RTMP Player
//
//  Created by Ongraph on 29/09/21.
//

import UIKit

class ViewController: UIViewController {

    var player: IJKFFMoviePlayerController!
    var timer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)

        // Do any additional setup after loading the view.
    }

    

    override func viewDidDisappear(_ animated: Bool) {
        self.timer.invalidate()
    }

    @objc func timerAction(){
        self.setUpPlayer()
        }

    func setUpPlayer(){
        
        let urlString = "Your RTMP URL"
        player = IJKFFMoviePlayerController(contentURLString: urlString, with: IJKFFOptions.byDefault())  //contetURLStrint helps you making a complete stream at rooms with special characters.
        
        player.liveOpenDelegate = self
        player.nativeInvokeDelegate = self
        player.tcpOpenDelegate = self
        
        player.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        player.view.frame = self.view.bounds
        self.view.addSubview(player.view)

        player.prepareToPlay()
    }
}

extension ViewController : IJKMediaUrlOpenDelegate {
    func willOpenUrl(_ urlOpenData: IJKMediaUrlOpenData!) {
        print("bhavya >> willOpenUrl" )
    }
}

extension ViewController : IJKMediaNativeInvokeDelegate{
    func invoke(_ event: IJKMediaEvent, attributes: [AnyHashable : Any]! = [:]) -> Int32 {
        print("bhavya >> attributes" )
        
        return Int32(event.rawValue)
    }
    
}
