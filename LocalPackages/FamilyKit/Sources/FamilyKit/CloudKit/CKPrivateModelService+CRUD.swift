//
//  CKPrivateModelService+CRUD.swift
//  FamilyKit
//
//  Created by Matthew Schmulen on 7/29/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation
import CloudKit

// MARK: - Create/Update CRUD
extension CKPrivateModelService {
    
    public func pushUpdateCreate(
        model: T,
        completion: @escaping ((Result<T,Error>) -> Void)
    ) {
        if model.recordID != nil {
            pushUpdate(model: model) { (result) in
                completion(result)
            }
        } else {
            pushNew(model: model) { (result) in
                completion(result)
            }
        }
    }
    
    private func pushNew(
        model: T,
        completion: @escaping ((Result<T,Error>) -> Void)
    ){
        if let record = model.ckRecord {
            container.privateCloudDatabase.save(record) { (record, error) in
                if let error = error {
                    completion(.failure(error) )
                }
                
                if let record = record {
                    if let newModel = T(record: record) {
                        completion(.success(newModel) )
                        
                        // immediately add it to the local list
                        self.models.append(newModel)
                        
                        self.updateChanges()
                    } else {
                        completion(.failure(CustomError.unknown))
                    }
                } else {
                    completion(.failure(CustomError.unknown))
                }
            }//end save
        }
    }//end pushNewPublic
    
    private func pushUpdate(
        model: T,
        completion: @escaping ((Result<T,Error>) -> Void)
    ) {
        
        guard let recordID = model.recordID else {
            print( "CANNOT UPDATE A MODEL WITOUT A RECORD ID")
            completion(.failure(CustomError.unknown))
            return
        }
        
        guard let record = model.ckRecord else {
            print( "CANNOT UPDATE A MODEL WITOUT A CKRecord")
            completion(.failure(CustomError.unknown))
            return
        }
        
        container.privateCloudDatabase.fetch(withRecordID: recordID) { record, error in
            if let record = record, error == nil {
                if let updatedRecord = model.ckRecord {
                    for key in T.ckSchemeKeys {
                        record[key] = updatedRecord[key]
                    }
                    
                    self.container.privateCloudDatabase.save(record) { record, error in
                        if let record = record, error == nil {
                            if let updatedModel = T(record: record) {
                                print( "push updatedModel \(updatedModel)")
                                completion(.success(updatedModel) )
                                
                                // TODO: can you just update this model in the list
                                self.updateChanges()
                            } else {
                                completion(.failure(CustomError.unknown))
                            }
                            return
                        } else {
                            completion(.failure(error ?? CustomError.unknown))
                            return
                        }
                    }
                } else {
                    print("Could not update the record")
                    completion(.failure(CustomError.unknown))
                    return
                }
            } else {
                print("Could not find the record")
                completion(.failure(CustomError.unknown))
                return
            }
        }
    }
}

// MARK: - Delete CRUD
extension CKPrivateModelService  {
    
    public func pushDelete(
        model: T,
        completion: @escaping ((Result<CKRecord.ID,Error>) -> Void)
    ){
        guard let modelRecordID = model.recordID else {
            completion( .failure(CustomError.unknown))
            return
        }
        
        container.privateCloudDatabase.delete(withRecordID: modelRecordID) { (recordID, error) in
            if let recordID = recordID{
                completion(  .success(recordID) )
                self.updateChanges()
            } else {
                completion(  .failure(CustomError.unknown) )
            }
        }
        
        // immediately remove if from the local list
        models.removeAll { (model) -> Bool in
            model.recordID == modelRecordID
        }
        self.updateChanges()
    }
}
