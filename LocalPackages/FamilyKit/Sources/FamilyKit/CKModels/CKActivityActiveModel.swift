//
//  CKActivityActiveModel.swift
//  
//
//  Created by Matthew Schmulen on 8/4/20.
//

import Foundation
import SwiftUI
import CloudKit

public struct CKActivityActiveModel: CKModel {
    
    public typealias ItemType = CKActivityActiveModel
    public static let recordName = "ChoreActive"
    public static let ckSchemeKeys = [
        "ckChoreDescriptionReference",
        "kidReference",
        "coverPhoto"
    ]
    public var id = UUID()
    public var recordID: CKRecord.ID?
    
    public var ckChoreDescriptionReference: CKRecord.Reference?
    public var kidReference: CKRecord.Reference?
    public var coverPhoto: CKAsset?
    
    public var moduleType: ActivityModuleType = ActivityModuleType.picture
    
    // TODO
    public var resultAssetText: CKAsset?
    public var resultAssetImage: CKAsset?
    public var resultAssetAudio: CKAsset?
    
    public var title: String? {
        return "ACTIVE"
    }
    
    public static var mock: CKActivityActiveModel {
        var model = CKActivityActiveModel()
        model.ckChoreDescriptionReference = nil
        model.coverPhoto = nil
        model.resultAssetText = nil
        model.resultAssetImage = nil
        model.resultAssetAudio = nil
        return model
    }
    
    public init(
    ){
        self.ckChoreDescriptionReference = nil
        self.kidReference = nil
        self.coverPhoto = nil
        self.resultAssetText = nil
        self.resultAssetImage = nil
        self.resultAssetAudio = nil
    }
    
    public init?(record: CKRecord) {
//        guard
//            let _name = record["name"] as? String
//            else {
//                print("CKChoreActiveModel incomplete record")
//                print( "\(record["name"] as? String ?? "Unknown title")")
//                return nil
//        }
        
        self.recordID = record.recordID
        self.ckChoreDescriptionReference = record["ckChoreDescriptionReference"] as? CKRecord.Reference
        self.kidReference = record["kidReference"] as? CKRecord.Reference
        self.coverPhoto = record["coverPhoto"] as? CKAsset

        self.resultAssetText = record["resultAssetText"] as? CKAsset
        self.resultAssetImage = record["resultAssetImage"] as? CKAsset
        self.resultAssetAudio = record["resultAssetAudio"] as? CKAsset
        
        if let moduleTypeString =  record["moduleType"] as? String {
            self.moduleType = ActivityModuleType(rawValue: moduleTypeString) ?? ActivityModuleType.drawing
        }
    }
    
    enum CustomError: Error {
        case unknown
    }
    
}

// TODO: add this to the generic CKModel requirement
extension CKActivityActiveModel {
    
    // TODO: add this to the generic CKModel requirement
    public func reload( service: CKPrivateModelService<CKActivityActiveModel> ) {
        service.fetchSingle(model: self) { result in
            print( "result \(result)")
        }
    }
}

// MARK: - Create a CKRecord from this model
extension CKActivityActiveModel {
    
    public var ckRecord: CKRecord? {
        
        let record: CKRecord
        
        if let recordID = recordID {
            record = CKRecord(recordType: CKActivityActiveModel.recordName, recordID: recordID)
        }
        else {
            record = CKRecord(recordType: CKActivityActiveModel.recordName)
        }

        if let ckChoreDescriptionReference = ckChoreDescriptionReference {
            record["ckChoreDescriptionReference"] = ckChoreDescriptionReference as CKRecordValue
        }
        
        if let kidReference = kidReference {
            record["kidReference"] = kidReference as CKRecordValue
        }
        
        if let coverPhoto = coverPhoto {
            record["coverPhoto"] = coverPhoto as CKRecordValue
        }
        
        if let resultAssetText = resultAssetText {
            record["resultAssetText"] = resultAssetText as CKRecordValue
        }
        
        if let resultAssetImage = resultAssetImage {
            record["resultAssetImage"] = resultAssetImage as CKRecordValue
        }

        if let resultAssetAudio = resultAssetAudio {
            record["resultAssetAudio"] = resultAssetAudio as CKRecordValue
        }
        
        return record
    }
}
