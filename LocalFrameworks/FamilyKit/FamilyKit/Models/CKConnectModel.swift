//
//  CKConnectModel.swift
//  FamilyKit
//
//  Created by Matthew Schmulen on 7/25/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation
import SwiftUI
import CoreLocation
import CloudKit

public struct CKConnectModel: CKModel {
    
    public typealias ItemType = CKConnectModel
    public static let recordName = "Connect"
    public static let ckSchemeKeys = [
        "name",
        "description",
        "bucks"
    ]
    
    public var id = UUID()
    public var recordID: CKRecord.ID?
    
    public var name: String?
    public var description: String?
    public var bucks: Int?
    
    public var title: String? {
        return name
    }
    
    public static var mock: CKConnectModel {
        var model = CKConnectModel()
        model.name = "new"
        model.description = "some mock information"
        model.bucks = 2
        return model
    }
    
    public init(
    ){
        self.name = nil
        self.description = nil
        self.bucks = nil
    }
    
    public init?(record: CKRecord) {
        guard
            let _name = record["name"] as? String,
            let _description = record["description"] as? String
            else {
                print("CKConnect incomplete record")
                print( "\(record["name"] as? String ?? "Unknown title")")
                return nil
        }
        
        self.recordID = record.recordID
        self.name = _name
        self.description = _description
        self.bucks = record["bucks"] as? Int
    }
    
    enum CustomError: Error {
        case unknown
    }
    
}

// MARK: - Create a CKRecord from this model
extension CKConnectModel {
    
    public var ckRecord: CKRecord? {
        let record: CKRecord
        if let recordID = recordID {
            record = CKRecord(recordType: CKConnectModel.recordName, recordID: recordID)
        }
        else {
            record = CKRecord(recordType: CKConnectModel.recordName)
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
