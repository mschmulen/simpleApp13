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
    case unknown
    case active // started activity.
    case completed // they think they are done.
    case verified  // adult "verify button" and they get bucks
    
    public var friendlyName: String {
        switch self {
        case .unknown: return "unknown"
        case .active: return "active"
        case .completed: return "completed"
        case .verified: return "verified"
        }
    }
}

//public struct CKActivityModel: CKModel {
public final class CKActivityModel: CKModel, ObservableObject {
    
    public static func == (lhs: CKActivityModel, rhs: CKActivityModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) { hasher.combine(id) }
    
    public typealias ItemType = CKActivityModel
    public static let recordName = "ChoreActive"
    public static let ckSchemeKeys = [
        "name",
        "description",
        "bucks",
        "emoji",
        "ckChoreDescriptionReference",
        "kidReference",
        "coverPhoto",
        "resultAssetImage",
        "moduleType",
        "activityAsset",
        "status",
        "category",
        "chatSession"
    ]
    public var id = UUID()
    public var recordID: CKRecord.ID?
    
    public var name: String?
    public var description: String?
    public var bucks: Int?
    public var emoji: String?
    
    public var ckChoreDescriptionReference: CKRecord.Reference?
    public var kidReference: CKRecord.Reference?
    public var coverPhoto: CKAsset?
    
    public var moduleType: ActivityModuleType = ActivityModuleType.none
    
    public var resultAssetText: CKAsset?
    public var resultAssetImage: CKAsset?
    
    public var activityAsset: CKAsset?
    
    //public var statusMessage: String?
    public var status: ActivityStatus = .unknown
    public var category: ActivityCategory = .none
    
    public var chatSession: CKRecord.Reference?
    
    public var title: String? {
        return name
    }
    
    public static var mock: CKActivityModel {
        var model = CKActivityModel()
        
        model.name = "mock activity"
        model.description = "mock activity description"
        model.bucks = 3
        model.emoji = "🧳"
        model.category = .chore
        
        model.ckChoreDescriptionReference = nil
        model.kidReference = nil
        model.coverPhoto = nil
        
        model.moduleType = ActivityModuleType.photo
        
        model.resultAssetImage = nil
        
        model.activityAsset = nil
        
        model.status = .active
        model.category = .chore
        model.chatSession = nil
        
        return model
    }
    
    public init(
    ){
        self.name = nil
        self.description = nil
        self.bucks = nil
        self.emoji = nil
        self.ckChoreDescriptionReference = nil
        self.kidReference = nil
        self.coverPhoto = nil
        self.resultAssetImage = nil
        self.activityAsset = nil
        self.status = .unknown
        self.category = .chore
        self.chatSession = nil
    }
    
    public init( descriptionModel: CKActivityDescriptionModel, playerRecordReference: CKRecord.Reference) {
        
        guard let descriptionRecordID = descriptionModel.recordID else {
            fatalError("")
        }
        
        let descriptionReference = CKRecord.Reference(recordID: descriptionRecordID, action: .deleteSelf)
        
        self.name = descriptionModel.name
        self.description = descriptionModel.description
        self.bucks = descriptionModel.bucks
        
        self.ckChoreDescriptionReference = descriptionReference
        self.kidReference = playerRecordReference
        self.moduleType = descriptionModel.moduleType
        
        self.emoji = descriptionModel.emoji
        
        self.category = descriptionModel.category
        self.status = ActivityStatus.active
    }
    
    public init?(record: CKRecord) {
        
        self.recordID = record.recordID
        
        if let name  = record["name"] as? String {
            self.name = name
        }
        
        if let description = record["description"] as? String {
            self.description = description
        }
        
        if let bucks = record["bucks"] as? Int {
            self.bucks = bucks
        }
        
        if let emoji = record["emoji"] as? String {
            self.emoji = emoji
        }
        
        if let ckChoreDescriptionReference = record["ckChoreDescriptionReference"] as? CKRecord.Reference {
            self.ckChoreDescriptionReference = ckChoreDescriptionReference
        }

        if let kidReference = record["kidReference"] as? CKRecord.Reference {
            self.kidReference = kidReference
        }
        
        if let coverPhoto = record["coverPhoto"] as? CKAsset {
            self.coverPhoto = coverPhoto
        }
        
        if let resultAssetImage = record["resultAssetImage"] as? CKAsset {
            self.resultAssetImage = resultAssetImage
        }
        
        if let moduleTypeString =  record["moduleType"] as? String {
            self.moduleType = ActivityModuleType(rawValue: moduleTypeString) ?? ActivityModuleType.drawing
        }
        
        if let activityAsset = record["activityAsset"] as? CKAsset {
            self.activityAsset = activityAsset
        }
        
        if let statusString = record["status"] as? String {
            if let statusEnum = ActivityStatus(rawValue: statusString) {
                self.status =  statusEnum
            } else {
                print("status cast fail")
            }
        }
        
        if let categoryString = record["category"] as? String {
            self.category = ActivityCategory(rawValue: categoryString) ?? ActivityCategory.none
        }
        
        if let chatSession = record["chatSession"] as? CKRecord.Reference {
            self.chatSession = chatSession
        }
        
    }
    
    enum CustomError: Error {
        case unknown
    }
    
}


// MARK: - mutating functions
extension CKActivityModel {
    
    public func changeStatus(status: ActivityStatus) {
        self.status = status
    }
    
    public func changeResultAssetImage(asset: CKAsset) {
        self.resultAssetImage = asset
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
        
        if let emoji = emoji {
            record["emoji"] = emoji as CKRecordValue
        }
        
        if let ckChoreDescriptionReference = ckChoreDescriptionReference {
            record["ckChoreDescriptionReference"] = ckChoreDescriptionReference as CKRecordValue
        }
        
        record["moduleType"] = moduleType.rawValue as CKRecordValue
        
        record["category"] = category.rawValue as CKRecordValue
        
        if let kidReference = kidReference {
            record["kidReference"] = kidReference as CKRecordValue
        }
        
        if let coverPhoto = coverPhoto {
            record["coverPhoto"] = coverPhoto as CKAsset
        }
        
        if let resultAssetImage = resultAssetImage {
            record["resultAssetImage"] = resultAssetImage as CKRecordValue
        }
        
        if let activityAsset = activityAsset {
            record["activityAsset"] = activityAsset as CKRecordValue
        }
        
        record["status"] = status.rawValue
        print( "status.rawValue \(status.rawValue)")
        
        record["category"] = category.rawValue
        
        if let chatSession = chatSession {
            record["chatSession"] = chatSession as CKRecordValue
        }
        
        return record
    }
}


extension CKActivityModel {
    
    public static var mockNoEmoji: CKActivityModel {
        var model = CKActivityModel()
        
        model.name = "mock noEmoji"
        model.description = "mock noEmoji activity description"
        model.bucks = 3
//        model.emoji = "🧳"
        model.category = .chore
        
        model.ckChoreDescriptionReference = nil
        model.kidReference = nil
        model.coverPhoto = nil
        
        model.moduleType = ActivityModuleType.photo
        
        model.resultAssetText = nil
        model.resultAssetImage = nil
        //model.resultAssetAudio = nil
        
        model.activityAsset = nil
        
        //model.statusMessage = nil
        model.status = .active
        model.category = .chore
        model.chatSession = nil
        
        return model
    }
    
    public static var mockPhoto: CKActivityModel {
            var model = CKActivityModel()
            
            model.name = "mock photo activity"
            model.description = "mock photo activity description"
            model.bucks = 3
            model.emoji = "🧳"
            model.category = .chore
            model.ckChoreDescriptionReference = nil
            model.kidReference = nil
            model.coverPhoto = nil
            model.moduleType = ActivityModuleType.photo
            model.resultAssetText = nil
            model.resultAssetImage = nil
            model.activityAsset = nil
            model.status = .active
            model.category = .chore
            model.chatSession = nil
            
            return model
        }
    
    public static var mockDrawing: CKActivityModel {
        var model = CKActivityModel()
        
        model.name = "mock drawing activity"
        model.description = "mock drawing activity description"
        model.bucks = 3
        model.emoji = "🧳"
        model.category = .chore
        model.ckChoreDescriptionReference = nil
        model.kidReference = nil
        model.coverPhoto = nil
        model.moduleType = ActivityModuleType.drawing
        model.resultAssetText = nil
        model.resultAssetImage = nil
        model.activityAsset = nil
        model.status = .active
        model.category = .chore
        model.chatSession = nil
        
        return model
    }
    
    public static var mockAudio: CKActivityModel {
        var model = CKActivityModel()
        
        model.name = "mock audio"
        model.description = "mock audio activity description"
        model.bucks = 3
        model.emoji = "🧳"
        model.category = .chore
        model.ckChoreDescriptionReference = nil
        model.kidReference = nil
        model.coverPhoto = nil
        model.moduleType = ActivityModuleType.audio
        model.resultAssetText = nil
        model.resultAssetImage = nil
        model.activityAsset = nil
        model.status = .active
        model.category = .chore
        model.chatSession = nil
        
        return model
    }
}


