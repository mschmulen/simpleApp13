//
//  CKChatMessageModel.swift
//  
//
//  Created by Matthew Schmulen on 8/5/20.
//

import Foundation
import SwiftUI
import CloudKit

public struct CKChatMessageModel: CKModel {
    
    public static var defaultSortDescriptor: SortDescriptor {
        return .custom(key: "creationDate", ascending: false)
    }
    
    public typealias ItemType = CKChatMessageModel
    public static let silentPushNotificationCategory = NotificationCategory.familyKitCategorySilentPushChatMessage
    public static let silentPushNotificationDesiredKeys: [String]? = nil
    public static let recordName = "ChatMessage"
    public static let ckSchemeKeys = [
        "person1",
        "person2"
    ]
    
    public var id = UUID()
    public var recordID: CKRecord.ID?
    
    public var message: String?
    public var ownerEmoji: String?
    public var ownerName: String?
    public var ownerReference: CKRecord.Reference?

    public var audioAsset: CKAsset?
    public var imageAsset: CKAsset?
    
    public var sessionReferenceID: String?
    
    public var title: String? {
        return message
    }
    
    public static var mock: CKChatMessageModel {
        var model = CKChatMessageModel()
        model.ownerEmoji = "🤠"
        model.ownerName = "Marky"
        model.message = "some message, hello there "
        return model
    }
    
    public func update() {
        print("todo")
    }
    
    public init(
    ){
        self.message = nil
        self.ownerEmoji = nil
        self.ownerName  = nil
        self.ownerReference = nil
        self.sessionReferenceID = nil
    }
    
    public init?(record: CKRecord) {
        guard
            let _ownerName = record["ownerName"] as? String,
            let _ownerEmoji = record["ownerEmoji"] as? String
            else {
                print("CKChatSessionDirectModel incomplete record")
                print( "\(record["person1"] as? String ?? "Unknown title")")
                return nil
        }
        
        self.recordID = record.recordID
        self.ownerName = _ownerName
        self.ownerEmoji = _ownerEmoji
        self.message = record["message"] as? String
        self.ownerReference = record["ownerReference"] as? CKRecord.Reference
        self.sessionReferenceID = record["sessionReferenceID"] as? String
    }
    
}

// TODO: add this to the generic CKModel requirement
extension CKChatMessageModel {

    // TODO: add this to the generic CKModel requirement
    public func reload( service: CKPrivateModelService<CKChatMessageModel> ) {
        service.fetchSingle(model: self) { result in
            print( "result \(result)")
        }
    }
}

// MARK: - Create a CKRecord from this model
extension CKChatMessageModel {
    
    public var ckRecord: CKRecord? {
        
        let record: CKRecord
        
        if let recordID = recordID {
            record = CKRecord(recordType: CKChatMessageModel.recordName, recordID: recordID)
        }
        else {
            record = CKRecord(recordType: CKChatMessageModel.recordName)
        }
        
        if let ownerName = ownerName {
            record["ownerName"] = ownerName as CKRecordValue
        }
        
        if let ownerEmoji = ownerEmoji {
            record["ownerEmoji"] = ownerEmoji as CKRecordValue
        }
        
        if let message = message {
            record["message"] = message as CKRecordValue
        }
        
        if let ownerName = ownerName {
            record["ownerName"] = ownerName as CKRecordValue
        }
        
        if let ownerReference = ownerReference {
            record["ownerReference"] = ownerReference as CKRecordValue
        }
        
        if let sessionReferenceID = sessionReferenceID {
            record["sessionReferenceID"] = sessionReferenceID as CKRecordValue
        }
        
        return record
    }
}

