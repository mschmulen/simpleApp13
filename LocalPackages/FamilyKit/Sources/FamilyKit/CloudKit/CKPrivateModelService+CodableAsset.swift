//
//  File.swift
//  
//
//  Created by Matthew Schmulen on 8/9/20.
//

import Foundation
import SwiftUI
import CloudKit

// MARK: - AudioAsset
extension CKPrivateModelService  {
    
    // TODO update Codable Asset
    public func uploadCodableAsset(
        model: T,
        codableAsset: Codable,
        assetPropertyName: String,
        completion: @escaping ((Result<CKRecord,Error>) -> Void)
    ) {
        guard let recordID = model.recordID else {
            print( "no record ID !! ")
            completion(.failure(CustomError.unknown))
            return
        }
        
        // fetch and save the update
        container.privateCloudDatabase.fetch(withRecordID: recordID) { record, error in
            if let record = record, error == nil {
                let serializedResource = try? JSONSerialization.data(withJSONObject: codableAsset, options: [])
                record[assetPropertyName] = serializedResource
                self.container.privateCloudDatabase.save(record) { record, error in
                    if let record = record, error == nil {
                        completion(.success(record))
                    } else {
                        completion(.failure(error ?? CustomError.unknown))
                    }
                }
            } else {
                completion(.failure(CustomError.unknown))
            }
        }
    }
}
