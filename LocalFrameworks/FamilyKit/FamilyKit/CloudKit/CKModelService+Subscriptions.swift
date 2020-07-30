//
//  CKModelService+Subscriptions.swift
//  FamilyKit
//
//  Created by Matthew Schmulen on 7/29/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation
import CloudKit

extension CKModelService {
    
    public func listenForNotifications() {
        
        let NotificationSubscriber = NotificationCenter.default.addObserver(forName: CKChangedNotification, object: nil, queue: OperationQueue.main) { (notification) in
            print( "CKChangedNotification notification recieved updating AllModels")
            self.fetch(completion: { result in
                print( "fetch result \(result)")
                switch result {
                case .success(let models) :
                    print( "success \(models)")
                case .failure(let error):
                    print( "error \(error)")
                }
            })
        }
        
        //        let NotificationSubscriber = Subscribers.Assign(object: lastPostLabel, keyPath: \.text)
        //        blogPostPublisher.subscribe(lastPostLabelSubscriber)
        
        //        .onReceive(NotificationCenter.default.publisher(for: DBChangedNotification)) { _ in
        //                   print("Notification.Name(CloudKitModelService) recieved")
        //                   self.devMessage = "silent Push! DB changed"
        //                   // self.museumService.updateAllModels()
        //               }
        
    }
    
    public static func notificationReceive( notification: CKQueryNotification) {
        print( "notificationReceive")
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
        print( "subscribe \(T.recordName)")
        let subscription = CKQuerySubscription(recordType: T.recordName, predicate: NSPredicate(value: true), options: [.firesOnRecordDeletion, .firesOnRecordUpdate, .firesOnRecordCreation])
        let info = CKSubscription.NotificationInfo()
        info.shouldSendContentAvailable = true
        subscription.notificationInfo = info
        
        
        self.container.publicCloudDatabase.save(subscription) { (savedSubscription, error) in
            if error != nil {
                print(error!.localizedDescription)
                print( "error subscribe")
            } else {
                print("Subscribed!")
            }
        }
    }
    
    func deleteSubscriptions() {
        self.container.publicCloudDatabase.fetchAllSubscriptions { subscriptions, error in
            if error == nil {
                if let subscriptions = subscriptions {
                    for subscription in subscriptions {
                        self.container.publicCloudDatabase.delete(withSubscriptionID: subscription.subscriptionID) { str, error in
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