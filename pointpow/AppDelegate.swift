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
import UserNotifications
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        DataController.sharedInstance.retrieveToken()
        
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        Messaging.messaging().delegate = self
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        
        /* segment control*/
        let segmentAttributes = [NSAttributedString.Key.font : UIFont(name: Constant.Fonts.THAI_SANS_BOLD, size: Constant.Fonts.Size.SEGMENT)! ]
        UISegmentedControl.appearance().setTitleTextAttributes(segmentAttributes, for: .normal)
        
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
                    if let dic = url.queryDictionary {
                        let token = dic["reset_token"] ?? "unknow"
                        let resetToken = DataController.sharedInstance.getResetPasswordToken()
                        
                        if resetToken == token {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constant.DefaultConstansts.RESET_PASSWORD), object: nil, userInfo: ["reset_token":token] as [String:AnyObject])  }
                    }
                    
                }else if host == "emailverify" {
                    
                    if let dic = url.queryDictionary {
                        let token = dic["token"] ?? "unknow"
                        let activateToken = DataController.sharedInstance.getActivateToken()
                       
                        if activateToken == token {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constant.DefaultConstansts.VERIFI_EMAIL_REGISTER), object: nil, userInfo: [:] as [String:AnyObject])
                        }
                    }
                    
                    
                }else if host == "resetpin" {
                    
                    if let dic = url.queryDictionary {
                        let token = dic["reset_pin_token"] ?? "unknow"
                        let activateToken = DataController.sharedInstance.getResetPinToken()
                        
                        
                        if activateToken == token {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constant.DefaultConstansts.RESET_PIN), object: nil, userInfo: [:] as [String:AnyObject])
                        }
                    }
                    
                    
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

    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        self.receiverData(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        self.receiverData(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    // [END receive_message]
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the FCM registration token.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        
        // With swizzling disabled you must set the APNs token here.
        // Messaging.messaging().apnsToken = deviceToken
    }
    func receiverData(_ userInfo:[AnyHashable:Any]){
        print(userInfo)
//        let id = userInfo["id"] as? String ?? "0"
//        let image_url = userInfo["image_url"] as? String ?? ""
//        let title = userInfo["title"] as? String ?? ""
//        let detail = userInfo["detail"] as? String ?? ""
//        let type = userInfo["type"] as? String ?? ""
//        let ref_id = userInfo["ref_id"] as? String ?? ""
//        let amount = userInfo["amount"] as? String ?? ""
//        let date = userInfo["date"] as? String ?? ""
//        let status = userInfo["status"] as? String ?? ""
        
//        let newNotiModel = NotificationStruct(id: id, image_url: image_url, title: title, detail: detail, type: type ,ref_id: ref_id, amount:amount, date:date, status: status)
//
//        DataController.sharedInstance.saveNotifiacationArrayOfObjectData(newNoti: newNotiModel)
        
    }

}

// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        self.receiverData(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        self.receiverData(userInfo)
        
        completionHandler()
    }
}
// [END ios_10_message_handling]

extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        //Token
       
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    // [END refresh_token]
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
    // [END ios_10_data_message]
}
