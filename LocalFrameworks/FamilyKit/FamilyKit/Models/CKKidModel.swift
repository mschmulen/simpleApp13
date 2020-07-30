//
//  CKKidModel.swift
//  FamilyKit
//
//  Created by Matthew Schmulen on 7/25/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation
import SwiftUI
import CoreLocation
import CloudKit

public struct CKKidModel: CKModel {
    
    public typealias ItemType = CKKidModel
    public static let recordName = "Kid"
    public static let ckSchemeKeys = [
        "name",
        "bucks"
    ]
    
    public var id = UUID()
    public var recordID: CKRecord.ID?

    public var name: String?
    public var bucks: Int?
    
    public var title: String? {
        return name
    }

    public static var mock: CKKidModel {
        var model = CKKidModel()
        model.name = "mock name"
        return model
    }
    
    public init(
    ){
        self.name = nil
    }
    
    public init?(record: CKRecord) {
        guard
            let _name = record["name"] as? String
            else {
                print("CKKidModel incomplete record")
                print( "\(record["name"] as? String ?? "no name")")
                return nil
        }
        
        self.recordID = record.recordID
        self.name = _name
        self.bucks = record["bucks"] as? Int
    }
    
    enum CustomError: Error {
        case unknown
    }
    
}

// MARK: - Create a CKRecord from this model
extension CKKidModel {
    
    public var ckRecord: CKRecord? {
        let record: CKRecord
        if let recordID = recordID {
            record = CKRecord(recordType: CKKidModel.recordName, recordID: recordID)
        }
        else {
            record = CKRecord(recordType: CKKidModel.recordName)
        }
        
        if let name = name {
            record["name"] = name as CKRecordValue
        }
        
        if let bucks = bucks {
            record["bucks"] = bucks as CKRecordValue
        }
        
        return record
    }
}
