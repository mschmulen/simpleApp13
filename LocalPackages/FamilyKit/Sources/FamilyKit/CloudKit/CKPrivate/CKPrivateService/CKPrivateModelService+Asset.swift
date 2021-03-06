//
//  CKPrivateModelService+AssetUpload.swift
//  
//
//  Created by Matthew Schmulen on 8/5/20.
//

import Foundation
import SwiftUI
import CloudKit

// MARK: - remove Asset
extension CKPrivateModelService {
    
    public func removeAsset(
        model: T,
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
                record[assetPropertyName] = nil
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


// MARK: - uploadPhoto
extension CKPrivateModelService  {
    
    public func uploadPhotoAsset(
        model: T,
        image: UIImage,
        assetPropertyName: String,
        completion: @escaping ((Result<T,Error>) -> Void)
    ) {
        
        guard let recordID = model.recordID else {
            completion(.failure(CustomError.unknown))
            return
        }
        
        let tempImageName = "Image_\(UUID().uuidString).jpg"
        // .documentDirectory, .cachesDirectory
        guard let documentsDirectoryPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            completion(.failure(CustomError.unknown))
            return
        }
        let filePath = documentsDirectoryPath.appendingPathComponent(tempImageName)
        
        //if let imageData = image.pngData() else { // PNG save
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(CustomError.unknown))
            return
        }
        
        do {
            try imageData.write(to: filePath, options: .atomic)
        } catch let error {
            completion(.failure(error))
            return
        }
        
        // fetch and save the update
        container.privateCloudDatabase.fetch(withRecordID: recordID) { record, error in
            if let record = record, error == nil {
                let fileAsset = CKAsset(fileURL: filePath)
                record[assetPropertyName] = fileAsset
                self.container.privateCloudDatabase.save(record) { record, error in
                    if let record = record, error == nil, let updatedModel = T(record: record) {
                        self.updateChanges()
                        completion(.success(updatedModel) )
                        return
                    } else {
                        completion(.failure(error ?? CustomError.unknown))
                        return
                    }
                }
            } else {
                completion(.failure(CustomError.unknown))
            }
        }
    }
}

// MARK: - uploadFileAsset
extension CKPrivateModelService  {
    
    public func uploadFileAsset(
        model: T,
        fileURL: URL,
        assetPropertyName: String,
        completion: @escaping ((Result<T,Error>) -> Void)
    ) {
        guard let recordID = model.recordID else {
            completion(.failure(CustomError.unknown))
            return
        }
        
        // fetch and save the update
        container.privateCloudDatabase.fetch(withRecordID: recordID) { record, error in
            if let record = record, error == nil {
                let fileAsset = CKAsset(fileURL: fileURL)
                record[assetPropertyName] = fileAsset
                self.container.privateCloudDatabase.save(record) { record, error in
                    if let record = record, error == nil, let updatedModel = T(record: record) {
                        self.updateChanges()
                        completion(.success(updatedModel) )
                        return
                    } else {
                        completion(.failure(error ?? CustomError.unknown))
                        return
                    }
                }
            } else {
                completion(.failure(CustomError.unknown))
            }
        }
    }
}

// MARK: - AudioAsset
extension CKPrivateModelService  {
    
    public func uploadAudioAsset(
        model: T,
        audioRecording: AudioRecording,
        assetPropertyName: String,
        completion: @escaping ((Result<T,Error>) -> Void)
    ) {
        guard let recordID = model.recordID else {
            completion(.failure(CustomError.unknown))
            return
        }
        
        // fetch and save the update
        container.privateCloudDatabase.fetch(withRecordID: recordID) { record, error in
            if let record = record, error == nil {
                let fileAsset = CKAsset(fileURL: audioRecording.fileURL)
                record[assetPropertyName] = fileAsset
                self.container.privateCloudDatabase.save(record) { record, error in
                    if let record = record, error == nil, let updatedModel = T(record: record) {
                        self.updateChanges()
                        completion(.success(updatedModel) )
                        return
                    } else {
                        completion(.failure(error ?? CustomError.unknown))
                        return
                    }
                }
            } else {
                completion(.failure(CustomError.unknown))
            }
        }
    }
}
