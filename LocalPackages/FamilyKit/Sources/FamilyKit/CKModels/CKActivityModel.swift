//
//  CKActivityActiveModel.swift
//  
//
//  Created by Matthew Schmulen on 8/4/20.
//

import Foundation
import SwiftUI
import CloudKit

public enum ActivityStatus: String, CaseIterable {
    case active
    case completed
}

public struct CKActivityModel: CKModel {
    
    public typealias ItemType = CKActivityModel
    public static let recordName = "ChoreActive"
    public static let ckSchemeKeys = [
        "ckChoreDescriptionReference",
        "kidReference",
        "coverPhoto"
    ]
    public var id = UUID()
    public var recordID: CKRecord.ID?
    
    public var name: String?
    public var description: String?
    public var bucks: Int?
    public var emoji: String?
    //public var category: ActivityCategory = .none
    
    public var ckChoreDescriptionReference: CKRecord.Reference?
    public var kidReference: CKRecord.Reference?
    public var coverPhoto: CKAsset?
    
    public var moduleType: ActivityModuleType = ActivityModuleType.none
    
    // TODO
    public var resultAssetText: CKAsset?
    public var resultAssetImage: CKAsset?
    //public var resultAssetAudio: CKAsset?
    
    public var activityAsset: CKAsset?
    
    // TODO add to the data store
//    public var closeString: String?
//    public var status: ActivityStatus = .active
    
    public var title: String? {
        return name
    }
    
    public static var mock: CKActivityModel {
        var model = CKActivityModel()
        
        model.name = "mock activity"
        model.description = "mock activity description"
        model.bucks = 3
        model.emoji = "🧳"
        //model.category = .chore
        
        model.ckChoreDescriptionReference = nil
        model.kidReference = nil
        model.coverPhoto = nil
        
        model.moduleType = ActivityModuleType.photo
        
        model.resultAssetText = nil
        model.resultAssetImage = nil
        //model.resultAssetAudio = nil
        
        model.activityAsset = nil
        
        return model
    }
    
    public init(
    ){
        
        self.name = nil
        self.description = nil
        self.bucks = nil
        
        //self.category = .none
        
        self.ckChoreDescriptionReference = nil
        self.kidReference = nil
        self.coverPhoto = nil
        self.resultAssetText = nil
        self.resultAssetImage = nil
        //self.resultAssetAudio = nil
        
        self.activityAsset = nil
    }
    
    public init?(record: CKRecord) {
//        guard
//            let _name = record["name"] as? String
//            else {
//                print("CKChoreActiveModel incomplete record")
//                print( "\(record["name"] as? String ?? "Unknown title")")
//                return nil
//        }
        
        self.recordID = record.recordID
        
        self.name = record["name"] as? String
        self.description = record["description"] as? String
        self.bucks = record["bucks"] as? Int
        
//        if let categoryString = record["category"] as? String {
//            self.category = ActivityCategory(rawValue: categoryString) ?? ActivityCategory.none
//        } else {
//            self.category = .none
//        }
        
        self.ckChoreDescriptionReference = record["ckChoreDescriptionReference"] as? CKRecord.Reference
        self.kidReference = record["kidReference"] as? CKRecord.Reference
        self.coverPhoto = record["coverPhoto"] as? CKAsset

        self.resultAssetText = record["resultAssetText"] as? CKAsset
        self.resultAssetImage = record["resultAssetImage"] as? CKAsset
        //self.resultAssetAudio = record["resultAssetAudio"] as? CKAsset
        
        if let moduleTypeString =  record["moduleType"] as? String {
            self.moduleType = ActivityModuleType(rawValue: moduleTypeString) ?? ActivityModuleType.drawing
        }
        
        self.activityAsset = record["activityAsset"] as? CKAsset
    }
    
    enum CustomError: Error {
        case unknown
    }
    
}

// MARK: - Create a CKRecord from this model
extension CKActivityModel {
    
    public var ckRecord: CKRecord? {
        
        let record: CKRecord
        
        if let recordID = recordID {
            record = CKRecord(recordType: CKActivityModel.recordName, recordID: recordID)
        }
        else {
            record = CKRecord(recordType: CKActivityModel.recordName)
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
        
        if let ckChoreDescriptionReference = ckChoreDescriptionReference {
            record["ckChoreDescriptionReference"] = ckChoreDescriptionReference as CKRecordValue
        }
        
        record["moduleType"] = moduleType.rawValue as CKRecordValue
        
//        record["category"] = category.rawValue as CKRecordValue
        
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

//        if let resultAssetAudio = resultAssetAudio {
//            record["resultAssetAudio"] = resultAssetAudio as CKRecordValue
//        }
        
        if let activityAsset = activityAsset {
            record["activityAsset"] = activityAsset as CKRecordValue
        }
        
        return record
    }
}
