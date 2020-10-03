//
//  CustomAppDelegate.swift
//  QFamilyApp14
//
//  Created by Matthew Schmulen on 10/3/20.
//

import SwiftUI
import FamilyKit
import CloudKit

class CustomAppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // configure push notification
        // TODO: this needs to be moved to onboarding
        // ------------------------------------------------------------
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
        //UNUserNotificationCenter.current().delegate = self
        // ------------------------------------------------------------
        return true
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        //let dict = userInfo as! [String : NSObject]
        //print( "didReceiveRemoteNotification userInfo:\(userInfo)")
        // THIS IS FOR SILENT PUSH ?
        if let notification = CKQueryNotification(fromRemoteNotificationDictionary: userInfo) {
            
            // TODO: hande specific notifications
            print( "HANDLE SPECIFIC STORE NOTIFCATIONS")
            
            print( "userInfo \(userInfo)")
            
            print( "\(notification.recordFields)" )
            
            //            userInfo [AnyHashable("ck"): {
            //                ce = 2;
            //                cid = "iCloud.com.jumptack.FamilyKit";
            //                ckuserid = "_50125824373cb9a38c4142e6c601eb14";
            //                nid = "c18c8006-e1e4-4870-9cc4-e118c97dffcc";
            //                qry =     {
            //                    dbs = 1;
            //                    fo = 1;
            //                    rid = "F339154A-3AE0-45C1-9191-78620DAF3458";
            //                    sid = "E5F7E902-C020-4F9F-9E7D-13E53B4D4615";
            //                    zid = "_defaultZone";
            //                    zoid = "_50125824373cb9a38c4142e6c601eb14";
            //                };
            //            }, AnyHashable("aps"): {
            //                "content-available" = 1;
            //            }]
            
            CKPrivateModelService<CKActivityDescriptionModel>.notificationReceive( notification: notification)
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
    }
    
    func application(_ application: UIApplication, userDidAcceptCloudKitShareWith cloudKitShareMetadata: CKShare.Metadata) {
        let acceptShareOperation: CKAcceptSharesOperation =
            CKAcceptSharesOperation(shareMetadatas:
                                        [cloudKitShareMetadata])
        
        acceptShareOperation.qualityOfService = .userInteractive
        acceptShareOperation.perShareCompletionBlock = {meta, share,
                                                        error in
            print("userDidAcceptCloudKitShareWith share was accepted")
        }
        acceptShareOperation.acceptSharesCompletionBlock = {
            error in
            print( "error userDidAcceptCloudKitShareWith. error \(String(describing: error))")
            /// Send your user to where they need to go in your app
        }
        fatalError("TODO: userDidAcceptCloudKitShareWith needs to be implimented")
    }
}




