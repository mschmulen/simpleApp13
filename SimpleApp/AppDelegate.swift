//
//  AppDelegate.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 7/19/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import UIKit
import FamilyKit
import CloudKit
//import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    public var appState = AppState()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // ------------------------------------------------------------
        // configure push notification
        // TODO: this needs to be moved to onboarding
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

    // MARK: - Core Data stack

//    lazy var persistentContainer: NSPersistentCloudKitContainer = {
//        /*
//         The persistent container for the application. This implementation
//         creates and returns a container, having loaded the store for the
//         application to it. This property is optional since there are legitimate
//         error conditions that could cause the creation of the store to fail.
//        */
//        let container = NSPersistentCloudKitContainer(name: "SimpleApp")
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//
//                /*
//                 Typical reasons for an error here include:
//                 * The parent directory does not exist, cannot be created, or disallows writing.
//                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
//                 * The device is out of space.
//                 * The store could not be migrated to the current model version.
//                 Check the error message to determine what the actual problem was.
//                 */
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        return container
//    }()
//
//    // MARK: - Core Data Saving support
//
//    func saveContext () {
//        let context = persistentContainer.viewContext
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//        }
//    }
}

extension AppDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print( "didRegisterForRemoteNotificationsWithDeviceToken token \(deviceToken)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print( "didFailToRegisterForRemoteNotificationsWithError \(error)")
    }
    
    // this is specific to silent notifications
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
        
    }//end didReceiveRemoteNotification
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("userNotificationCenter.willPresent notification \(notification)")
        
        let userInfo = notification.request.content.userInfo
        print( "userInfo: \(userInfo)")
        
//        userInfo: [AnyHashable("ck"): {
//            ce = 2;
//            cid = "iCloud.com.jumptack.FamilyKit";
//            ckuserid = "_50125824373cb9a38c4142e6c601eb14";
//            nid = "3180cf65-1c66-4bfa-9226-e1f02160ead0";
//            qry =     {
//                af =         {
//                    ownerEmoji = "\Ud83d\Udc26";
//                    ownerName = Jay;
//                    sessionReferenceID = "63E9CC48-4EAD-4E0F-92CC-16274352E82A";
//                };
//                dbs = 1;
//                fo = 1;
//                rid = "94D8C5DB-33DD-4D71-8A4D-7F2AC7F104CD";
//                sid = "857D15A1-13F9-4C81-AC54-9C5154B5532B";
//                zid = "_defaultZone";
//                zoid = "_50125824373cb9a38c4142e6c601eb14";
//            };
//        }, AnyHashable("aps"): {
//            alert =     {
//                body = "Family Chat Message";
//                title = "Family Chat";
//            };
//            sound = default;
//        }]
        
        if let queryNotification = CKQueryNotification(fromRemoteNotificationDictionary: userInfo) {
            print( "digested by a CKQueryNotification")
            print( "notification \(notification)")
            
            let recordFields = queryNotification.recordFields
            print( "recordFields \(recordFields)")
            
            //notification.request.content.subtitle = "yack"
            
            //recordFields Optional(["ownerName": Jay, "sessionReferenceID": B790B4D8-2011-4E89-B534-1A47DD057767, "ownerEmoji": 🐦])
            
        }
        
        // show the notification alert (banner), and with sound
        completionHandler([.alert, .sound, .badge])
    }
    
    // User did tap the notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("userNotificationCenter.willPresent didReceive")
        
        let userInfo = response.notification.request.content.userInfo
        print( "title: \(response.notification.request.content.title)")
        print( "subtitle: \(response.notification.request.content.subtitle)")
        print( "body: \(response.notification.request.content.body)")
        
        print( "userInfo: \(userInfo)")
        if let ckNotification = CKNotification(fromRemoteNotificationDictionary: userInfo ) {
            
             if let ckQueryNotification = CKQueryNotification(fromRemoteNotificationDictionary: userInfo) {
                if let recordID = ckQueryNotification.recordID {
                    let recordName = recordID.recordName
                    print("recordName \(recordName)")
                    // TODO Its possible to fetch it and get if from the record Type
                }
                
                if let recordFields = ckQueryNotification.recordFields {
                    if let ownerEmoji = recordFields["ownerEmoji"] as? String ,
                        let ownerName = recordFields["ownerName"] as? String,
                        let sessionReferenceID = recordFields["sessionReferenceID"] as? String {
                        print( "\(ownerEmoji) \(ownerName) \(sessionReferenceID)")
                        presentView(with: userInfo)
                    }
                    print( "recordFields \(recordFields)")
                }
            }
        }
//        userNotificationCenter.willPresent didReceive
//        title: TITLE XXX
//        subtitle: SUBTITILE YYY
//        body: Family Chat was created
//        userInfo: [AnyHashable("ck"): {
//            ce = 2;
//            cid = "iCloud.com.jumptack.FamilyKit";
//            ckuserid = "_50125824373cb9a38c4142e6c601eb14";
//            nid = "44f3a9f0-bcc6-4913-834c-28014e97bea1";
//            qry =     {
//                dbs = 1;
//                fo = 1;
//                rid = "1C63E533-24E9-4B99-9317-28F895308868";
//                sid = "314C3886-0EB9-4B78-A2EA-CD74D8739225";
//                zid = "_defaultZone";
//                zoid = "_50125824373cb9a38c4142e6c601eb14";
//            };
//        }, AnyHashable("aps"): {
//            alert =     {
//                body = "Family Chat was created";
//                subtitle = "SUBTITILE YYY";
//                title = "TITLE XXX";
//            };
//            sound = default;
//        }]
        
        completionHandler()
    }
    
    func fetchTypeByRecordID( recordID: CKRecord.ID) -> String {
        return "YACK"
    }
}

extension AppDelegate {
    
    func presentView(with pushNotificationInfo: [AnyHashable: Any]) {
        print( "AppDelegate.presentView")
        print( "pushNotificationInfo: \(pushNotificationInfo)")
        
        self.appState.goToScreen(deepLink: .tabFamilyChat)
    }
    
//    AppDelegate.presentView
//    [AnyHashable("ck"): {
//        ce = 2;
//        cid = "iCloud.com.jumptack.FamilyKit";
//        ckuserid = "_50125824373cb9a38c4142e6c601eb14";
//        nid = "66a1bfd5-4f7c-437f-b5ad-4bae0b71b4a0";
//        qry =     {
//            dbs = 1;
//            fo = 1;
//            rid = "C8FA4AC1-B27B-4448-BDFD-5CCB048D40ED";
//            sid = "AC91174C-55F0-49EA-ABA0-0D1B1796E273";
//            zid = "_defaultZone";
//            zoid = "_50125824373cb9a38c4142e6c601eb14";
//        };
//    }, AnyHashable("aps"): {
//        alert = "New Chat";
//        badge = 180;
//        sound = default;
//    }]
}


