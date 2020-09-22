//
//  CKBuckRewardDefinitionModel.swift
//  
//
//  Created by Matthew Schmulen on 8/19/20.
//

import Foundation
import SwiftUI
import CloudKit

public struct CKBuckRewardDefinitionModel: CKModel {

    public static var defaultSortDescriptor: SortDescriptor {
        return .none
    }
    
    public typealias ItemType = CKBuckRewardDefinitionModel
    public static let silentPushNotificationCategory = NotificationCategory.familyKitCategorySilentPushGeneric
    public static let silentPushNotificationDesiredKeys: [String]? = nil
    public static let recordName = "StoreItemDefinition"
    public static let ckSchemeKeys = [
        "name",
        "info",
        "bucks"
    ]
    
    public var id = UUID()
    public var recordID: CKRecord.ID?
    
    public var name: String?
    public var bucks: Int
    public var info: String?
    
    public var title: String? {
        return name
    }

    public static var mock: CKBuckRewardDefinitionModel {
        var model = CKBuckRewardDefinitionModel()
        model.name = "mock store item"
        model.bucks = 3
        model.info = "some mock store item info"
        return model
    }

    public init(
    ){
        self.name = nil
        self.bucks = 0
        self.info = nil
    }

    public init?(record: CKRecord) {
        guard
            let _name = record["name"] as? String
            else {
                print("CKStoreItemDefinitionModel incomplete record")
                print( "\(record["name"] as? String ?? "no name")")
                return nil
        }

        self.recordID = record.recordID
        self.name = _name
        self.bucks = record["bucks"] as? Int ?? 0
        self.info = record["info"] as? String
    }

}

// MARK: - Create a CKRecord from this model
extension CKBuckRewardDefinitionModel {

    public var ckRecord: CKRecord? {
        let record: CKRecord
        if let recordID = recordID {
            record = CKRecord(recordType: CKBuckRewardDefinitionModel.recordName, recordID: recordID)
        }
        else {
            record = CKRecord(recordType: CKBuckRewardDefinitionModel.recordName)
        }

        if let name = name {
            record["name"] = name as CKRecordValue
        }

        record["bucks"] = bucks as CKRecordValue
        
        if let info = info {
            record["info"] = info as CKRecordValue
        }
        
        return record
    }
}

