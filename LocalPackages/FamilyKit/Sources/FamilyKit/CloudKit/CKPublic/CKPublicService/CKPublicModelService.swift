//
//  CKPublicModelService.swift
//  FamilyKit
//
//  Created by Matthew Schmulen on 7/25/20.
//  Copyright © 2020 jumptack. All rights reserved.
//


import SwiftUI
import Combine
import CloudKit

public final class CKPublicModelService<T>: ObservableObject where T:CKPublicModel {
    
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

extension CKPublicModelService {
    
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
        container.publicCloudDatabase.add(operation)
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
        container.publicCloudDatabase.add(operation)
    }
}


extension CKPublicModelService {
    public func fetchSingle(
        model: T,
        completion: @escaping ((Result<T,Error>) -> Void)
    ) {
        if let recordID = model.recordID {
            container.publicCloudDatabase.fetch(withRecordID: recordID) { (record, error) in
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

extension CKPublicModelService {
    
    public func fetchByReference (
        modelReference: CKRecord.Reference,
        completion: @escaping ((Result<T,Error>) -> Void)
    ) {
        let recordID = modelReference.recordID
        container.publicCloudDatabase.fetch(withRecordID: recordID) { (record, error) in
            if let record = record, let model = T( record: record) {
                completion(.success(model))
            } else {
                completion(.failure( CustomError.make(error: (error as NSError?))))
            }
        }
            
    }
}

extension CKPublicModelService {
    
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
        
        container.publicCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let records = records, let firstRecord = records.first, let model = T(record: firstRecord) {
                completion(.success(model))
            } else {
                completion(.failure( CustomError.make(error: (error as NSError?))))
            }
        }
    }//end fetchByName
}
































///**
//
// Usage:
// 
// var container = CKContainer.default()
// container = CKContainer(identifier: CKContainerIdentifier)
// 
// let service = CloudKitModelService<CKSimpleModel>(container: container)
// service.fetch(completion: { result in
//     print( "fetch result \(result)")
//     switch result {
//     case .success(let models) :
//         print( "success \(models)")
//     case .failure(let error):
//         print( "error \(error)")
//     }
// })
// service.subscribe()
// service.listenForNotifications()
//*/
//public final class CKPublicModelService<T>: ObservableObject where T:CKModel {
//    
//    public let objectWillChange = ObservableObjectPublisher()
//    
//    internal var container: CKContainer
//    
//    @Published public var models: [T] = [] {
//        willSet {
//            updateChanges()
//        }
//    }
//    
//    public init(container: CKContainer) {
//        self.container = container
//    }
//    
//    enum CustomError: Error {
//        case unknown
//        case cursorFailure
//    }
//    
//        public enum SearchPredicate {
//            
//            case predicateTrue
//            
//            //case tagsSearch(_ searchString:String )
//            //let predicate = NSPredicate(format: "info_en CONTAINS %@", searchString)
//            //let predicate = NSPredicate(format: "nameShort CONTAINS %@", searchString)
//            
//            var predicate: NSPredicate {
//                switch self {
//                    case .predicateTrue:
//                        return NSPredicate(value: true)
//    //                case .tagsSearch( let searchString ) :
//    //                    return NSPredicate(format: "tags CONTAINS %@", searchString.lowercased())
//                }
//            }
//        }
//        
//        public enum SortDescriptor {
//            case creationDate
//            case nameShort
//            
//            var sortDescriptor: NSSortDescriptor {
//                switch self {
//                case .creationDate:
//                    return NSSortDescriptor(key: "creationDate", ascending: false)
//                case .nameShort:
//                    return NSSortDescriptor(key: "nameShort", ascending: true)
//                }
//            }
//        }
//    
//    internal func updateChanges() {
//        DispatchQueue.main.async {
//            self.objectWillChange.send()
//        }
//    }
//}
//
//// TODO containerConfig:CKContainerConfig = .publicCloudDatabase
//extension CKPublicModelService {
//    
//    public func fetch(
//        completion: @escaping (Result<T, Error>) -> ()
//    ) {
//        
//        let query = CKQuery(recordType: T.recordName, predicate: SearchPredicate.predicateTrue.predicate)
//        
//        queryRecords(
//            query: query,
//            resultsLimit: 50,
//            enablePaging: true,
//            completion: { result in
//                switch result {
//                case .success(let models) :
//                    DispatchQueue.main.async {
//                        // TODO merge the model list together
//                        self.models = models
//                    }
//                case .failure(let error) :
//                    print( "CKPublicModelService.fetch failure \(error)")
//                }
//        })
//    }//end fetchPrivate
//    
//    func queryRecords(
//        query: CKQuery,
//        resultsLimit: Int,
//        enablePaging: Bool,
//        completion: @escaping (Result<[T], Error>) -> (),
//        errorHandler: ((_ error: Error) -> Void)? = nil
//    ) {
////        if !(query.sortDescriptors != nil) {
////            query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
////        }
//        let operation = CKQueryOperation(query: query)
//        var results = [T]()
//        operation.recordFetchedBlock = { record in
//            if let model = T( record: record) {
//                results.append(model)
//            }
//        }
//        
//        operation.queryCompletionBlock = { cursor, error in
//            if cursor != nil && enablePaging == true {
//                self.queryRecords(
//                    cursor: cursor!,
//                    resultsLimit: resultsLimit,
//                    continueWithResults: results,
//                    completion: completion,
//                    errorHandler: errorHandler
//                )
//            } else {
//                completion(.success(results))
//            }
//        }
//        operation.resultsLimit = resultsLimit
//        container.publicCloudDatabase.add(operation)
//    }
//    
//    private func queryRecords(
//        cursor: CKQueryOperation.Cursor,
//        resultsLimit: Int,
//        continueWithResults:[T],
//        completion: @escaping (Result<[T], Error>) -> (),
//        errorHandler:((_ error: Error) -> Void)? = nil
//    ) {
//        var results = continueWithResults
//        let operation = CKQueryOperation(cursor: cursor)
//        operation.recordFetchedBlock = { record in
//            //            if let parsed = self.fromCKRecord(record) as? T  { results.append(parsed) }
////            guard
////                let nameShort = record["nameShort"] as? String,
////                let lat = record["geoLatitude"] as? Double,
////                let long = record["geoLongitude"] as? Double,
////                //let category = record["category"] as? String,
////                let info = record["info"] as? String,
////                let countryCode = record["countryCode"] as? String
////
////                else {
////                    print("CloudKitModelService.updateAllModels incomplete record")
////                    print( "\(record["nameShort"] as? String ?? "Unknown short name")")
////                    return
////            }
//            if let model = T( record: record) {
//                results.append(model)
//            }
//            
//        }
//        
//        operation.queryCompletionBlock = { cursor, error in
//            if cursor != nil {
//                self.queryRecords(
//                    cursor: cursor!,
//                    resultsLimit: resultsLimit,
//                    continueWithResults: results,
//                    completion: completion,
//                    errorHandler: errorHandler
//                )
//            } else {
//                completion(.success(results))
//            }
//        }
//        operation.resultsLimit = resultsLimit
//        container.publicCloudDatabase.add(operation)
//    }
//}
