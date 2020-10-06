//
//  CustomNotificationCenterDelegate.swift
//  QFamilyApp14
//
//  Created by Matthew Schmulen on 10/3/20.
//

import SwiftUI
import FamilyKit
import CloudKit

class CustomNotificationCenterDelegate: NSObject {

    var appState: AppState
    
    init( appState: AppState) {
        self.appState = appState
    }
}

extension CustomNotificationCenterDelegate: UNUserNotificationCenterDelegate {
    
    // will show the notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("userNotificationCenter.willPresent notification \(notification)")
        
        let userInfo = notification.request.content.userInfo
        
        //print( "userInfo: \(userInfo)")
        print( "notification.request.content.categoryIdentifier: \(notification.request.content.categoryIdentifier)")
        
        if let notificationCategory = LocalNotificationCategory(rawValue: notification.request.content.categoryIdentifier) {
            switch notificationCategory {
            case .openBucksTab:
                completionHandler([.banner, .sound, .badge])
                return
            case .openChatTab:
                completionHandler([.banner, .sound, .badge])
                return
            case .openFamilyTab:
                completionHandler([.banner, .sound, .badge])
                return
            case .openYouTab:
                completionHandler([.banner, .sound, .badge])
                return
            case .deepLinkModalView:
                completionHandler([.banner, .sound, .badge])
                return
            }
        } else {
            if let queryNotification = CKQueryNotification(fromRemoteNotificationDictionary: userInfo) {
                print( "digested by a CKQueryNotification")
                print( "notification \(notification)")
                
                let recordFields = queryNotification.recordFields
                print( "recordFields \(String(describing: recordFields))")
                
                //notification.request.content.subtitle = "yack"
                
                //recordFields Optional(["ownerName": Jay, "sessionReferenceID": B790B4D8-2011-4E89-B534-1A47DD057767, "ownerEmoji": 🐦])
                
                completionHandler([.banner, .sound, .badge])
                return
            } else {
                completionHandler(UNNotificationPresentationOptions(rawValue:0))
                return
            }
        }
    }
    
    // User did tap the notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("userNotificationCenter.didReceive didReceive")
        
        let userInfo = response.notification.request.content.userInfo
        //        print( "title: \(response.notification.request.content.title)")
        //        print( "subtitle: \(response.notification.request.content.subtitle)")
        //        print( "body: \(response.notification.request.content.body)")
        //        print( "userInfo: \(userInfo)")
        
        //        switch response.actionIdentifier {
        ////        case NotificationActions.HighFive.rawValue:
        ////            print("High Five Delivered!")
        //        default:
        //            print( "response.actionIdentifier: \(response.actionIdentifier)")
        //            break
        //        }
        
        print( "response.actionIdentifier: \(response.actionIdentifier)")
        print( "categoryIdentifier: \(response.notification.request.content.categoryIdentifier)")
        
        // check for LocalNotification processing
        if let notificationCategory = LocalNotificationCategory(rawValue: response.notification.request.content.categoryIdentifier) {
            
            print( "notificationCategory \(notificationCategory)")
            
            // TODO: fix self.appState
            
            switch notificationCategory {
            case .openBucksTab:
                self.appState.goToScreen(deepLink: .tabBucks)
                completionHandler()
                return
            case .openChatTab:
                self.appState.goToScreen(deepLink: .tabFamilyChat)
                completionHandler()
                return
            case .openFamilyTab:
                let recordName = userInfo["RECORD_NAME"] as? String
                let recordType = userInfo["RECORD_TYPE"] as? String
                self.appState.goToScreen(deepLink: .tabFamily(recordName: recordName, recordType: recordType))
                completionHandler()
                return
            case .openYouTab:
                self.appState.goToScreen(deepLink: .tabYou)
                completionHandler()
                return
            case .deepLinkModalView:
                if let recordName = userInfo["RECORD_NAME"] as? String,
                   let recordType = userInfo["RECORD_TYPE"] as? String {
                    
                    self.appState.goToScreen(deepLink:
                                                .modalViewRecord(
                                                    recordName: recordName,
                                                    recordType: recordType
                                                )
                    )
                    completionHandler()
                } else {
                    print( "bad data")
                    completionHandler()
                }
            }//end switch
            
        } else {
            //if let ckNotification = CKNotification(fromRemoteNotificationDictionary: userInfo ) {
            if let ckQueryNotification = CKQueryNotification(fromRemoteNotificationDictionary: userInfo) {
                processCKQueryNotification( with: ckQueryNotification )
            }
            completionHandler()
        }
    }
}

extension CustomNotificationCenterDelegate {
    
    func processCKQueryNotification(with queryNotification: CKQueryNotification) {
        print( "AppDelegate.processNotification")
        print( "pushNotificationInfo: \(queryNotification)")
        if let recordID = queryNotification.recordID {
            let recordName = recordID.recordName
            print("recordName \(recordName)")
        }
        
        if let categoryString = queryNotification.category, let familyKitCategory = NotificationCategory(rawValue: categoryString) {
            print( "category \(categoryString)")
            switch familyKitCategory {
            case .familyKitCategoryFamilyChatCreate:
                // check if it is a chat notification
                if let recordFields = queryNotification.recordFields {
                    print( "recordFields \(recordFields)")
                    if let ownerEmoji = recordFields["ownerEmoji"] as? String ,
                       let ownerName = recordFields["ownerName"] as? String,
                       let sessionReferenceID = recordFields["sessionReferenceID"] as? String {
                        
                        print( "\(ownerEmoji) \(ownerName) \(sessionReferenceID)")
                        
                        // TODO: fix self.appState
                        self.appState.goToScreen(deepLink: .tabFamilyChat)
                    }
                }
            case .familyKitCategorySilentPushGeneric:
                print( "silent push generic do nothing")
                break
            case .familyKitCategorySilentPushPlayer:
                print( "silent push generic do nothing")
                break
            case .familyKitCategorySilentPushChore:
                print( "silent push generic do nothing")
                break
            case .familyKitCategorySilentPushChoreActive:
                print( "silent push generic do nothing")
                break
            case .familyKitCategorySilentPushChatMessage:
                print( "silent push generic do nothing")
                break
            case .familyKitCategorySilentPushStoreItemPurchase:
                print( "silent push generic do nothing")
                break
            case .familyKitCategorySilentPushChatSession:
                print( "silent push generic do nothing")
                break
            }
        } else {
            print( "failed to resovle the FamilyKitCKNotificationCategory from queryNotification.category: \(queryNotification.category ?? "~")")
        }
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

