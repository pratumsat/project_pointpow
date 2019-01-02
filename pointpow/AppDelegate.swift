//
//  AppDelegate.swift
//  pointpow
//
//  Created by thanawat on 30/10/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//
import SDWebImage
import UIKit
import Firebase
import GoogleSignIn


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        DataController.sharedInstance.retrieveToken()
        
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font :  UIFont(name: Constant.Fonts.THAI_SANS_BOLD, size: Constant.Fonts.Size.TAB )!], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font :  UIFont(name: Constant.Fonts.THAI_SANS_BOLD, size: Constant.Fonts.Size.TAB )!], for: .selected)
        
        /* tabbar color */
        //UITabBar.appearance().barTintColor = UIColor.white
        /* selected tabbar image color*/
        UITabBar.appearance().tintColor = Constant.Colors.PRIMARY_COLOR
        
        /* Remove shadow image  change to image color navbar*/
        UITabBar.appearance().shadowImage = UIImage.colorForNavBar(color: UIColor.white)
        UITabBar.appearance().backgroundImage = UIImage.colorForNavBar(color: UIColor.white)
        // Override point for customization after application launch.
        return true
    }
    
    func getId(_ query:String) ->String?{
        guard let a2 = query.range(of: "&") else {return nil}
        
        let startKey = query.distance(from: query.startIndex, to: a2.upperBound)
        let endKey = query.distance(from: query.startIndex, to: query.endIndex)
        
        return query.substring(start: startKey, end: endKey)
    }
    
    func getKey(_ query:String) ->String?{
        guard let a2 = query.range(of: "&") else {return nil}
        
        let startKey = query.distance(from: query.startIndex, to: query.startIndex)
        let endKey = query.distance(from: query.startIndex, to: a2.lowerBound)
        
        return query.substring(start: startKey, end: endKey)
    }
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
        -> Bool {
            let urlScheme = url.scheme // URL_scheme
            let host = url.host
            
            print("HELLo SCHEME")
            
            if urlScheme == "pointpow" {
                if host  == "resetpassword" {
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constant.DefaultConstansts.RESET_PASSWORD), object: nil, userInfo: [:] as [String:AnyObject])
                }else if host == "emailverify" {
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constant.DefaultConstansts.VERIFI_EMAIL_REGISTER), object: nil, userInfo: [:] as [String:AnyObject])
                }
            }
            
            return GIDSignIn.sharedInstance().handle(url,sourceApplication:
                options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: [:])
    }
   
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            //let userInfo = ["error":error.localizedDescription]
            //NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constant.DefaultConstansts.NotificationGoogleSigInFailure), object: nil, userInfo: userInfo as [String:AnyObject])
            
            
            return
        }
        // Perform any operations on signed in user here.
        let userId = user.userID                  // For client-side use only!
        let idToken = user.authentication.idToken // Safe to send to the server
        let fullName = user.profile.name
        let givenName = user.profile.givenName
        let familyName = user.profile.familyName
        let email = user.profile.email
        
        let userInfo = ["userId":userId,
                        "idToken":idToken,
                        "fullName":fullName,
                        "givenName":givenName,
                        "familyName":familyName,
                        "email":email]
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constant.DefaultConstansts.NotificationGoogleSigInSuccess), object: nil, userInfo: userInfo as [String:AnyObject])
        
        
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
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


}

