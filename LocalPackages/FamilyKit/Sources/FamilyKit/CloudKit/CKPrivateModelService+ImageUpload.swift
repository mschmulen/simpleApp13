//
//  CKPrivateModelService+ImageUpload.swift
//  
//
//  Created by Matthew Schmulen on 8/5/20.
//

import Foundation
import SwiftUI
import CloudKit

// MARK: - removeCoverPhoto
extension CKPrivateModelService  {
    
    public func removeCoverPhoto(
        model: T,
        assetPropertyName: String = "coverPhoto",
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


// MARK: - updateCoverPhoto
extension CKPrivateModelService  {
    
    public func updateCoverPhoto(
        model: T,
        image: UIImage,
        assetPropertyName: String = "coverPhoto",
        completion: @escaping ((Result<CKRecord,Error>) -> Void)
    ) {
        
        let tempImageName = "Image_\(UUID().uuidString).jpg"
        // .documentDirectory, .cachesDirectory
        guard let documentsDirectoryPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            completion(.failure(CustomError.unknown))
            return
        }
        let filePath = documentsDirectoryPath.appendingPathComponent(tempImageName)
        print("filePath.absoluteString: \(filePath.absoluteString)")
        
        //if let imageData = image.pngData() else { // PNG save
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("failed to serialize the image")
            completion(.failure(CustomError.unknown))
            return
        }
        
        do {
            try imageData.write(to: filePath, options: .atomic)
        } catch let error {
            print( "failed to write the image data to the disk \(error)")
            completion(.failure(error))
            return
        }
        
        guard let recordID = model.recordID else {
            print( "no record ID !! ")
            completion(.failure(CustomError.unknown))
            return
        }
        
        // fetch and save the update
        container.privateCloudDatabase.fetch(withRecordID: recordID) { record, error in
            if let record = record, error == nil {
                let fileAsset = CKAsset(fileURL: filePath)
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

