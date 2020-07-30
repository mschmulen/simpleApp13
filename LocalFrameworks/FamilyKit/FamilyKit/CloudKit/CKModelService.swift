//
//  ModelService.swift
//  FamilyKit
//
//  Created by Matthew Schmulen on 7/25/20.
//  Copyright © 2020 jumptack. All rights reserved.
//


import SwiftUI
import Combine
import CloudKit

public let CKChangedNotification = Notification.Name("CloudKitModelService")
public let CKContainerIdentifier = "iCloud.com.jumptack.FamilyKit"

public enum CKContainerConfig {
    case publicCloudDatabase
    case privateCloudDatabase
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
public final class CKModelService<T>: ObservableObject where T:CKModel {
    
    public let objectWillChange = ObservableObjectPublisher()
    
    internal var container: CKContainer
    //internal var containerConfig: CKContainerConfig
    
    @Published public var publicModels: [T] = [] {
        willSet {
            updateChanges()
        }
    }
    
    @Published public var privateModels: [T] = [] {
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
extension CKModelService {
    
    public func fetchPublic(
        completion: @escaping (Result<T, Error>) -> ()
    ) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: T.recordName, predicate: predicate)
//        let sortCreation = NSSortDescriptor(key: "creationDate", ascending: false)
//        query.sortDescriptors = [sortCreation]
//        let sortName = NSSortDescriptor(key: "nameShort", ascending: true)
//        query.sortDescriptors = [sortName]
        
//        query.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        
        queryRecords(
            containerConfig: CKContainerConfig.publicCloudDatabase,
            query: query,
            resultsLimit: 50,
            enablePaging: true,
            completion: { result in
            switch result {
            case .success(let models) :
                DispatchQueue.main.async {
                    // TODO merge the model list together
                    self.publicModels = models
                }
            case .failure(let error) :
                print( "failure \(error)")
            }
        })
    }//end fetchPublic
    
    public func fetchPrivate(
        completion: @escaping (Result<T, Error>) -> ()
    ) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: T.recordName, predicate: predicate)
        
        queryRecords(
            containerConfig:CKContainerConfig.privateCloudDatabase,
            query: query,
            resultsLimit: 50,
            enablePaging: true,
            completion: { result in
                switch result {
                case .success(let models) :
                    DispatchQueue.main.async {
                        // TODO merge the model list together
                        self.privateModels = models
                    }
                case .failure(let error) :
                    print( "failure \(error)")
                }
        })
    }//end fetchPrivate
    
    func queryRecords(
        containerConfig:CKContainerConfig,
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
        switch containerConfig {
        case .privateCloudDatabase:
            container.privateCloudDatabase.add(operation)
        case .publicCloudDatabase:
            container.publicCloudDatabase.add(operation)
        }
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
        container.publicCloudDatabase.add(operation)
    }
}
