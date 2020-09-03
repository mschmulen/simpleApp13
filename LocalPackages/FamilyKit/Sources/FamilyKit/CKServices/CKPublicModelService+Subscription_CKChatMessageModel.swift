//
//  File.swift
//  
//
//  Created by Matthew Schmulen on 9/2/20.
//

import Foundation
import CloudKit

extension CKPrivateModelService where T == CKChatMessageModel {
    
    public func subscribeToChat(
        sessionReferenceIDString: String, //  this is a string of the global chat
        message: String
    ) {
        return
        
        print( "CKModelService.subscribeToModel: \(sessionReferenceIDString) \(T.recordName) ")
        
        //        CKRecordID *artistRecordID = [[CKRecordID alloc] initWithRecordName:@"Mei Chen"];
        //        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"artist = %@", artistRecordID];
        
        let predicate = NSPredicate(format: "sessionReferenceID == %@", sessionReferenceIDString)
        let subscription = CKQuerySubscription(
            recordType: T.recordName,
            predicate: predicate,
            options: [.firesOnRecordCreation]//  [ .firesOnRecordUpdate]
        )
        let notificationInfo = CKSubscription.NotificationInfo()
        notificationInfo.desiredKeys = [
            "ownerName",
            "ownerEmoji",
            "sessionReferenceID"
        ]
        
        // this is always a visible notification
        notificationInfo.title = "Family Chat"
        //notificationInfo.subtitle = "SUBTITILE YYY"
        notificationInfo.alertBody = message
        notificationInfo.soundName = "default"
        notificationInfo.shouldBadge = false // badge count
        subscription.notificationInfo = notificationInfo
        
        
        
        self.container.privateCloudDatabase.save(subscription) { (savedSubscription, error) in
            if error != nil {
                print( "CKModelService.subscribe error \(error!.localizedDescription)")
            } else {
                print("CKModelService.subscribe Subscribed!")
            }
        }
        
    }
}
