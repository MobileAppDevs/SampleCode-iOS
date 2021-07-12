//
//  AppDelegate.swift
//  ChatDemo
//
//  Created by Amit Chauhan on 22/04/20.
//  Copyright © 2020 Amit Chauhan. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import GoogleMaps
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window : UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
                FirebaseApp.configure()
        //        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
        //        GIDSignIn.sharedInstance()?.delegate = self
                Messaging.messaging().delegate = self
                Messaging.messaging().isAutoInitEnabled = true

                GMSServices.provideAPIKey(Constants.GOOGLE_API_KEY)

                /*let firebaseAuth = Auth.auth()
                do {
                  try firebaseAuth.signOut()
                } catch let signOutError as NSError {
                  print ("Error signing out: %@", signOutError)
                }*/
                
                let user = Auth.auth().currentUser
                if user?.uid == nil {
                //Show Login Screen
                    self.openLoginScreen()
                } else {
                //Show content
                    self.openHomeScreen()
                }
                
                
               /*let firebaseAuth = Auth.auth()
                do {
                  try firebaseAuth.signOut()
                } catch let signOutError as NSError {
                  print ("Error signing out: %@", signOutError)
                }*/

        
        
        return true
    }

    func openLoginScreen(){
        let navigationController: UINavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! UINavigationController
        let rootViewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
        navigationController.viewControllers = [rootViewController]
        navigationController.navigationBar.isHidden = true
        UIApplication.shared.windows.first?.rootViewController = navigationController
    }
    
    func openHomeScreen(){
        let navigationController: UINavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! UINavigationController
        let rootViewController: HomeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        navigationController.viewControllers = [rootViewController]
        navigationController.navigationBar.isHidden = true
        UIApplication.shared.windows.first?.rootViewController = navigationController
    }

    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
        -> Bool {
            return GIDSignIn.sharedInstance().handle(url)
    }

    // MARK: UIApplication Lifecycle
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        //        manageUserSessionState()
        
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

extension AppDelegate: MessagingDelegate{
func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {

    print("---------------------------------------")
    print("fcmToken===\(fcmToken)")
    print("---------------------------------------")
    
}
}

