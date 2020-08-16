//
//  CKPlayerModel.swift
//  
//
//  Created by Matthew Schmulen on 8/13/20.
//

import Foundation
import SwiftUI
import CloudKit

// TODO: Should have been named CKPerson
public struct CKPlayerModel: CKModel {
    
    public typealias ItemType = CKPlayerModel
    public static let recordName = "Player"
    public static let ckSchemeKeys = [
        "name",
        "bucks",
        "dateOfBirth",
        "emoji",
        "isAdult"
    ]
    
    public var id = UUID()
    public var recordID: CKRecord.ID?
    
    public var name: String?
    public var bucks: Int?
    public var dateOfBirth: Date?
    public var emoji: String?
    
    public var isAdult: Bool?
    
    // TODO: finish the cover photo for the kid
    //public var coverPhoto: CKAsset?
    
    public var title: String? {
        return name
    }
    
    public static var mock: CKPlayerModel {
        var model = CKPlayerModel()
        model.name = "mock Adult"
        model.isAdult = true
        model.bucks = 3
        model.dateOfBirth = Calendar.current.date(byAdding: .year, value: -5, to: Date())! // 5 years old
        model.emoji = "😀"
        return model
    }
        
    public static var mockKid: CKPlayerModel {
        var model = CKPlayerModel()
        model.name = "mock kid"
        model.isAdult = false
        model.bucks = 3
        model.dateOfBirth = Calendar.current.date(byAdding: .year, value: -5, to: Date())! // 5 years old
        model.emoji = "😀"
        return model
    }
    
    public init(
    ){
        self.name = nil
        self.bucks = nil
        self.dateOfBirth = nil
        self.emoji = nil
        self.isAdult = nil
        //self.coverPhoto = nil
    }
    
    public init?(record: CKRecord) {
        guard
            let _name = record["name"] as? String
            else {
                print("CKPlayerModel incomplete record")
                print( "\(record["name"] as? String ?? "no name")")
                return nil
        }
        
        self.recordID = record.recordID
        self.name = _name
        self.bucks = record["bucks"] as? Int
        self.emoji = record["emoji"] as? String
        self.dateOfBirth = record["dateOfBirth"] as? Date
        if let isAdultValue = record["isAdult"] as? Int {
            if isAdultValue == 1 {
                self.isAdult = true
            } else {
                self.isAdult = false
            }
        }
    }
    
    enum CustomError: Error {
        case unknown
    }
    
}

// MARK: - mutating functions
extension CKPlayerModel {
    
    mutating public func mutateBucks( newBucks:Int ) {
        self.bucks = newBucks
    }
    
}

// MARK: - Create a CKRecord from this model
extension CKPlayerModel {
    
    public var ckRecord: CKRecord? {
        let record: CKRecord
        if let recordID = recordID {
            record = CKRecord(recordType: CKPlayerModel.recordName, recordID: recordID)
        }
        else {
            record = CKRecord(recordType: CKPlayerModel.recordName)
        }
        
        if let name = name {
            record["name"] = name as CKRecordValue
        }
        
        if let bucks = bucks {
            record["bucks"] = bucks as CKRecordValue
        }
        
        if let emoji = emoji {
            record["emoji"] = emoji as CKRecordValue
        }
        
        if let dateOfBirth = dateOfBirth {
            record["dateOfBirth"] = dateOfBirth as CKRecordValue
        }
        
        if let isAdult = isAdult {
            record["isAdult"] = isAdult as CKRecordValue
        }
        
        return record
    }
}





