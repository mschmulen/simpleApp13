//
//  Notifications.swift
//  
//
//  Created by Matthew Schmulen on 8/14/20.
//

import Foundation


// App Notifications
public struct FamilyKitNotifications {
    
    // TODO: Rename CKRemoteModelChangedNotification
    /// This is for when things are remotely changed
    static public let CKChangedNotification = Notification.Name("CloudKitModelService")
    
    /// This is for when things change locally
    static public let CKLocalModelChangedNotification = Notification.Name("CKLocalModelChangedNotification")

}





