//
//  AppDelegate.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 8/5/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import UIKit
import SideMenu
import GoogleSignIn
import Stripe
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("User has not signed in before or they have since signed out")
            } else {
                print("\(error.localizedDescription)")
            }
            NotificationCenter.default.post(name: Notification.Name(rawValue: "ToggleAuthUINotification"), object: nil, userInfo: nil)
            return
        }
        let userId = user.userID
        let idToken = user.authentication.idToken
        let email = user.profile.email
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "ToggleAuthUINotification"), object: nil, userInfo: ["statusText": "Signed in with email \n \(email!)"])
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "ToggleAuthUINotification"), object: nil, userInfo: ["statusText": "User has disconnected."])
    }

    var window: UIWindow?
   

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GIDSignIn.sharedInstance()?.clientID = "659271946310-ab43ccokoq7uijrd53rgcojp0o07n9ch.apps.googleusercontent.com"
        GIDSignIn.sharedInstance()?.delegate = self
        Stripe.setDefaultPublishableKey(Bundle.main.infoDictionary!["STRIPE_PUBLISHABLE_KEY"] as! String)
        IQKeyboardManager.shared.enable = true
        return true
    }

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
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func userHasSuccesfullySignedIn() {
        var view: UIViewController?
        
        view = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserRootView")
        self.window?.rootViewController = view
        self.window?.makeKeyAndVisible()
    }
    
    func showCreateSessionFlow() {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyBoard.instantiateViewController(withIdentifier: "InitialNavigationController") as! UINavigationController
        view.modalPresentationStyle = .fullScreen
        
        self.window?.rootViewController = view
        self.window?.makeKeyAndVisible()
    }
}

