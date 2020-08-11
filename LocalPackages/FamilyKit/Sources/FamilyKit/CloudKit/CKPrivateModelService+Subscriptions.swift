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
    
    public func listenForNotifications() {
        
        let NotificationSubscriber = NotificationCenter.default.addObserver(forName: CKChangedNotification, object: nil, queue: OperationQueue.main) { (notification) in
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
    
    public static func notificationReceive( notification: CKQueryNotification) {
        print( "CKModelService.notificationReceive")
        NotificationCenter.default.post(name: CKChangedNotification, object: nil)
        
        if notification.queryNotificationReason == .recordCreated {
            print( ".recordCreated")
            // ContentView().fetchRecord(record: (notification?.recordID)!)
        }
        if notification.queryNotificationReason == .recordUpdated {
            print( ".recordUpdated")
            //later
        }
        if notification.queryNotificationReason == .recordDeleted {
            print( ".recordDeleted")
            //ContentView().deleteRecord(record: (notification?.recordID)!)
        }
    }
    
    public func subscribe() {
        print( "CKModelService.subscribe \(T.recordName)")
        let subscription = CKQuerySubscription(
            recordType: T.recordName,
            predicate: SearchPredicate.predicateTrue.predicate,
            options: [.firesOnRecordDeletion, .firesOnRecordUpdate, .firesOnRecordCreation]
        )
        let info = CKSubscription.NotificationInfo()
        info.shouldSendContentAvailable = true
        subscription.notificationInfo = info
        
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
