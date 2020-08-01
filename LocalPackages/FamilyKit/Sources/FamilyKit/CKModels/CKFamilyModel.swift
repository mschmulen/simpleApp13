//
//  CKFamilyModel.swift
//  
//
//  Created by Matthew Schmulen on 8/1/20.
//

import Foundation
import SwiftUI
import CoreLocation
import CloudKit

public struct CKFamilyModel: CKModel {
    
    public typealias ItemType = CKFamilyModel
    public static let recordName = "Family"
    public static let ckSchemeKeys = [
        "name"
    ]
    
    public var id = UUID()
    public var recordID: CKRecord.ID?
    
    public var name: String?
    
    public var title: String? {
        return name
    }
    
    public static var mock: CKFamilyModel {
        var model = CKFamilyModel()
        model.name = "mock family"
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
                print("CKFamilyModel incomplete record")
                print( "\(record["name"] as? String ?? "no name")")
                return nil
        }
        
        self.recordID = record.recordID
        self.name = _name
    }
    
    enum CustomError: Error {
        case unknown
    }
    
}

// MARK: - Create a CKRecord from this model
extension CKFamilyModel {
    
    public var ckRecord: CKRecord? {
        let record: CKRecord
        if let recordID = recordID {
            record = CKRecord(recordType: CKFamilyModel.recordName, recordID: recordID)
        }
        else {
            record = CKRecord(recordType: CKFamilyModel.recordName)
        }
        
        if let name = name {
            record["name"] = name as CKRecordValue
        }
        
        return record
    }
}
