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
        "title",
        "name"
    ]
    
    public var id = UUID()
    public var recordID: CKRecord.ID?
    
    public var title: String?
    public var name: String?

    public static var mock: CKKidModel {
        var model = CKKidModel()
        model.title = "new"
        model.name = "some mock name"
        return model
    }
    
    public init(
    ){
        self.title = "new title"
        self.name = "new name"
    }
    
    public init?(record: CKRecord) {
        guard
            let _title = record["title"] as? String,
            let _name = record["name"] as? String
            else {
                print("CloudKitModelService.init incomplete record")
                print( "\(record["title"] as? String ?? "Unknown title")")
                return nil
        }
        
        self.recordID = record.recordID
        self.title = _title
        self.name = _name
    }
    
    enum CustomError: Error {
        case unknown
    }
    
}

// MARK: - Create a CKRecord from this model
extension CKKidModel {
    
    public var ckRecord: CKRecord? {
        //        guard let recordID = recordID else {
        //            return nil
        //        }
        
        let record: CKRecord
        if let recordID = recordID {
            record = CKRecord(recordType: CKKidModel.recordName, recordID: recordID)
        }
        else {
            record = CKRecord(recordType: CKKidModel.recordName)
        }
        if let title = title {
            record["title"] = title as CKRecordValue
        }
        
        if let name = name {
            record["name"] = name as CKRecordValue
        }
        
        return record
    }
}
