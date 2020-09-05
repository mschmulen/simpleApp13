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
    
    public func subscribeSilent() {
        print( "CKModelService.subscribe: \(T.recordName)")
        
        let predicate = SearchPredicate.predicateTrue.predicate
        let subscription = CKQuerySubscription(
            recordType: T.recordName,
            predicate: predicate,
            options: [.firesOnRecordDeletion, .firesOnRecordUpdate, .firesOnRecordCreation]
//            options: [.firesOnRecordCreation]
        )
        let notificationInfo = CKSubscription.NotificationInfo()
//        notificationInfo.desiredKeys = [
//            "ownerName",
//            "ownerEmoji",
//            "sessionReferenceID"
//        ]
        
        //if isSilent {
            // Note: set shouldSendContentAvailable = true if you want it to be a silent push
            notificationInfo.shouldSendContentAvailable = true
//        } else {
//            notificationInfo.alertBody = message
//            notificationInfo.soundName = "default"
//            notificationInfo.shouldBadge = true // badge count
//        }
        
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
    
    public func listenForRemoteNotifications() {
        
        let NotificationSubscriber = NotificationCenter.default.addObserver(forName: FamilyKitNotifications.CKRemoteModelChangedNotification, object: nil, queue: OperationQueue.main) { (notification) in
            
            guard let userInfo = notification.userInfo,
                let notificationUserInfo = CKNotificationUserInfo(userInfo: userInfo) else {
                    print("no userInfo !!!! ")
                    return
            }
            
            print( "notificationUserInfo: \(notificationUserInfo)")
            
//            notificationUserInfo: CKNotificationUserInfo(operation: FamilyKit.CKPrivateModelService<FamilyKit.CKPlayerModel>.CKNotificationUserInfo.Operation.recordCreated, recordName: nil, recordZoneName: nil)
            
//            if let userInfo = notification.userInfo {
//                print( "specific user Info")
//                let notificationUserInfo = CKNotificationUserInfo(userInfo)
//            }
            
            switch notificationUserInfo.operation {
            case .recordCreated, .recordDeleted:
                self.fetch(
                    sortDescriptor: T.defaultSortDescriptor,
                    searchPredicate: SearchPredicate.predicateTrue, completion: { result in
                    switch result {
                    case .success(let models) :
                        print( "CKModelService.listenForNotifications fetch success \(models)")
                        self.updateChanges()
                    case .failure(let error):
                        print( "CKModelService.listenForNotifications fetch error \(error)")
                        break
                    }
                })
            case .recordUpdated:
                print( "TODO: recordUpdated recordName: \(notificationUserInfo.recordName ?? "~")")
                print( "TODO: recordUpdated recordZoneName: \(notificationUserInfo.recordZoneName ?? "~")")
                self.fetch(
                    sortDescriptor: T.defaultSortDescriptor,
                    searchPredicate: SearchPredicate.predicateTrue, completion: { result in
                    switch result {
                    case .success(let models) :
                        print( "CKModelService.listenForNotifications fetch success \(models)")
                        self.updateChanges()
                    case .failure(let error):
                        print( "CKModelService.listenForNotifications fetch error \(error)")
                        break
                    }
                })
            case .unknown:
                break
            }
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
    
    struct CKNotificationUserInfo {
        
        enum Operation: String {
            case recordCreated
            case recordDeleted
            case recordUpdated
            case unknown
        }
        
        var operation: Operation = .unknown
        var recordName: String?
        var recordZoneName: String?
        //var recordFields: [(String,String)] = [(String,String)]()
        
        init?( userInfo: [AnyHashable : Any] ) {
            operation = Operation(rawValue: userInfo["operation"] as! String)!
            if let _recordName = userInfo["recordName"] as? String {
                recordName = _recordName
            } else {
                recordName = nil
            }
        }
        
        init() {
        }
        
        var userInfo:[String : String] {
            var dictionary:[String : String] = [:]
            dictionary["operation"] = operation.rawValue
            return dictionary
        }
        
    }
    
    public static func notificationReceive( notification: CKQueryNotification) {
        print( "CKModelService.notificationReceive")
        
        var notificationUserInfo = CKNotificationUserInfo()
        
        if let recordID = notification.recordID {
            print( "\(recordID)")
            print( "notification.recordID.recordName = \(recordID.recordName) ")
            print( "notification.recordID.zoneID.zoneName = \(recordID.zoneID.zoneName) ")
            notificationUserInfo.recordName = recordID.recordName
            notificationUserInfo.recordZoneName = recordID.zoneID.zoneName
        }
        
        switch notification.queryNotificationReason {
        case .recordCreated:
            notificationUserInfo.operation = .recordCreated
        case .recordDeleted:
            notificationUserInfo.operation = .recordDeleted
        case .recordUpdated:
            notificationUserInfo.operation = .recordUpdated
        default:
            notificationUserInfo.operation = .unknown
        }
        
        // TODO handle Record Fields
        if let recordFields = notification.recordFields {
            print( "notification.recordFields: \(recordFields.count)")
            for field in recordFields {
                print( "  __field key:\(field.key) value:\(field.value)")
                //notificationUserInfo.recordFields.append((field.key, field.value))
            }
        }
        
        NotificationCenter.default.post(
            name: FamilyKitNotifications.CKRemoteModelChangedNotification,
            object: nil,
            userInfo: notificationUserInfo.userInfo
        )

    }
}
