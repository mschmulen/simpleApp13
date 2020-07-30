//
//  GameState.swift
//  FamilyKit
//
//  Created by Matthew Schmulen on 7/25/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation
import SwiftUI
import CoreLocation
import CloudKit

public struct CKChoreModel: CKModel {
    
    public typealias ItemType = CKChoreModel
    public static let recordName = "Chore"
    public static let ckSchemeKeys = [
        "name",
        "description",
        "bucks",
        "who",
        "frequency",
        "timeofday",
        "imageName"
    ]
    
    public var id = UUID()
    public var recordID: CKRecord.ID?
    
    public var name: String?
    public var description: String?
    public var bucks: Int?
    
    public var who: String?
    public var frequency: String?
    public var timeofday: String?
    public var imageName: String?
    
    public var title: String? {
        return name
    }
    
    public static var mock: CKChoreModel {
        var model = CKChoreModel()
        model.name = "Get ready for bed"
        model.description = "Before going to be brush your teeth, put jammies on and get in bed. You only get points if mama and papa only have to remind you once!"
        model.who = "kids"
        model.bucks = 2
        
        model.frequency = "Once-a-day"
        model.timeofday = "Morning"
        model.imageName = "turtlerock"
        return model
    }
    
    public init(
    ){
        self.name = nil
        self.description = nil
        self.bucks = nil
        self.who = nil
        self.frequency = nil
        self.timeofday = nil
        self.imageName = nil
    }
    
    public init?(record: CKRecord) {
        guard
            let _name = record["name"] as? String,
            let _description = record["description"] as? String
            else {
                print("CloudKitModelService.init incomplete record")
                print( "\(record["name"] as? String ?? "Unknown title")")
                return nil
        }
        
        self.recordID = record.recordID
        self.name = _name
        self.description = _description
        self.bucks = record["bucks"] as? Int
        
        self.who = record["who"] as? String
        self.frequency = record["frequency"] as? String
        self.timeofday = record["timeofday"] as? String
        self.imageName = record["imageName"] as? String
    }
    
    enum CustomError: Error {
        case unknown
    }
    
}

// MARK: - Create a CKRecord from this model
extension CKChoreModel {
    
    public var ckRecord: CKRecord? {
        
        let record: CKRecord
        
        if let recordID = recordID {
            record = CKRecord(recordType: CKChoreModel.recordName, recordID: recordID)
        }
        else {
            record = CKRecord(recordType: CKChoreModel.recordName)
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
        
        return record
    }
}


