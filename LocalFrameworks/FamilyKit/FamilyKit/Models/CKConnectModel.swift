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
        "title",
        "info",
        "tags"
    ]
    
    public var id = UUID()
    public var recordID: CKRecord.ID?
    
    public var title: String?
    public var info: String?
    public var tags: [String]?

    public static var mock: CKConnectModel {
        var model = CKConnectModel()
        model.title = "new"
        model.info = "some mock information"
        return model
    }
    
    public init(
    ){
        self.title = "new title"
        self.info = "new info"
        self.tags = nil
    }
    
    public init?(record: CKRecord) {
        guard
            let _title = record["title"] as? String,
            let _info = record["info"] as? String
            else {
                print("CloudKitModelService.init incomplete record")
                print( "\(record["title"] as? String ?? "Unknown title")")
                return nil
        }
        
        self.recordID = record.recordID
        self.title = _title
        self.info = _info
        
        self.tags = record["tags"] as? [String]
    }
    
    enum CustomError: Error {
        case unknown
    }
    
}

// MARK: - Create a CKRecord from this model
extension CKConnectModel {
    
    public var ckRecord: CKRecord? {
        //        guard let recordID = recordID else {
        //            return nil
        //        }
        
        let record: CKRecord
        if let recordID = recordID {
            record = CKRecord(recordType: CKConnectModel.recordName, recordID: recordID)
        }
        else {
            record = CKRecord(recordType: CKConnectModel.recordName)
        }
        if let title = title {
            record["title"] = title as CKRecordValue
        }
        
        if let tags = tags {
            record["tags"] = tags as CKRecordValue
        }
                
        return record
    }
}
