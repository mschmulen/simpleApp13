//
//  CKChoreActiveModel.swift
//  
//
//  Created by Matthew Schmulen on 8/4/20.
//

import Foundation
import SwiftUI
import CloudKit

public struct CKChoreActiveModel: CKModel {
    
    public typealias ItemType = CKChoreActiveModel
    public static let recordName = "ChoreActive"
    public static let ckSchemeKeys = [
        "name",
        "description",
        "bucks",
        "emoji",
        "category",
        "kidReference",
        "coverPhoto"
    ]
    
    
    
    public var id = UUID()
    public var recordID: CKRecord.ID?
    
    public var name: String?
    public var description: String?
    public var bucks: Int?
    public var emoji: String?
    public var category: String?
    public var kidReference: CKRecord.Reference?
    public var coverPhoto: CKAsset?
    
    public var moduleType: CKChoreDescriptionModel.ModuleType = CKChoreDescriptionModel.ModuleType.picture
    
    // TODO
    public var resultAssetText: CKAsset?
    public var resultAssetImage: CKAsset?
    public var resultAssetAudio: CKAsset?
    
    
    public var title: String? {
        return name
    }
    
    public static var mock: CKChoreActiveModel {
        var model = CKChoreActiveModel()
        model.name = "Get ready for bed"
        model.description = "Before going to be brush your teeth, put jammies on and get in bed. You only get points if mama and papa only have to remind you once!"
        model.bucks = 2
        model.emoji = "🧵"
        model.category = "chore"
        model.kidReference = nil
        model.coverPhoto = nil
        model.resultAssetText = nil
        model.resultAssetImage = nil
        model.resultAssetAudio = nil

        return model
    }
    
    public init(
    ){
        self.name = nil
        self.description = nil
        self.bucks = nil
        self.emoji = nil
        self.category = nil
        self.kidReference = nil
        self.coverPhoto = nil
        self.resultAssetText = nil
        self.resultAssetImage = nil
        self.resultAssetAudio = nil
    }
    
    public init?(record: CKRecord) {
        guard
            let _name = record["name"] as? String
            else {
                print("CKChoreActiveModel incomplete record")
                print( "\(record["name"] as? String ?? "Unknown title")")
                return nil
        }
        
        self.recordID = record.recordID
        self.name = _name
        self.description = record["description"] as? String
        self.bucks = record["bucks"] as? Int
        self.emoji = record["emoji"] as? String
        self.category = record["category"] as? String
        self.kidReference = record["kidReference"] as? CKRecord.Reference
        self.coverPhoto = record["coverPhoto"] as? CKAsset

        self.resultAssetText = record["resultAssetText"] as? CKAsset
        self.resultAssetImage = record["resultAssetImage"] as? CKAsset
        self.resultAssetAudio = record["resultAssetAudio"] as? CKAsset
    }
    
    enum CustomError: Error {
        case unknown
    }
    
}

// TODO: add this to the generic CKModel requirement
extension CKChoreActiveModel {
    
    // TODO: add this to the generic CKModel requirement
    public func reload( service: CKPrivateModelService<CKChoreActiveModel> ) {
        service.fetchSingle(model: self) { result in
            print( "result \(result)")
        }
    }
}

// MARK: - Create a CKRecord from this model
extension CKChoreActiveModel {
    
    public var ckRecord: CKRecord? {
        
        let record: CKRecord
        
        if let recordID = recordID {
            record = CKRecord(recordType: CKChoreActiveModel.recordName, recordID: recordID)
        }
        else {
            record = CKRecord(recordType: CKChoreActiveModel.recordName)
        }
        
        if let name = name {
            record["name"] = name as CKRecordValue
        }
        
        if let description = description {
            record["description"] = description as CKRecordValue
        }
        
        if let bucks = bucks {
            record["bucks"] = bucks as CKRecordValue
        }
        
        if let emoji = emoji {
            record["emoji"] = emoji as CKRecordValue
        }
        
        if let category = category {
            record["category"] = category as CKRecordValue
        }
        
        if let kidReference = kidReference {
            record["kidReference"] = kidReference as CKRecordValue
        }
        
        if let coverPhoto = coverPhoto {
            record["coverPhoto"] = coverPhoto as CKRecordValue
        }
        
        if let resultAssetText = resultAssetText {
            record["resultAssetText"] = resultAssetText as CKRecordValue
        }
        
        if let resultAssetImage = resultAssetImage {
            record["resultAssetImage"] = resultAssetImage as CKRecordValue
        }

        if let resultAssetAudio = resultAssetAudio {
            record["resultAssetAudio"] = resultAssetAudio as CKRecordValue
        }
        
        return record
    }
}
