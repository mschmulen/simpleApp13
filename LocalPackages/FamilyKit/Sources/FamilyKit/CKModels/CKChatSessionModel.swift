//
//  CKChatSessionGroupModel.swift
//  
//
//  Created by Matthew Schmulen on 8/5/20.
//

import Foundation
import SwiftUI
import CloudKit

public struct CKChatSessionModel: CKModel {
    
    public typealias ItemType = CKChatSessionModel
    public static let recordName = "ChatSession"
    public static let ckSchemeKeys = [
        "name"
    ]
    

    public var id = UUID()
    public var recordID: CKRecord.ID?
    
    public var name: String?
    
    public var title: String? {
        return name
    }
    
    public static var mock: CKChatSessionModel {
        var model = CKChatSessionModel()
        model.name = "Get ready for bed"
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
                print("CKChatSessionDirectModel incomplete record")
                print( "\(record["name"] as? String ?? "Unknown title")")
                return nil
        }
        
        self.recordID = record.recordID
        self.name = _name
    }
    
    enum CustomError: Error {
        case unknown
    }
    
}

// TODO: add this to the generic CKModel requirement
extension CKChatSessionModel {
    
    // TODO: add this to the generic CKModel requirement
    public func reload( service: CKPrivateModelService<CKChatSessionModel> ) {
        service.fetchSingle(model: self) { result in
            print( "result \(result)")
        }
    }
}

// MARK: - Create a CKRecord from this model
extension CKChatSessionModel {
    
    public var ckRecord: CKRecord? {
        
        let record: CKRecord
        
        if let recordID = recordID {
            record = CKRecord(recordType: CKChatSessionModel.recordName, recordID: recordID)
        }
        else {
            record = CKRecord(recordType: CKChatSessionModel.recordName)
        }
        
        if let name = name {
            record["name"] = name as CKRecordValue
        }
        
        return record
    }
}


