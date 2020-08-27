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
//public struct CKPlayerModel: CKModel {
public final class CKPlayerModel: CKModel, ObservableObject {
    
    public static func == (lhs: CKPlayerModel, rhs: CKPlayerModel) -> Bool {
        return lhs.id == rhs.id
    }
    public func hash(into hasher: inout Hasher) { hasher.combine(id) }
    
    public typealias ItemType = CKPlayerModel
    public static let recordName = "Player"
    public static let ckSchemeKeys = [
        "name",
        "bucks",
        "dateOfBirth",
        "emoji",
        "isAdult",
        "playerType"
    ]
    
    public var id = UUID()
    public var recordID: CKRecord.ID?
    
    public var name: String?
    public var bucks: Int?
    public var dateOfBirth: Date?
    public var emoji: String?
    
    // TODO: change this to a computed property and remove it from the database instead use the PlayerType
    public var isAdult: Bool
    
    public enum PlayerType: String {
        case adultCustodian // this is basically admin
        case adult
        case kid
        case unknown
    }
    public var playerType: PlayerType = .unknown
    
    // TODO: finish the cover photo for the kid
    //public var coverPhoto: CKAsset?
    
    public var title: String? {
        return name
    }
    
    public var recordReference: CKRecord.Reference? {
        if let recordID = self.recordID {
            return CKRecord.Reference(recordID: recordID, action: .deleteSelf)
        } else {
            return nil
        }
    }
    
    public static var mock: CKPlayerModel {
        var model = CKPlayerModel()
        model.name = "mock Adult"
        model.isAdult = true
        model.bucks = 3
        model.dateOfBirth = Calendar.current.date(byAdding: .year, value: -5, to: Date())! // 5 years old
        model.emoji = "😀"
        model.playerType = .adult
        return model
    }
    
    public static var mockKid: CKPlayerModel {
        var model = CKPlayerModel()
        model.name = "mock kid"
        model.isAdult = false
        model.bucks = 3
        model.dateOfBirth = Calendar.current.date(byAdding: .year, value: -5, to: Date())! // 5 years old
        model.emoji = "😀"
        model.playerType = .kid
        return model
    }
    
    public init(
    ){
        self.name = nil
        self.bucks = nil
        self.dateOfBirth = nil
        self.emoji = nil
        self.isAdult = false
        self.playerType = .kid
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
        } else {
            self.isAdult = false
        }
        
        if let playerTypeValue = record["playerType"] as? String,
            let playerTypeEnum = PlayerType.init(rawValue: playerTypeValue) {
            self.playerType = playerTypeEnum
        } else {
            if self.isAdult {
                self.playerType = .adult
            } else {
                self.playerType = .kid
            }
        }
    }
    
    enum CustomError: Error {
        case unknown
    }
    
}

// MARK: - mutating functions
//extension CKPlayerModel {
//    
//    mutating public func mutateBucks( newBucks:Int ) {
//        self.bucks = newBucks
//    }
//    
//}

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
        
        record["isAdult"] = isAdult as CKRecordValue
        
        record["playerType"] = playerType.rawValue as CKRecordValue
        
        return record
    }
}




