//
//  CompanionViewController.swift
//  interADD
//
//  Created by Rehan Muqeem on 02/06/21.
//

import UIKit
import AVFoundation
import GoogleInteractiveMediaAds

class CompanionViewController: UIViewController {
    
/// Description: this callBack variable is used to load interstitial when this controller is `popped`.
    var callBack: (() -> ())?
    var adPlayOnlyOnce = true
    
    var adsLoader: IMAAdsLoader!
    var adsManager: IMAAdsManager!
    
    @IBOutlet weak var btnAdsPlayPause: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var adView: UIView!
    
    static let contentURLString = "https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3"
    static let AdTagURLString = "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/single_ad_samples&ciu_szs=300x250&impl=s&gdfp_req=1&env=vp&output=vast&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ct%3Dlinear&correlator="
    var playerViewController: AVPlayerViewController!
    var contentPlayhead: IMAAVPlayerContentPlayhead!
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.startAnimating()
        self.setUpContentPlayer()
        self.setUpAdsLoader()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
// load the requestAds() Either with a performSelector or load it in viewDidAppear(). Otherwise it will not load.
        self.perform(#selector(self.playAds), with: nil, afterDelay: 1.0)
    }
    
    @objc func playAds(){
        self.requestAds()
    }
    
/// in viewWillDisappear the `callBack` is only to present the interstitial ad.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.callBack?()
    }
    
/// - Description : Implement content playhead tracker and end-of-stream observer
    func setUpContentPlayer() {
// Load AVPlayer with path to your content.
        guard let contentURL = URL(string: CompanionViewController.contentURLString) else {
            print(">>>>>>> ERROR: please use a valid URL for the content URL")
            return
        }
        let player = AVPlayer(url: contentURL)
        playerViewController = AVPlayerViewController()
        playerViewController.player = player
        
// Set up your content playhead and contentComplete callback.
        contentPlayhead = IMAAVPlayerContentPlayhead(avPlayer: player)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.contentDidFinishPlaying(_:)),
            name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
            object: player.currentItem
        );
        
    }
    
    @objc func contentDidFinishPlaying(_ notification: Notification) {
// Make sure we don't call contentComplete as a result of an ad completing.
        adsLoader.contentComplete()
    }
    
    func setUpAdsLoader() {
        adsLoader = IMAAdsLoader(settings: nil)
        adsLoader.delegate = self
    }
    
/// - Description : Initialize the ads loader and make an ads request
    func requestAds() {
/// Create ad display container for ad rendering. You can change the adContainer by any custom view so that ad wiil be rendered in that view.
        let adDisplayContainer = IMAAdDisplayContainer(
            adContainer: adView, viewController: self, companionSlots: nil)
// Create an ad request with our ad tag, display container, and optional user context.
        let request = IMAAdsRequest(
            adTagUrl: CompanionViewController.AdTagURLString,
            adDisplayContainer: adDisplayContainer,
            contentPlayhead: contentPlayhead,
            userContext: nil)
        
        adsLoader.requestAds(with: request)
    }
    
    @IBAction func btn_Back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnPlayAndPauseTapped(_ sender: UIButton) {
        if (!sender.isSelected) {
            playerViewController.player?.pause()
        }
        else {
            playerViewController.player?.play()
        }
        sender.isSelected = !sender.isSelected
    }
}



    // MARK: - COMPANION ADS DELEGATE

extension CompanionViewController : IMAAdsLoaderDelegate, IMAAdsManagerDelegate {
    // MARK: - IMAAdsLoaderDelegate
    
    /// Description
    /// - Parameters:
    ///   - loader: the IMAAdsLoader that received the loaded ad data
    ///   - adsLoadedData: the IMAAdsLoadedData instance containing ad data
    func adsLoader(_ loader: IMAAdsLoader!, adsLoadedWith adsLoadedData: IMAAdsLoadedData!) {
// Grab the instance of the IMAAdsManager and set yourself as the delegate.
        adsManager = adsLoadedData.adsManager
        adsManager.delegate = self
        adsManager.initialize(with: nil)
    }
    
    /// Description
    /// - Parameters:
    ///   - loader: the IMAAdsLoader that received the error
    ///   - adErrorData: the IMAAdLoadingErrorData instance with error information
    func adsLoader(_ loader: IMAAdsLoader!, failedWith adErrorData: IMAAdLoadingErrorData!) {
        print(">>>>>> Error loading ads: " + adErrorData.adError.message)
        playerViewController.player?.play()
    }
    
    // MARK: - IMAAdsManagerDelegate
    
    /// Description
    /// - Parameters:
    ///   - adsManager: the IMAAdsManager receiving the event
    ///   - event: the IMAAdEvent received
    func adsManager(_ adsManager: IMAAdsManager!, didReceive event: IMAAdEvent!) {
// Play each ad once it has been loaded...  Check for all events for customizing adrendering
        if event.type == IMAAdEventType.LOADED {
            self.adView.isHidden = false
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
// When the SDK notifies us that ads have been loaded, play them.
            adsManager.start()
        }
        if event.type == IMAAdEventType.COMPLETE {
            print("didReceive COMPLETE")
            self.adView.isHidden = true
            self.btnAdsPlayPause.isHidden = false
        }
        if event.type == IMAAdEventType.AD_BREAK_ENDED{
            print("didReceive AD_BREAK_ENDED")
        }
        if event.type == IMAAdEventType.AD_BREAK_FETCH_ERROR{
            print("didReceive AD_BREAK_FETCH_ERROR")
        }
        if event.type == IMAAdEventType.AD_BREAK_READY{
            print("didReceive AD_BREAK_READY")
        }
        if event.type == IMAAdEventType.AD_BREAK_STARTED{
            print("didReceive AD_BREAK_STARTED")
        }
        if event.type == IMAAdEventType.AD_PERIOD_ENDED{
            print("didReceive AD_PERIOD_ENDED")
        }
        if event.type == IMAAdEventType.AD_PERIOD_STARTED{
            print("didReceive AD_PERIOD_STARTED")
        }
        if event.type == IMAAdEventType.ALL_ADS_COMPLETED{
            print("didReceive ALL_ADS_COMPLETED")
        }
        if event.type == IMAAdEventType.CLICKED{
            print("didReceive CLICKED")
        }
        if event.type == IMAAdEventType.CUEPOINTS_CHANGED{
            print("didReceive CUEPOINTS_CHANGED")
        }
        if event.type == IMAAdEventType.FIRST_QUARTILE{
            print("didReceive FIRST_QUARTILE")
        }
        if event.type == IMAAdEventType.ICON_FALLBACK_IMAGE_CLOSED{
            print("didReceive ICON_FALLBACK_IMAGE_CLOSED")
        }
        if event.type == IMAAdEventType.ICON_TAPPED{
            print("didReceive ICON_TAPPED")
        }
        if event.type == IMAAdEventType.LOG{
            print("didReceive LOG")
        }
        if event.type == IMAAdEventType.MIDPOINT{
            print("didReceive MIDPOINT")
        }
        if event.type == IMAAdEventType.PAUSE{
            print("didReceive PAUSE")
        }
        if event.type == IMAAdEventType.RESUME{
            print("didReceive RESUME")
        }
        if event.type == IMAAdEventType.SKIPPED{
            print("didReceive SKIPPED")
        }
        if event.type == IMAAdEventType.STARTED{
            print("didReceive STARTED")
        }
        if event.type == IMAAdEventType.STREAM_LOADED{
            print("didReceive STREAM_LOADED")
        }
        if event.type == IMAAdEventType.STREAM_STARTED{
            print("didReceive STREAM_STARTED")
        }
        if event.type == IMAAdEventType.TAPPED{
            print("didReceive TAPPED")
        }
        if event.type == IMAAdEventType.THIRD_QUARTILE{
            print("didReceive THIRD_QUARTILE")
        }
    }
    
    // MARK: - Handling errors
// Add a handler for ad errors as well. If an error occurs, like in the previous step, resume content playback.
    
    /// Description
    /// - Parameters:
    ///   - error: the IMAAdError received
    func adsManager(_ adsManager: IMAAdsManager!, didReceive error: IMAAdError!) {
        // Fall back to playing content
        print(">>>>>>>> AdsManager error: " + error.message)
        playerViewController.player?.play()
    }
    
    // MARK: - Triggering play and pause events
    
    func adsManagerDidRequestContentPause(_ adsManager: IMAAdsManager!) {
// Pause the content for the SDK to play ads.
        playerViewController.player?.pause()
    }
    
    func adsManagerDidRequestContentResume(_ adsManager: IMAAdsManager!) {
// Resume the content since the SDK is done playing ads (at least for now).
        playerViewController.player?.play()
    }
    
    // MARK: - Called every 200ms to provide time updates for the current ad.
    
    /// Description
    /// - Parameters:
    ///   - adsManager: the IMAAdsManager tracking ad playback
    ///   - mediaTime: mediaTime descriptionthe current media time in seconds
    ///   - totalTime: the total media length in seconds
    func adsManager(_ adsManager: IMAAdsManager!, adDidProgressToTime mediaTime: TimeInterval, totalTime: TimeInterval) {
        
    }
    
    // MARK: - Called when the ad is playing to give updates about ad progress.
    
    /// Description
    /// - Parameters:
    ///   - streamManager: the IMAStreamManager tracking ad playback
    ///   - time: the current ad playback time in seconds
    ///   - adDuration: the total duration of the current ad in seconds
    ///   - adPosition: the ad position of the current ad in the current ad break
    ///   - totalAds: the total number of ads in the current ad break
    ///   - adBreakDuration: the total duration of the current ad break in seconds
    ///   - adPeriodDuration: the total duration of the current ad period in seconds. This includes ads duration plus slate.
    func streamManager(_ streamManager: IMAStreamManager!, adDidProgressToTime time: TimeInterval, adDuration: TimeInterval, adPosition: Int, totalAds: Int, adBreakDuration: TimeInterval, adPeriodDuration: TimeInterval) {
        
    }

}
