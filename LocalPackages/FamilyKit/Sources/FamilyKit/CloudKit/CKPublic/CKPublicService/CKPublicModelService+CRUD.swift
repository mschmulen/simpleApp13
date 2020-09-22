//
//  CKModelService+CRUD.swift
//  FamilyKit
//
//  Created by Matthew Schmulen on 7/29/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

//import Foundation
//import CloudKit
//
//// MARK: - Create/Update CRUD
//extension CKPublicModelService {
//    
//    public func pushUpdateCreate(
//        model: T,
//        completion: @escaping ((Result<CKRecord,Error>) -> Void)
//    ) {
//        if model.recordID != nil {
//            pushUpdate(model: model) { (result) in
//                completion(result)
//            }
//        } else {
//            pushNew(model: model) { (result) in
//                completion(result)
//            }
//        }
//    }
//    
//    private func pushNew(
//        model: T,
//        completion: @escaping ((Result<CKRecord,Error>) -> Void)
//    ){
//        if let record = model.ckRecord {
//            container.publicCloudDatabase.save(record) { (record, error) in
//                if let error = error {
//                    completion(.failure(error) )
//                }
//                
//                if let record = record {
//                    completion(.success(record) )
//                    self.models.append(model)
//                    self.updateChanges()
//                } else {
//                    completion(.failure(CustomError.unknown))
//                }
//            }//end save
//        }
//    }//end pushNewPublic
//    
//    private func pushUpdate(
//        model: T,
//        completion: @escaping ((Result<CKRecord,Error>) -> Void)
//    ) {
//        
//        guard let recordID = model.recordID else {
//            print( "CANNOT UPDATE A MODEL WITOUT A RECORD ID")
//            completion(.failure(CustomError.unknown))
//            return
//        }
//        
//        // fetch the model and the update the model
//        
//        
//        container.publicCloudDatabase.fetch(withRecordID: recordID) { record, error in
//            if let record = record, error == nil {
//                if let updatedRecord = model.ckRecord {
//                    for key in T.ckSchemeKeys {
//                        record[key] = updatedRecord[key]
//                    }
//                    
//                    self.container.publicCloudDatabase.save(record) { record, error in
//                        if let record = record, error == nil {
//                            completion(.success(record))
//                            self.updateChanges()
//                            return
//                        } else {
//                            completion(.failure(error ?? CustomError.unknown))
//                            return
//                        }
//                    }
//                } else {
//                    print("Could not update the record")
//                    completion(.failure(CustomError.unknown))
//                    return
//                }
//            } else {
//                print("Could not find the record")
//                completion(.failure(CustomError.unknown))
//                return
//            }
//        }
//    }
//}
//
//// MARK: - Delete CRUD
//extension CKPublicModelService  {
//    
//    public func pushDelete(
//        model: T,
//        completion: @escaping ((Result<CKRecord.ID,Error>) -> Void)
//    ){
//        guard let modelRecordID = model.recordID else {
//            completion( .failure(CustomError.unknown))
//            return
//        }
//        container.publicCloudDatabase.delete(withRecordID: modelRecordID) { (recordID, error) in
//            if let recordID = recordID{
//                completion(  .success(recordID) )
//                self.updateChanges()
//            } else {
//                completion(  .failure(CustomError.unknown) )
//            }
//        }
//    }
//}

// TODO: Clean up
//    func add(suggestion: String) {
//        let whistleRecord = CKRecord(recordType: "Suggestions")
//        let reference = CKRecord.Reference(recordID: whistle.recordID, action: .deleteSelf)
//        whistleRecord["text"] = suggestion as CKRecordValue
//        whistleRecord["owningWhistle"] = reference as CKRecordValue
//
//        // more code to come!
//    }



//    public func pushNewPrivate(
//        model: T,
//        completion: ((Result<CKRecord,Error>) -> Void)?
//    ){
//        if let record = model.ckRecord {
//            container.publicCloudDatabase.save(record) { (record, error) in
//                if let error = error {
//                    completion?(.failure(error) )
//                }
//
//                if let record = record {
//                    completion?(.success(record) )
//                } else {
//                    completion?(.failure(CustomError.unknown))
//                }
//            }//end save
//        }
//    }//end pushNewPrivate
