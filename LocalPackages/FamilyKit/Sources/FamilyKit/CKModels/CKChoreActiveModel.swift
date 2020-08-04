//
//  CKChoreActiveModel.swift
//  
//
//  Created by Matthew Schmulen on 8/4/20.
//

import Foundation
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
        "who",
        "frequency",
        "timeofday",
        "imageName"
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
    
    public var who: String?
    public var frequency: Frequency = .once
    public var timeofday: String?
    public var imageName: String?
    
    public var title: String? {
        return name
    }
    
    public static var mock: CKChoreActiveModel {
        var model = CKChoreActiveModel()
        model.name = "Get ready for bed"
        model.description = "Before going to be brush your teeth, put jammies on and get in bed. You only get points if mama and papa only have to remind you once!"
        model.who = "kids"
        model.bucks = 2
        model.emoji = "🧵"
        
        model.frequency = .daily
        model.timeofday = "Morning"
        model.imageName = "turtlerock"
        return model
    }
    
    public init(
    ){
        self.name = nil
        self.description = nil
        self.bucks = nil
        self.emoji = nil
        
        self.who = nil
        self.frequency = .once
        self.timeofday = nil
        self.imageName = nil
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
        
        self.who = record["who"] as? String
        
        if let frequencyString =  record["frequency"] as? String {
            self.frequency = Frequency(rawValue: frequencyString) ?? Frequency.once
        }
        self.timeofday = record["timeofday"] as? String
        self.imageName = record["imageName"] as? String
    }
    
    enum CustomError: Error {
        case unknown
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

        record["frequency"] = frequency.rawValue as CKRecordValue
        
        return record
    }
}
