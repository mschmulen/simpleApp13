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
    
    public enum SearchPredicate {
        
        case predicateTrue
        //case tagsSearch(_ searchString:String )
        
        //let predicate = NSPredicate(format: "info_en CONTAINS %@", searchString)
        //let predicate = NSPredicate(format: "nameShort CONTAINS %@", searchString)
        
        var predicate: NSPredicate {
            switch self {
                case .predicateTrue:
                    return NSPredicate(value: true)
//                case .tagsSearch( let searchString ) :
//                    return NSPredicate(format: "tags CONTAINS %@", searchString.lowercased())
            }
        }
    }
    
    public enum SortDescriptor {
        case creationDate
        case creationDateAscending
        // case updateDate
        // case name
        
        var sortDescriptors: [NSSortDescriptor] {
            switch self {
            case .creationDate:
                return [NSSortDescriptor(key: "creationDate", ascending: false)]
            case .creationDateAscending:
                return [NSSortDescriptor(key: "creationDate", ascending: true)]
//            case .updateDate:
//                    return NSSortDescriptor(key: "creationDate", ascending: false)
//            case .name:
//                return NSSortDescriptor(key: "name", ascending: true)
            }
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
        sortDescriptor: SortDescriptor? = nil,
        completion: @escaping (Result<[T], Error>) -> ()
    ) {
        let query = CKQuery(recordType: T.recordName, predicate: SearchPredicate.predicateTrue.predicate)
        
        if let sortDescriptor = sortDescriptor {
            query.sortDescriptors = sortDescriptor.sortDescriptors
        }
        
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
        
        // TODO enable the sort descriptor by date
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
