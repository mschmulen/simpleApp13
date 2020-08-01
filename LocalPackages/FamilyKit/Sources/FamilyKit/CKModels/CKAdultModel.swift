//
//  CKAdultModel.swift
//  FamilyKit
//
//  Created by Matthew Schmulen on 7/30/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation
import SwiftUI
import CloudKit

public struct CKAdultModel: CKModel {
    
    public typealias ItemType = CKAdultModel
    public static let recordName = "Adult"
    public static let ckSchemeKeys = [
        "name",
        "bucks",
        "dateOfBirth",
        "emoji"
    ]
    
    public var id = UUID()
    public var recordID: CKRecord.ID?
    
    public var name: String?
    public var bucks: Int?
    public var dateOfBirth: Date?
    public var emoji: String?
    
    public var title: String? {
        return name
    }
    
    public static var mock: CKAdultModel {
        var model = CKAdultModel()
        model.name = "mock adult"
        model.bucks = 3
        model.dateOfBirth = Calendar.current.date(byAdding: .year, value: -30, to: Date())! // 30 years old
        model.emoji = "😀"
        return model
    }
    
    public init(
    ){
        self.name = nil
        self.bucks = nil
        self.dateOfBirth = nil
        self.emoji = nil
    }
    
    public init?(record: CKRecord) {
        guard
            let _name = record["name"] as? String
            else {
                print("CKAdultModel incomplete record")
                print( "\(record["name"] as? String ?? "no name")")
                return nil
        }
        
        self.recordID = record.recordID
        self.name = _name
        self.bucks = record["bucks"] as? Int
        self.dateOfBirth = record["dateOfBirth"] as? Date
        self.emoji = record["emoji"] as? String
    }
    
    enum CustomError: Error {
        case unknown
    }
    
}

// MARK: - Create a CKRecord from this model
extension CKAdultModel {
    
    public var ckRecord: CKRecord? {
        let record: CKRecord
        if let recordID = recordID {
            record = CKRecord(recordType: CKAdultModel.recordName, recordID: recordID)
        }
        else {
            record = CKRecord(recordType: CKAdultModel.recordName)
        }
        
        if let name = name {
            record["name"] = name as CKRecordValue
        }
        
        if let bucks = bucks {
            record["bucks"] = bucks as CKRecordValue
        }
        
        if let dateOfBirth = dateOfBirth {
            record["dateOfBirth"] = dateOfBirth as CKRecordValue
        }
        
        if let emoji = emoji {
            record["emoji"] = emoji as CKRecordValue
        }
        
        return record
    }
}
