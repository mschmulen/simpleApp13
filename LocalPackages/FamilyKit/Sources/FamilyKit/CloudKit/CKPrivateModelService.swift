//
//  CKPrivateModelService.swift
//  FamilyKit
//
//  Created by Matthew Schmulen on 7/25/20.
//  Copyright © 2020 jumptack. All rights reserved.
//


import SwiftUI
import Combine
import CloudKit

/**

 Usage:
 
 var container = CKContainer.default()
 container = CKContainer(identifier: CKContainerIdentifier)
 
 let service = CloudKitModelService<CKSimpleModel>(container: container)
 service.fetch(completion: { result in
     print( "fetch result \(result)")
     switch result {
     case .success(let models) :
         print( "success \(models)")
     case .failure(let error):
         print( "error \(error)")
     }
 })
 service.subscribe()
 service.listenForNotifications()
*/
public final class CKPrivateModelService<T>: ObservableObject where T:CKModel {
    
    public let objectWillChange = ObservableObjectPublisher()
    
    internal var container: CKContainer
    
    @Published public var models: [T] = [] {
        willSet {
            updateChanges()
        }
    }
        
    public init(container: CKContainer) {
        self.container = container
    }
    
    enum CustomError: Error {
        case unknown
        case cursorFailure
    }
    
    internal func updateChanges() {
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
}

// TODO containerConfig:CKContainerConfig = .publicCloudDatabase
extension CKPrivateModelService {

    public func fetch(
        completion: @escaping (Result<T, Error>) -> ()
    ) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: T.recordName, predicate: predicate)
        
        queryRecords(
            query: query,
            resultsLimit: 50,
            enablePaging: true,
            completion: { result in
                switch result {
                case .success(let models) :
                    DispatchQueue.main.async {
                        // TODO merge the model list together
                        self.models = models
                    }
                case .failure(let error) :
                    print( "failure \(error)")
                }
        })
    }//end fetchPrivate
    
    func queryRecords(
        query: CKQuery,
        resultsLimit: Int,
        enablePaging: Bool,
        completion: @escaping (Result<[T], Error>) -> (),
        errorHandler: ((_ error: Error) -> Void)? = nil
    ) {
//        if !(query.sortDescriptors != nil) {
//            query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
//        }
        let operation = CKQueryOperation(query: query)
        var results = [T]()
        operation.recordFetchedBlock = { record in
            if let model = T( record: record) {
                results.append(model)
            }
        }
        
        operation.queryCompletionBlock = { cursor, error in
            if cursor != nil && enablePaging == true {
                self.queryRecords(
                    cursor: cursor!,
                    resultsLimit: resultsLimit,
                    continueWithResults: results,
                    completion: completion,
                    errorHandler: errorHandler
                )
            } else {
                completion(.success(results))
            }
        }
        operation.resultsLimit = resultsLimit
        container.privateCloudDatabase.add(operation)
    }
    
    private func queryRecords(
        cursor: CKQueryOperation.Cursor,
        resultsLimit: Int,
        continueWithResults:[T],
        completion: @escaping (Result<[T], Error>) -> (),
        errorHandler:((_ error: Error) -> Void)? = nil
    ) {
        var results = continueWithResults
        let operation = CKQueryOperation(cursor: cursor)
        operation.recordFetchedBlock = { record in
            //            if let parsed = self.fromCKRecord(record) as? T  { results.append(parsed) }
//            guard
//                let nameShort = record["nameShort"] as? String,
//                let lat = record["geoLatitude"] as? Double,
//                let long = record["geoLongitude"] as? Double,
//                //let category = record["category"] as? String,
//                let info = record["info"] as? String,
//                let countryCode = record["countryCode"] as? String
//
//                else {
//                    print("CloudKitModelService.updateAllModels incomplete record")
//                    print( "\(record["nameShort"] as? String ?? "Unknown short name")")
//                    return
//            }
            if let model = T( record: record) {
                results.append(model)
            }
            
        }
        
        operation.queryCompletionBlock = { cursor, error in
            if cursor != nil {
                self.queryRecords(
                    cursor: cursor!,
                    resultsLimit: resultsLimit,
                    continueWithResults: results,
                    completion: completion,
                    errorHandler: errorHandler
                )
            } else {
                completion(.success(results))
            }
        }
        operation.resultsLimit = resultsLimit
        container.privateCloudDatabase.add(operation)
    }
}


extension CKPrivateModelService {
    public func fetchSingle(
        model: T,
        completion: @escaping ((Result<T,Error>) -> Void)
    ) {
        if let recordID = model.recordID {
            container.privateCloudDatabase.fetch(withRecordID: recordID) { (record, error) in
                if let record = record, let model = T( record: record) {
                    completion(.success(model))
                } else {
                    completion(.failure(CustomError.unknown))
                }
            }
        } else {
            completion(.failure(CustomError.unknown))
        }
    }
}
