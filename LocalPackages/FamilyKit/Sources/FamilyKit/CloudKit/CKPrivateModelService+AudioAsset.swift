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
    
    // TODO update Audio Asset
    public func uploadAudioAsset(
        model: T,
        audioRecording: AudioRecording,
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
                let fileAsset = CKAsset(fileURL: audioRecording.fileURL)
                record[assetPropertyName] = fileAsset
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


