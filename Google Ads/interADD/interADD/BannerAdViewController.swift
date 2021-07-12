//
//  BannerAdViewController.swift
//  interADD
//
//  Created by Rehan Muqeem on 03/06/21.
//

import UIKit
import GoogleMobileAds

class BannerAdViewController: UIViewController {
    
    
/// Description: this callBack variable is used to load interstitial when this controller is `popped`.
    var callBack: (() -> ())?
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bannerView.adUnitID = "ca-app-pub-3940256099942544/6300978111"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
///when you want to use delegate methods for extra functionality of banner view then use `bannerView.delegate = self`
        bannerView.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.callBack?()
    }
    
    
    @IBAction func btn_Back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

    // MARK: - BANNER ADS DELEGATE

///Each of the methods in GADViewDelegate is marked as optional, so you only need to implement the methods you want. This example implements each method and logs a message to the console.

//GAMBannerViewDelegate method  :       iOS method
//bannerViewWillPresentScreen   :       UIViewController's viewWillDisappear:
//bannerViewWillDismissScreen   :       UIViewController's viewWillAppear:
//bannerViewDidDismissScreen    :       UIViewController's viewDidAppear:

extension BannerAdViewController: GADBannerViewDelegate {
    
//You can also use the bannerViewDidReceiveAd: event to animate a banner ad once it's returned
    
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.alpha = 0
        GAMBannerView.animate(withDuration: 3, animations: {
            bannerView.alpha = 1
        })
        print(">>>>>>>>     bannerViewDidReceiveAd")
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
        print(">>>>>>>      bannerViewDidRecordImpression")
    }
    
    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
        print(">>>>>>>      bannerViewWillPresentScreen")
    }
    
    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
        print(">>>>>>>      bannerViewWillDIsmissScreen")
    }
    
    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
        print(">>>>>>>      bannerViewDidDismissScreen")
    }
}
