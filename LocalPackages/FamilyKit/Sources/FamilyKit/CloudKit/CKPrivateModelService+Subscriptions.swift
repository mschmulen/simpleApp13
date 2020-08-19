//
//  CKPublicModelService+Subscriptions.swift
//  FamilyKit
//
//  Created by Matthew Schmulen on 7/29/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation
import CloudKit



extension CKPrivateModelService {
    
    public func subscribe( isSilent:Bool, message:String ) {
        print( "CKModelService.subscribe \(T.recordName)")
        
        let predicate = SearchPredicate.predicateTrue.predicate
        let subscription = CKQuerySubscription(
            recordType: T.recordName,
            predicate: predicate,
            options: [.firesOnRecordDeletion, .firesOnRecordUpdate, .firesOnRecordCreation]
        )
        let notificationInfo = CKSubscription.NotificationInfo()
        if isSilent {
            // Note: set shouldSendContentAvailable = true if you want it to be a silent push
            notificationInfo.shouldSendContentAvailable = true
        } else {
            notificationInfo.alertBody = message
            notificationInfo.soundName = "default"
            notificationInfo.shouldBadge = false // badge count
        }
        
        subscription.notificationInfo = notificationInfo
        
        self.container.privateCloudDatabase.save(subscription) { (savedSubscription, error) in
            if error != nil {
                print( "CKModelService.subscribe error \(error!.localizedDescription)")
            } else {
                print("CKModelService.subscribe Subscribed!")
            }
        }
    }
    
    func deleteSubscriptions() {
        print( "CKModelService.deleteSubscriptions")
        self.container.privateCloudDatabase.fetchAllSubscriptions { subscriptions, error in
            if error == nil {
                if let subscriptions = subscriptions {
                    for subscription in subscriptions {
                        self.container.privateCloudDatabase.delete(withSubscriptionID: subscription.subscriptionID) { str, error in
                            if error != nil {
                                print(error!.localizedDescription)
                            }
                        }
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
    }
}


extension CKPrivateModelService {
    
    public func listenForNotifications() {
        
        let NotificationSubscriber = NotificationCenter.default.addObserver(forName: FamilyKitNotifications.CKRemoteModelChangedNotification, object: nil, queue: OperationQueue.main) { (notification) in
            print( "CKModelService.CKChangedNotification notification recieved updating AllModels")
            self.fetch(completion: { result in
                switch result {
                case .success(let models) :
                    print( "CKModelService.listenForNotifications fetch success \(models)")
                    self.updateChanges()
                case .failure(let error):
                    print( "CKModelService.listenForNotifications fetch error \(error)")
                }
            })
        }
        
        //        let NotificationSubscriber = Subscribers.Assign(object: lastPostLabel, keyPath: \.text)
        //        somePublisher.subscribe(lastPostLabelSubscriber)
        
        //        .onReceive(NotificationCenter.default.publisher(for: DBChangedNotification)) { _ in
        //                   print("Notification.Name(CloudKitModelService) recieved")
        //                   self.devMessage = "silent Push! DB changed"
        //                   // self.myService.updateAllModels()
        //               }
    }
    
}

extension CKPrivateModelService {
    
    public static func notificationReceive( notification: CKQueryNotification) {
        print( "CKModelService.notificationReceive")
        
        var userInfo:[String : String] = [:]
        
        if let recordID = notification.recordID {
            print( "\(recordID)")
            print( "notification.recordID.recordName = \(recordID.recordName) ")
            print( "notification.recordID.zoneID.zoneName = \(recordID.zoneID.zoneName) ")
            userInfo["recordID.recordName"] = recordID.recordName
        }
        
        if let recordFields = notification.recordFields {
            print( "notification.recordFields \(recordFields.count)")
            for field in recordFields {
                print( "\(field.key) : \(field.value)")
            }
        }
        
        switch notification.queryNotificationReason {
        case .recordCreated:
            print( "notification: recordCreated")
            userInfo["operation"] = "recordCreated"
        case .recordDeleted:
            print( "notification: recordDeleted")
            userInfo["operation"] = "recordDeleted"
        case .recordUpdated:
            print( "notification: recordUpdated")
            userInfo["operation"] = "recordUpdated"
        default:
            print( "unknown")
        }
        
        NotificationCenter.default.post(
            name: FamilyKitNotifications.CKRemoteModelChangedNotification,
            object: nil,
            userInfo: userInfo
        )

    }
}
