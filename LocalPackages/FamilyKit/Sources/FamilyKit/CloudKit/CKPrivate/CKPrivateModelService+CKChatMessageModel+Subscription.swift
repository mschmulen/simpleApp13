//
//  CKPrivateModelService+CKChatMessageModel+Subscription.swift
//  
//
//  Created by Matthew Schmulen on 9/2/20.
//

import Foundation
import CloudKit

extension CKPrivateModelService where T == CKChatMessageModel {
    
    public func subscribeToChatCreation(
        sessionReferenceIDString: String, //  this is a string of the global chat
        message: String,
        completion: @escaping ((Result<Bool,Error>) -> Void)
    ) {
        print( "CKModelService.subscribeToModel: \(sessionReferenceIDString) \(T.recordName) ")
        let predicate = NSPredicate(format: "sessionReferenceID == %@", sessionReferenceIDString)
        let subscription = CKQuerySubscription(
            recordType: T.recordName,
            predicate: predicate,
            options: [.firesOnRecordCreation]//  [ .firesOnRecordUpdate]
        )
        let notificationInfo = CKSubscription.NotificationInfo()
        
        //notificationInfo.title = "Family Chat"
        notificationInfo.titleLocalizationKey = "%1$@ %2$@"
        notificationInfo.titleLocalizationArgs = ["ownerEmoji","ownerName"] //Matches a CKRecord field on your Episode recordType
        
        //Notification Subtitle (Optional)
        //notificationInfo.subtitle = "SUBTITILE YYY"
        notificationInfo.subtitleLocalizationKey = "chat message"// %1$@"
        //notificationInfo.subtitleLocalizationArgs = ["ownerName"]//,"ownerEmoji"] //Matches a CKRecord field
        
        //Notification Body/Message
        notificationInfo.alertLocalizationKey = "%1$@"
        notificationInfo.alertLocalizationArgs = ["message"] //Matches a CKRecord field
        // this is always a visible notification
        //notificationInfo.alertBody = message
        
        notificationInfo.soundName = "default"
        notificationInfo.shouldBadge = false // badge count
        //notificationInfo.categoryIdentifier =
        notificationInfo.category = NotificationCategory.familyKitCategoryFamilyChatCreate.rawValue
        //notificationInfo.actionIdentifier

        
        notificationInfo.desiredKeys = [
            "ownerName",
            "ownerEmoji",
            "sessionReferenceID",
            "message"
        ]
        
        subscription.notificationInfo = notificationInfo
        
        self.container.privateCloudDatabase.save(subscription) { (savedSubscription, error) in
            if let error = error {
                print( "CKModelService.subscribe error \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                print("CKModelService.subscribe Subscribed!")
                completion( .success(true))
            }
        }
    }
}
