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

public enum ActivityCategory: String, CaseIterable {
    case chore
    case fun
    case connect
    case none
}

//public struct CKActivityDescriptionModel: CKModel {
public final class CKActivityDescriptionModel: CKModel, ObservableObject {

    public static func == (lhs: CKActivityDescriptionModel, rhs: CKActivityDescriptionModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public typealias ItemType = CKActivityDescriptionModel
    public static let recordName = "Chore"
    public static let ckSchemeKeys = [
        "name",
        "description",
        "bucks",
        "emoji",
        "category",
        "coverPhoto",
        "moduleType",
        "frequency",
        "who",
        "timeofday",
        "minAgeInYears",
        "maxAgeInYears"
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
    public var bucks: Int
    public var emoji: String?
    public var category: ActivityCategory = .none
    
    public var who: String? // TODO: remove this
    
    // Keep them for now ... but hold off on doing work around them.
    public var frequency: Frequency = .once
    public var timeofday: String?
    
    public var coverPhoto: CKAsset?
    
    public var moduleType: ActivityModuleType = ActivityModuleType.none
    
    // TODO: add to cloud kit
    public var minAgeInYears: Int?
    public var maxAgeInYears: Int?
    
    public var title: String? {
        return name
    }
    
    public static var mock: CKActivityDescriptionModel {
        let model = CKActivityDescriptionModel()
        model.name = "Get ready for bed"
        model.description = "Before going to be brush your teeth, put jammies on and get in bed. You only get points if mama and papa only have to remind you once!"
        model.who = "kids"
        model.bucks = 2
        model.emoji = "🧵"
        model.category = .chore
        
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
        self.bucks = 2
        self.emoji = nil
        self.category = .chore
        
        self.coverPhoto = nil
        self.moduleType = .drawing
        
        self.who = nil
        self.frequency = .once
        self.timeofday = nil
        
        self.minAgeInYears = nil
        self.maxAgeInYears = nil
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
        if let _bucks = record["bucks"] as? Int {
            self.bucks = _bucks
        } else {
            self.bucks = 0
        }
        self.emoji = record["emoji"] as? String
        
        if let categoryString = record["category"] as? String {
            self.category = ActivityCategory(rawValue: categoryString) ?? ActivityCategory.none
        } else {
            self.category = .none
        }
        
        self.coverPhoto = record["coverPhoto"] as? CKAsset
        
        if let moduleTypeString =  record["moduleType"] as? String {
            self.moduleType = ActivityModuleType(rawValue: moduleTypeString) ?? ActivityModuleType.drawing
        }
        
        if let frequencyString =  record["frequency"] as? String {
            self.frequency = Frequency(rawValue: frequencyString) ?? Frequency.once
        }
        self.who = record["who"] as? String
        self.timeofday = record["timeofday"] as? String
        
        self.minAgeInYears = record["minAgeInYears"] as? Int
        self.maxAgeInYears = record["maxAgeInYears"] as? Int
        
    }
    
    enum CustomError: Error {
        case unknown
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
        
        if let emoji = emoji {
            record["emoji"] = emoji as CKRecordValue
        }
        
        record["bucks"] = bucks as CKRecordValue
        record["category"] = category.rawValue as CKRecordValue
        record["moduleType"] = moduleType.rawValue as CKRecordValue
        
        record["frequency"] = frequency.rawValue as CKRecordValue
        if let coverPhoto = coverPhoto {
            record["coverPhoto"] = coverPhoto as CKAsset
        }
        
        if let minAgeInYears = minAgeInYears {
            record["minAgeInYears"] = minAgeInYears as CKRecordValue
        }
        
        if let maxAgeInYears = maxAgeInYears {
            record["maxAgeInYears"] = maxAgeInYears as CKRecordValue
        }
        
        return record
    }
}
