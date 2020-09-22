//
//  Notifications.swift
//  
//
//  Created by Matthew Schmulen on 8/14/20.
//

import Foundation

// App Notifications
public struct FamilyKitNotifications {
    
    /// This is for when things are remotely changed
    static public let CKRemoteModelChangedNotification = Notification.Name("CKRemoteModelChangedNotification")
    
    /// This is for when things change locally
    static public let CKLocalModelChangedNotification = Notification.Name("CKLocalModelChangedNotification")

}





