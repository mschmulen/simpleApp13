//
//  CKChatSessionDirectModel.swift
//  
//
//  Created by Matthew Schmulen on 8/5/20.
//

import Foundation
import SwiftUI
import CloudKit

public struct CKChatSessionDirectModel: CKModel {
    
    public typealias ItemType = CKChatSessionDirectModel
    public static let recordName = "ChatSessionDirect"
    public static let ckSchemeKeys = [
        "person1",
        "person2"
    ]
    
    public var id = UUID()
    public var recordID: CKRecord.ID?
    
    public var person1: String?
    public var person2: String?
    
    public var title: String? {
        return person1
    }
    
    public static var mock: CKChatSessionDirectModel {
        var model = CKChatSessionDirectModel()
        model.person1 = "mock 1"
        model.person2 = "mock 2"
        return model
    }
    
    public init(
    ){
        self.person1 = nil
        self.person2 = nil
    }
    
    public init?(record: CKRecord) {
        guard
            let _person1 = record["person1"] as? String,
            let _person2 = record["person2"] as? String
            else {
                print("CKChatSessionDirectModel incomplete record")
                print( "\(record["person1"] as? String ?? "Unknown title")")
                return nil
        }
        
        self.recordID = record.recordID
        self.person1 = _person1
        self.person2 = _person2
    }
    
    enum CustomError: Error {
        case unknown
    }
    
}

// TODO: add this to the generic CKModel requirement
extension CKChatSessionDirectModel {

    // TODO: add this to the generic CKModel requirement
    public func reload( service: CKPrivateModelService<CKChatSessionDirectModel> ) {
        service.fetchSingle(model: self) { result in
            print( "result \(result)")
        }
    }
}

// MARK: - Create a CKRecord from this model
extension CKChatSessionDirectModel {
    
    public var ckRecord: CKRecord? {
        
        let record: CKRecord
        
        if let recordID = recordID {
            record = CKRecord(recordType: CKChatSessionDirectModel.recordName, recordID: recordID)
        }
        else {
            record = CKRecord(recordType: CKChatSessionDirectModel.recordName)
        }
        
        if let person1 = person1 {
            record["person1"] = person1 as CKRecordValue
        }
        
        if let person2 = person2 {
            record["person2"] = person2 as CKRecordValue
        }
        
        return record
    }
}

