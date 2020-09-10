//
//  NotificationDevView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 9/10/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit

struct NotificationDevView: View {
    
    var body: some View {
        List{
            Button(action: {
                let manager = LocalNotificationManager()
                manager.addNotification(
                    title: "LOCAL_TEST_BUCKS_TAB Notification Test",
                    category: NotificationCategory.openBucksTab,
                    userInfo: [String:AnyObject]()
                )
                manager.schedule()
            }) {
                Text("DeepLink BuckStore")
            }
            
            Button(action: {
                let manager = LocalNotificationManager()
                manager.addNotification(
                    title: "LOCAL_TEST_YOU_TAB Notification Test",
                    category: NotificationCategory.openYouTab,
                    userInfo: [String : AnyObject]()
                )
                manager.schedule()
            }) {
                Text("DeepLink 'You' tab")
            }
            
            Button(action: {
                let manager = LocalNotificationManager()
                manager.addNotification(
                    title: "LOCAL_TEST_CHAT_TAB Notification Test",
                    category: NotificationCategory.openChatTab,
                    userInfo: [String : AnyObject]()
                )
                manager.schedule()
            }) {
                Text("DeepLink Family Chat")
            }
            
            Button(action: {
                let manager = LocalNotificationManager()
                manager.addNotification(
                    title: "LOCAL_TEST_FAMILY_TAB Notification Test",
                    category: NotificationCategory.openFamilyTab,
                    userInfo: [String : AnyObject]()
                )
                manager.schedule()
            }) {
                Text("DeepLink Family Tab")
            }
            
            
            Button(action: {
                let manager = LocalNotificationManager()
                
                var userInfo = [String : AnyObject]()
                userInfo["RECORD_NAME"] = "C41EF008-94CD-46BA-9763-7D55B95B93A9" as AnyObject
                userInfo["RECORD_TYPE"] = CKActivityModel.recordName as AnyObject
                manager.addNotification(
                    title: "deepLinkActivity CKActivityModel",
                    category: NotificationCategory.deepLinkModalView,
                    userInfo: userInfo
                )
                manager.schedule()
            }) {
                VStack {
                    Text("deepLinkModalView ChoreActive")
                    Text("C41EF008-94CD-46BA-9763-7D55B95B93A9")
                }
            }
            
            Button(action: {
                let manager = LocalNotificationManager()
                
                var userInfo = [String : AnyObject]()
                userInfo["RECORD_NAME"] = "A9BD72F4-9468-42D2-A6E1-53B007524BC6" as AnyObject
                userInfo["RECORD_TYPE"] = CKActivityDescriptionModel.recordName as AnyObject
                
                manager.addNotification(
                    title: "deepLinkModalView CKActivityDescriptionModel",
                    category: NotificationCategory.deepLinkModalView,
                    userInfo: userInfo
                )
                manager.schedule()
            }) {
                VStack {
                    Text("deepLinkActivityDescription Chore")
                    Text("A9BD72F4-9468-42D2-A6E1-53B007524BC6")
                }
            }
            
            
            
        }
    }
}

