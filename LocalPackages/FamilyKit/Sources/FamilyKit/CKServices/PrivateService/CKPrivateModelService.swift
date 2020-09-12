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

// TODO: Rename ModelServiceSearchPredicate
public enum SearchPredicate {
    
    case predicateTrue
    case customEqualsSearch( searchKey: String, searchValue: String)
    case customContainsSearch( searchKey: String, searchValue: String)
    
    var predicate: NSPredicate {
        switch self {
        case .predicateTrue:
            return NSPredicate(value: true)
        case .customEqualsSearch(let searchKey, let searchValue):
            return NSPredicate(format: "\(searchKey) == %@", searchValue)
        case .customContainsSearch(let searchKey, let searchValue):
            return NSPredicate(format: "\(searchKey) CONTAINS %@", searchValue)
        }
    }
}

// TODO: Rename ModelServiceSortDescriptor
public enum SortDescriptor {
    
    /// custom "modificationDate", "creationDate",
    /// note: ascending false for a date is most recent first
    case custom(key: String, ascending:Bool )
    case none
    
    var sortDescriptors: [NSSortDescriptor] {
        switch self {
        case .custom(let key, let ascending):
            return [NSSortDescriptor(key: key, ascending: ascending)]
        case .none:
            // TODO: Matt I think you hacked this for debug and you need to find out where and why so you can move it back to empty, but for now its fine
            return [NSSortDescriptor]()
            //                return [NSSortDescriptor(key: "modificationDate", ascending: false)]
        }
    }
}

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


public enum CloudKitContainer {
    case CloudContainer(_ container: CKContainer)
    case MockContainer(_ container: CKContainer)
}

public final class CKPrivateModelService<T>: ObservableObject where T:CKModel {
    
    public let objectWillChange = ObservableObjectPublisher()
    
    internal var container: CKContainer
    
    @Published public var models: [T] = [] {
        willSet {
            updateChanges()
        }
    }
    
    public init(container: CloudKitContainer) {
        switch container {
        case .CloudContainer(let container):
            self.container = container
        case .MockContainer(let container):
            self.container = container
        }
    }
    
    internal func updateChanges() {
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
}

extension CKPrivateModelService {
    
    public func fetch(
        sortDescriptor: SortDescriptor,
        searchPredicate: SearchPredicate,
        // TODO add resultsLimit
        completion: @escaping (Result<[T], Error>) -> ()
    ) {
        let query = CKQuery(recordType: T.recordName, predicate: searchPredicate.predicate)
        query.sortDescriptors = sortDescriptor.sortDescriptors
        
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
                        completion(.success(models))
                    }
                case .failure(let error) :
                    completion(.failure(error))
                }
        })
    }//end fetchPrivate
    
    internal func queryRecords(
        query: CKQuery,
        resultsLimit: Int,
        enablePaging: Bool,
        completion: @escaping (Result<[T], Error>) -> (),
        errorHandler: ((_ error: Error) -> Void)? = nil
    ) {
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
                    completion(.failure( CustomError.make(error: (error as NSError?))))
                }
            }
        } else {
            completion(.failure(CustomError.unknown))
        }
    }
}

extension CKPrivateModelService {
    
    public func fetchByReference (
        modelReference: CKRecord.Reference,
        completion: @escaping ((Result<T,Error>) -> Void)
    ) {
        let recordID = modelReference.recordID
        container.privateCloudDatabase.fetch(withRecordID: recordID) { (record, error) in
            if let record = record, let model = T( record: record) {
                completion(.success(model))
            } else {
                completion(.failure( CustomError.make(error: (error as NSError?))))
            }
        }
            
    }
}

extension CKPrivateModelService {
    
    // TODO: move this use the SearchPredicate.custom(key, value) and remove this function
    public func fetchByName(
        name: String,
        completion: @escaping ((Result<T,Error>) -> Void)
    ) {
        
        // TODO: replace with .customEqualsSearch("name", value)
        let pred = NSPredicate(format: "name == %@", name)
        let query = CKQuery(recordType: T.recordName, predicate: pred)
        
        let operation = CKQueryOperation(query: query)
        //operation.desiredKeys = ["name", "yack"]
        operation.resultsLimit = 2
        
        container.privateCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let records = records, let firstRecord = records.first, let model = T(record: firstRecord) {
                completion(.success(model))
            } else {
                completion(.failure( CustomError.make(error: (error as NSError?))))
            }
        }
    }//end fetchByName
}


