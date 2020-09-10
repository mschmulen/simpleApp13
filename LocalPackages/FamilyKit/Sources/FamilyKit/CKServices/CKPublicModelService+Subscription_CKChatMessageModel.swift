//
//  File.swift
//  
//
//  Created by Matthew Schmulen on 9/2/20.
//

import Foundation
import CloudKit

public enum FamilyKitCKNotificationCategory: String  {
    case familyKitCategoryFamilyChatCreate
}

extension CKPrivateModelService {
    
    func dumpAllSubscriptions() {
        print( "**** dumpAllSubscriptions.start")
        self.container.privateCloudDatabase.fetchAllSubscriptions { [unowned self] subscriptions, error in
            if error == nil {
                if let subscriptions = subscriptions {
                    for subscription in subscriptions {
                        
                        print( "subscription.notificationInfo: \(subscription.notificationInfo)")
                        print( "subscription.subscriptionID: \(subscription.subscriptionID)")
                        print( "subscription.subscriptionType: \(subscription.subscriptionType.rawValue)")
                    }
                }
            } else {
                print( "error in dumpAllSubscriptions")
                print(error!.localizedDescription)
            }
        }
        print( "**** dumpAllSubscriptions.end")
    }
    
    public func fetchAndDeleteAllSubscriptions(completion: @escaping ((Result<Bool,Error>) -> Void)) {
        self.container.privateCloudDatabase.fetchAllSubscriptions { [unowned self] subscriptions, error in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(error))
            } else {
                if let subscriptions = subscriptions {
                    for subscription in subscriptions {
                        
                        print( "subscription.notificationInfo: \(subscription.notificationInfo)")
                        print( "subscription.subscriptionID: \(subscription.subscriptionID)")
                        print( "subscription.subscriptionType: \(subscription.subscriptionType)")
                        print( "delete subscription")
                        self.container.privateCloudDatabase.delete(withSubscriptionID: subscription.subscriptionID) { str, error in
                            if error != nil {
                                // do your error handling here!
                                print( "error deleting subscription")
                                print(error!.localizedDescription)
                            }
                        }
                    }
                }
                completion(.success(true))
            }
        }
    }
}

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
        notificationInfo.desiredKeys = [
            "ownerName",
            "ownerEmoji",
            "sessionReferenceID"
            //"Type",
            //"recordType"
        ]
        
        // this is always a visible notification
        notificationInfo.title = "Family Chat"
        //notificationInfo.subtitle = "SUBTITILE YYY"
        notificationInfo.alertBody = message
        notificationInfo.soundName = "default"
        notificationInfo.shouldBadge = false // badge count
        //notificationInfo.categoryIdentifier =
        notificationInfo.category = FamilyKitCKNotificationCategory.familyKitCategoryFamilyChatCreate.rawValue
        //notificationInfo.actionIdentifier
        
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
