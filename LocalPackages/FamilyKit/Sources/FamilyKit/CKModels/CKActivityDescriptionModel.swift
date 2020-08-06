//
//  CKChoreDescriptionModel.swift
//  FamilyKit
//
//  Created by Matthew Schmulen on 7/25/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation
import SwiftUI
import CloudKit

public enum ActivityModuleType: String, CaseIterable {
    case audio
    case photo
    case drawing
    case chat
    case none
}

public struct CKActivityDescriptionModel: CKModel {
    
    public typealias ItemType = CKActivityDescriptionModel
    public static let recordName = "Chore"
    public static let ckSchemeKeys = [
        "name",
        "description",
        "bucks",
        "emoji",
        "category",
        "who",
        "frequency",
        "timeofday",
        "coverPhoto"
    ]
    
    public enum Frequency: String, CaseIterable {
        case once
        case daily
        case weekly
        case monthly
    }
    
    public var id = UUID()
    public var recordID: CKRecord.ID?
    
    public var name: String?
    public var description: String?
    public var bucks: Int?
    public var emoji: String?
    public var category: String?
    
    public var who: String?
    public var frequency: Frequency = .once
    public var timeofday: String?
    
    public var coverPhoto: CKAsset?
    
    public var moduleType: ActivityModuleType = ActivityModuleType.none
    
    public var title: String? {
        return name
    }
    
    public static var mock: CKActivityDescriptionModel {
        var model = CKActivityDescriptionModel()
        model.name = "Get ready for bed"
        model.description = "Before going to be brush your teeth, put jammies on and get in bed. You only get points if mama and papa only have to remind you once!"
        model.who = "kids"
        model.bucks = 2
        model.emoji = "🧵"
        model.category = "chore"
        
        model.frequency = .daily
        model.timeofday = "Morning"
        model.coverPhoto = nil
        model.moduleType = .drawing
        return model
    }
    
    public init(
    ){
        self.name = nil
        self.description = nil
        self.bucks = nil
        self.emoji = nil
        self.category = nil
        
        self.who = nil
        self.frequency = .once
        self.timeofday = nil
        self.coverPhoto = nil
        self.moduleType = .drawing
    }
    
    public init?(record: CKRecord) {
        guard
            let _name = record["name"] as? String,
            let _description = record["description"] as? String
            else {
                print("CKChoreModel incomplete record")
                print( "\(record["name"] as? String ?? "Unknown title")")
                return nil
        }
        
        self.recordID = record.recordID
        self.name = _name
        self.description = _description
        self.bucks = record["bucks"] as? Int
        self.emoji = record["emoji"] as? String
        self.category = record["category"] as? String
        
        
        if let frequencyString =  record["frequency"] as? String {
            self.frequency = Frequency(rawValue: frequencyString) ?? Frequency.once
        }
        self.coverPhoto = record["coverPhoto"] as? CKAsset
        
        if let moduleTypeString =  record["moduleType"] as? String {
            self.moduleType = ActivityModuleType(rawValue: moduleTypeString) ?? ActivityModuleType.drawing
        }
        
        self.who = record["who"] as? String
        self.timeofday = record["timeofday"] as? String
    }
    
    enum CustomError: Error {
        case unknown
    }
    
}

// TODO: add this to the generic CKModel requirement
extension CKActivityDescriptionModel {
    
    // TODO: add this to the generic CKModel requirement
    public func reload( service: CKPrivateModelService<CKActivityDescriptionModel> ) {
        service.fetchSingle(model: self) { result in
            print( "result \(result)")
        }
    }
}

// MARK: - Create a CKRecord from this model
extension CKActivityDescriptionModel {
    
    public var ckRecord: CKRecord? {
        
        let record: CKRecord
        
        if let recordID = recordID {
            record = CKRecord(recordType: CKActivityDescriptionModel.recordName, recordID: recordID)
        }
        else {
            record = CKRecord(recordType: CKActivityDescriptionModel.recordName)
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
        
        record["frequency"] = frequency.rawValue as CKRecordValue
        
        record["moduleType"] = moduleType.rawValue as CKRecordValue
        
        // TODO: handle the imageAsset
        //record["coverPhoto"] = coverPhoto as CKRecordValue
        
        return record
    }
}
