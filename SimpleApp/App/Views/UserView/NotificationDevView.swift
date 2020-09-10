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
        }
    }
}

