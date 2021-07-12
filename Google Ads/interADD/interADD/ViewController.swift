//
//  ViewController.swift
//  interADD
//
//  Created by Rehan Muqeem on 02/06/21.
//

import UIKit
import GoogleMobileAds

/// update info.plist according to google docs and add ` -ObjC` linker flag under Other Other Linker Flag in project build settings.

class ViewController: UIViewController {
    
    var interstitial: GADInterstitialAd?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInterstitial()
    }
    
// Description: Make request to load ads and present it on fullScreen using its delegate method.
// Description: To present interstitial ad, first load it and then fire it.
    fileprivate func loadInterstitial() {
        let request = GADRequest()
        GADInterstitialAd.load(
            withAdUnitID: "ca-app-pub-3940256099942544/4411468910", request: request
        ) { (ad, error) in
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            self.interstitial = ad
            self.interstitial?.fullScreenContentDelegate = self
        }
    }
    
    @IBAction func btnBannnerAdsTapped(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "BannerAdViewController") as! BannerAdViewController
/// in first attempt it will not use `callBack` bcoz its called from the viewWillDisappear() of the next controller.
        vc.callBack = { [weak self]  in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self?.bannerViewControllerDidPopped()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btncompanionAdTapped(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "CompanionViewController") as! CompanionViewController
        vc.callBack = {[weak self]  in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self?.bannerViewControllerDidPopped()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func bannerViewControllerDidPopped() {
        DispatchQueue.main.async {
            self.loadInterstitial()
            if self.interstitial != nil {
                self.interstitial!.present(fromRootViewController: self)
            } else {
                print("Ad wasn't ready")
            }
        }
    }
}


/// `GADInterstitialAd` is a one-time-use object. This means that once an interstitial ad is shown, it cannot be shown again. A best practice is to load another interstitial ad in the `adDidDismissFullScreenContent:` method on `GADFullScreenContentDelegate` so that the next interstitial ad starts loading as soon as the previous one is dismissed.

    // MARK: - INTERSTITIAL ADS DELEGATE
    // MARK: - GADFullScreenContentDelegate

extension ViewController: GADFullScreenContentDelegate {
    /// Tells the delegate that the ad failed to present full screen content.
     func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
       print("Ad did fail to present full screen content with error \(error.localizedDescription)..")
     }

     /// Tells the delegate that the ad presented full screen content.
     func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
       print("Ad did present full screen content.")
     }

     /// Tells the delegate that the ad dismissed full screen content.
     func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
       print("Ad did dismiss full screen content.")
     }
}

