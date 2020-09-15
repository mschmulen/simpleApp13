//
//  CKStoreItemModel.swift
//  
//
//  Created by Matthew Schmulen on 8/19/20.
//

import Foundation
import SwiftUI
import CloudKit

public struct CKStoreItemPurchaseModel: CKModel {
    
    public static var defaultSortDescriptor: SortDescriptor {
        return .none
    }
    
    public typealias ItemType = CKStoreItemPurchaseModel
    public static let silentPushNotificationCategory = NotificationCategory.familyKitCategorySilentPushStoreItemPurchase
    public static let silentPushNotificationDesiredKeys: [String]? = nil
    public static let recordName = "StoreItemPurchase"
    public static let ckSchemeKeys = [
        "name",
        "info",
        "bucks",
        "fulfilmentStatus",
        "purchasingPlayerReference",
        "storeItemReference",
        "resultPhotos",
        "chatSession"
    ]
    
    public var id = UUID()
    public var recordID: CKRecord.ID?
    
    public var name: String?
    public var bucks: Int
    public var info: String?
    
    public var purchasingPlayerReference: CKRecord.Reference?
    public var storeItemReference: CKRecord.Reference?
    public var resultPhotos: [CKAsset]?
    public var chatSession: CKRecord.Reference?
    
    public enum FulfillmentStatus: String, CaseIterable {
        case unknown
        case purchased
        case fulfilled
    }
    public var fulfillmentStatus: FulfillmentStatus = .unknown
    
    // TODO: support these properites
//    public var storeItemDefinitionReference: CKRecord.Reference?
//    public var purchasingPlayerReference: CKRecord.Reference?
    
    public var title: String? {
        return name
    }
    
    public static var mock: CKStoreItemPurchaseModel {
        var model = CKStoreItemPurchaseModel(
            purchasingPlayer: CKPlayerModel.mock,
            storeItemReference: CKStoreItemDefinitionModel.mock
        )
        model.name = "mock store item"
        model.bucks = 3
        model.info = "some mock store item info"
        return model
    }
    
    public init(
        purchasingPlayer: CKPlayerModel,
        storeItemReference: CKStoreItemDefinitionModel
    ){
        
        guard let storeItemRecordID = storeItemReference.ckRecord?.recordID,
            let playerRecordID = purchasingPlayer.ckRecord?.recordID else {
                fatalError("oops fix this ")
        }
        
        self.storeItemReference = CKRecord.Reference(recordID: storeItemRecordID, action: .deleteSelf)
        self.purchasingPlayerReference = CKRecord.Reference(recordID: playerRecordID, action: .deleteSelf)
        
        self.name = nil
        self.bucks = 0
        self.info = nil
        self.chatSession = nil
        self.resultPhotos = nil
    }
    
    public init?(record: CKRecord) {
        guard
            let _name = record["name"] as? String
            else {
                print("CKStoreItemPurchaseModel incomplete record")
                print( "\(record["name"] as? String ?? "no name")")
                return nil
        }
        
        self.recordID = record.recordID
        self.name = _name
        self.bucks = record["bucks"] as? Int ?? 0
        self.info = record["info"] as? String
        
        if let fulfillmentStatusString = record["fulfillmentStatus"] as? String {
            self.fulfillmentStatus = FulfillmentStatus(rawValue: fulfillmentStatusString) ?? .unknown
        } else {
            self.fulfillmentStatus = .unknown
        }
        
        if let purchasingPlayerReference = record["purchasingPlayerReference"] as? CKRecord.Reference {
            self.purchasingPlayerReference = purchasingPlayerReference
        }
        
        if let storeItemReference = record["storeItemReference"] as? CKRecord.Reference {
            self.storeItemReference = storeItemReference
        }
        
        if let resultPhotos = record["resultPhotos"] as? [CKAsset] {
            self.resultPhotos = resultPhotos
        }
        
        if let chatSession = chatSession {
            record["chatSession"] = chatSession as CKRecordValue
        }
        
    }
    
}

// MARK: - Create a CKRecord from this model
extension CKStoreItemPurchaseModel {

    public var ckRecord: CKRecord? {
        let record: CKRecord
        if let recordID = recordID {
            record = CKRecord(recordType: CKStoreItemPurchaseModel.recordName, recordID: recordID)
        }
        else {
            record = CKRecord(recordType: CKStoreItemPurchaseModel.recordName)
        }

        if let name = name {
            record["name"] = name as CKRecordValue
        }
        
        record["bucks"] = bucks as CKRecordValue
        
        if let info = info {
            record["info"] = info as CKRecordValue
        }
        
        record["fulfillmentStatus"] = fulfillmentStatus.rawValue
        
        if let purchasingPlayerReference = purchasingPlayerReference {
            record["purchasingPlayerReference"] = purchasingPlayerReference as CKRecordValue
        }
        
        if let storeItemReference = storeItemReference {
            record["storeItemReference"] = storeItemReference as CKRecordValue
        }
        
        if let resultPhotos = resultPhotos {
            record["resultPhotos"] = resultPhotos as [CKAsset]
        }
        
        if let chatSession = chatSession {
            record["chatSession"] = chatSession as CKRecordValue
        }
        
        return record
    }
}
