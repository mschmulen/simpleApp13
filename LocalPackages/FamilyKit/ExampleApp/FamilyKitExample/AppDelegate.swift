//
//  AppDelegate.swift
//  FamilyKitExample
//
//  Created by Matthew Schmulen on 7/31/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import UIKit
import CloudKit
import FamilyKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // ------------------------------------------------------------
        // configure push notification
        // TODO this needs to be moved to onboarding
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (authorized, error) in
            print( "requestAuthorization \(authorized) ")
            print( "requestAuthorization \(String(describing: error)) ")
            
            if authorized {
                DispatchQueue.main.async {
                    print( "registerForRemoteNotifications")
                    application.registerForRemoteNotifications()
                }
            }
        }
        UNUserNotificationCenter.current().delegate = self
        // ------------------------------------------------------------
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

extension AppDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print( "didRegisterForRemoteNotificationsWithDeviceToken token \(deviceToken)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print( "didFailToRegisterForRemoteNotificationsWithError \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        //let dict = userInfo as! [String : NSObject]
        print( "didReceiveRemoteNotification userInfo:\(userInfo)")
        
        if let notification = CKQueryNotification(fromRemoteNotificationDictionary: userInfo) {
            
            print( "HANDLE SPECIFIC STORE NOTIFCATIONS")
            CKPublicModelService<CKChoreModel>.notificationReceive( notification: notification)
            if notification.queryNotificationReason == .recordCreated {
                print( ".recordCreated")
                // ContentView().fetchRecord(record: (notification?.recordID)!)
            }
            if notification.queryNotificationReason == .recordUpdated {
                print( ".recordUpdated")
                //later
            }
            if notification.queryNotificationReason == .recordDeleted {
                print( ".recordDeleted")
                //ContentView().deleteRecord(record: (notification?.recordID)!)
            }
        }
        
    }//end didReceiveRemoteNotification
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
        
        print("userNotificationCenter.willPresent notification")
        // show the notification alert (banner), and with sound
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("userNotificationCenter.willPresent didReceive")
        completionHandler()
    }
    
}

//extension AppDelegate : UNUserNotificationCenterDelegate {
//
//}
