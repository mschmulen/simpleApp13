//
//  LocalNotificationManager.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 9/10/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation
import UserNotifications


enum NotificationCategory: String {
    case LOCAL_TEST_BUCKS_TAB
    case LOCAL_TEST_CHAT_TAB
    case LOCAL_TEST_FAMILY_TAB
    case LOCAL_TEST_YOU_TAB
}

struct Notification {
    var id: String
    var title: String
    var category: NotificationCategory
    var subTitle: String?
}

class LocalNotificationManager {
    var notifications = [Notification]()
    
   func requestPermission() -> Void {
        UNUserNotificationCenter
            .current()
            .requestAuthorization(options: [.alert, .badge, .alert]) { granted, error in
                if granted == true && error == nil {
                    self.scheduleNotifications()
                    // We have permission!
                }
        }
    }
    
    func addNotification(
        title: String,
        category: NotificationCategory
    ) -> Void {
        notifications.append(
            Notification(
                id: UUID().uuidString,
                title: title,
                category: category
            )
        )
    }
    
    func scheduleNotifications() -> Void {
        for notification in notifications {
            let content = UNMutableNotificationContent()
            content.title = notification.title
            if let subTitle = notification.subTitle {
                content.subtitle = subTitle
            }
            content.categoryIdentifier =  notification.category.rawValue
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                guard error == nil else { return }
                print("Scheduling notification with id: \(notification.id)")
            }
        }
    }
    
    func schedule() -> Void {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestPermission()
            case .authorized, .provisional:
                self.scheduleNotifications()
            default:
                break
            }
        }
    }

}
