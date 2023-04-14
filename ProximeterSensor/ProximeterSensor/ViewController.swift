//
//  ViewController.swift
//  ProximeterSensor
//
//  Created by Amit on 23/08/22.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.activateProximitySensor()
        // Do any additional setup after loading the view.
    }

    func activateProximitySensor() {
        let device = UIDevice.current
        device.isProximityMonitoringEnabled = true
        if device.isProximityMonitoringEnabled {
            let notificationName = Notification.Name(rawValue: "UIDeviceProximityStateDidChangeNotification")
            NotificationCenter.default.addObserver(self, selector: #selector(proximityChanged), name: notificationName, object: nil)
        }
    }
    
    @objc func proximityChanged(notification: NSNotification) {
        let device = notification.object as? UIDevice
        if device?.proximityState == true {
            print("\(device) detected!")
            toggleTorch(on: true)
        } else {
            toggleTorch(on: false)
        }
    }

    func toggleTorch(on: Bool) {
        let device = AVCaptureDevice.default(for: AVMediaType.video)
        if ((device?.hasTorch) != nil) {
            do {
                try device?.lockForConfiguration()
                if on == true {
                    device?.torchMode = .on
                } else {
                    device?.torchMode = .off
                }
                device?.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is not available")
        }
    }

}

