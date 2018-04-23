//
//  AppDelegate.swift
//  Twitter_API
//
//  Created by Khasanza on 4/22/18.
//  Copyright © 2018 Khasanza. All rights reserved.
//

import UIKit
import TwitterKit
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let consumerKey = "f24oRg3jQc9IckEmVkcPAz9pT"
        let consumerSecret = "JsSQZyVA5psjEYlAWn9lhazroCxT5BNSc0YAWAAbDMGYIDIFBz"
        
        TWTRTwitter.sharedInstance().start(withConsumerKey: consumerKey, consumerSecret: consumerSecret)
        setupNavigationBarAppearence()
        isLoggedIn()

        return true
    }
    private func isLoggedIn() {
        if TWTRTwitter.sharedInstance().sessionStore.hasLoggedInUsers() {
            self.window?.rootViewController = Constants.Storyboard.MAIN_STORYBOARD.instantiateViewController(withIdentifier: Constants.ControllerId.MAIN_NAVIGATION_CONTROLLER)
        } else {
            self.window?.rootViewController = Constants.Storyboard.LOGIN_STORYBOARD.instantiateViewController(withIdentifier: Constants.ControllerId.LOGIN_CONTROLLER)
        }
    }
    private func setupNavigationBarAppearence() {
        UINavigationBar.appearance().tintColor = UIColor.init(netHex: Colors.MAIN_COLOR)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.init(netHex: Colors.MAIN_COLOR)]
//        UINavigationBar.appearance().isTranslucent = false
//        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
//        UINavigationBar.appearance().shadowImage = UIImage()
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
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return TWTRTwitter.sharedInstance().application(app, open: url, options: options)
    }

}

