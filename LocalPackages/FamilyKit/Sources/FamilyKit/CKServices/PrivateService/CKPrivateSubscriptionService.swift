//
//  CKPrivateSubscriptionService.swift
//  
//
//  Created by Matthew Schmulen on 9/11/20.
//

import Foundation
import CloudKit

public enum NotificationCategory: String  {
    
    case familyKitCategoryFamilyChatCreate
    
    // generic silent push
    case familyKitCategorySilentPushGeneric
    
    // specific silent push
    case familyKitCategorySilentPushPlayer
    case familyKitCategorySilentPushChore
    case familyKitCategorySilentPushChoreActive
    case familyKitCategorySilentPushChatMessage
    case familyKitCategorySilentPushChatSession
    // case familyKitCategorySilentPushStoreItemDefinition
    case familyKitCategorySilentPushStoreItemPurchase
    
}

public struct SubscriptionModel: Identifiable, Hashable{
    public let id: UUID = UUID()
    public let subscription: CKSubscription
}

public final class CKPrivateSubscriptionService: ObservableObject {
    
    internal var container: CKContainer
    
    public init(container: CloudKitContainer) {
        switch container {
        case .CloudContainer(let container):
            self.container = container
        case .MockContainer(let container):
            self.container = container
        }
    }
    
    enum CustomError: Error {
        case unknown
        case cursorFailure
    }
    
    internal func updateChanges() {
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
}

extension CKPrivateSubscriptionService {
    
    public func fetchAllSubscriptions(
        completion: @escaping ((Result<[SubscriptionModel],Error>) -> Void)
    ) {
        print( "**** dumpAllSubscriptions.start")
        self.container.privateCloudDatabase.fetchAllSubscriptions { [unowned self] subscriptions, error in
            
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(error))
            } else {
                var models: [SubscriptionModel] = []
                if let subscriptions = subscriptions {
                    for subscription in subscriptions {
                        let model = SubscriptionModel(subscription: subscription)
                        models.append(model)
                    }
                }
                completion(.success(models))
            }
        }
    }
    
    public func deleteSubscription(
        model: SubscriptionModel,
        completion: @escaping ((Result<Bool,Error>) -> Void)
    ) {
        self.container.privateCloudDatabase.fetchAllSubscriptions { [unowned self] subscriptions, error in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(error))
            } else {
                if let subscriptions = subscriptions {
                    for subscription in subscriptions {
                        if model.subscription.subscriptionID == subscription.subscriptionID {
                            self.container.privateCloudDatabase.delete(withSubscriptionID: subscription.subscriptionID) { str, error in
                                if error != nil {
                                    // do your error handling here!
                                    print( "error deleting subscription")
                                    print(error!.localizedDescription)
                                } else {
                                    completion(.success(false))
                                    return
                                }
                            }
                        }
                    }
                    completion(.success(true))
                } else {
                    completion(.success(false))
                }
            }
        }
    }
    
    public func fetchAndDeleteAllSubscriptions(
        completion: @escaping ((Result<Bool,Error>) -> Void)
    ) {
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

