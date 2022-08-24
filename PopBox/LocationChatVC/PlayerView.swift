//
//  PlayerView.swift
//  PopboxChat
//
//  Created by Ashish Sharma on 12/8/17.
//  Copyright © 2017 Noto. All rights reserved.
//

import UIKit

import UIKit
import AVKit;
import AVFoundation;

class PlayerView: UIView {
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self;
    }
    
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer;
    }
    
    var player: AVPlayer? {
        get {
            return playerLayer.player;
        }
        set {
            playerLayer.player = newValue;
        }
    }
}
