//
//  CKUserService.swift
//  FamilyKit
//
//  Created by Matthew Schmulen on 7/29/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import Combine
import CloudKit



public class CKUserService<T>: ObservableObject where T:CKUserModel {
    
    public let objectWillChange = ObservableObjectPublisher()
    
    internal var container: CKContainer
    
    @Published public private(set) var ckAccountStatus: CKAccountStatus = CKAccountStatus.couldNotDetermine
    
    @Published public private(set) var localUserDefaults_appleIDCredentialIdentifier: String?
    
    @Published public private(set) var currentUserRecordID: CKRecord.ID?
    @Published public private(set) var currentUserRecordIDName: String?
    @Published public private(set) var currentUser:CKUser? {
        willSet {
            updateChanges()
        }
    }
    
    public init(container: CKContainer) {
        self.container = container
        requestCloudKitAccountStatus()
    }
    
    
    
    public func onStartup() {
        requestCloudKitAccountStatus()
        fetchUserRecord()
    }
    
}

// MARK: - Private Helpers
extension CKUserService {
    
    private func updateChanges() {
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
    
    private func requestCloudKitAccountStatus() {
        container.accountStatus { [unowned self] (accountStatus, error) in
            if let error = error {
                print("error requestCloudKitAccountStatus: \(error)")
            }
            self.ckAccountStatus = accountStatus
            self.fetchUserRecord()
            self.updateChanges()
        }
    }
}


// MARK: - Authentication Helpers
extension CKUserService {
    
    public var isUserCloudKitEnabled: Bool {
        switch self.ckAccountStatus {
        case .available:
            return true
        default:
            return false
        }
    }
    
    public var isUserAuthenticated: Bool {
        if localUserDefaults_appleIDCredentialIdentifier == nil {
            return false
        } else {
            return true
        }
    }
}

// MARK: - private UserRecord Fetch
extension CKUserService {
    
    private func fetchUserRecord() {
        fetchCurrentUserRecord { (result) in
            switch result {
            case .success(let user):
                self.currentUser = user
            case .failure(let error):
                // TODO: check for no network
                print("fetchUserRecord.error \(error)")
            }
        }
    }
    
    private func fetchCurrentUserRecord(
        completion: @escaping (Result<CKUser, Error>) -> ()
    ) {
        container.fetchUserRecordID(completionHandler: { (recordID, error) in
            guard let recordID = recordID, error == nil else {
                completion(.failure( CustomError.make(error: (error as NSError?))))
                return
            }
            
            DispatchQueue.main.async {
                self.currentUserRecordID = recordID
                self.currentUserRecordIDName = recordID.recordName
                //self.autoUpdateDeviceInfo(completion: nil)
            }
            
            self.container.publicCloudDatabase.fetch(withRecordID: recordID) { fetchRecord, error in
                guard let fetchRecord = fetchRecord else {
                    completion(.failure( CustomError.make(error: (error as NSError?))))
                    return
                }
                
                guard let userModel = CKUser(record: fetchRecord) else {
                    completion(.failure(CustomError.unknown))
                    return
                }
                
                completion(.success(userModel))
                self.currentUser = userModel
            }
        })//end fetchUserRecordID
    }//end fetchUserRecord
}

// MARK: - private Device Fetch
extension CKUserService {
    
    private func autoUpdateDeviceInfo(completion: ((Result<CKRecord.ID,Error>) -> Void)?) {
        let locale = Locale.current
        let localeLanguageCode = locale.languageCode
        let localeRegionCode = locale.regionCode
        let localePreferredLanguages = Locale.preferredLanguages
        
        if currentUserRecordIDName != nil {
            guard let userRecordIDName = currentUserRecordIDName else { return }
            let recordID = CKRecord.ID(recordName: userRecordIDName)
            
            container.publicCloudDatabase.fetch(withRecordID: recordID) { record, error in
                if let record = record, error == nil {
                    
                    record["localeCurrentLanguageCode"] = localeLanguageCode
                    record["localeCurrentRegionCode"] = localeRegionCode
                    record["localePreferredLanguages"] = localePreferredLanguages
                    
                    self.container.publicCloudDatabase.save(record) { record, error in
                        if let error = error {
                            print( "autoUpdateDeviceInfo.error \(error)")
                            completion?(.failure( CustomError.make(error: (error as NSError?))))
                        } else {
                            if let returnRecordID = record?.recordID {
                                completion?(.success(returnRecordID))
                            } else {
                                completion?(.failure(CustomError.unknown))
                            }
                            print( "success on save")
                        }//end else
                    }
                }
            }
        } else {
            completion?(.failure(CustomError.unknown))
        }
        
    }
}

// MARK: - public updateInterests
extension CKUserService {
    
    public func updateInterests(
        explicitInterests: [String],
        completion: ((Result<CKRecord.ID,Error>) -> Void)?
    ) {
        if currentUserRecordIDName != nil {
            guard let userRecordIDName = currentUserRecordIDName else { return }
            let recordID = CKRecord.ID(recordName: userRecordIDName)
            
            container.publicCloudDatabase.fetch(withRecordID: recordID) { record, error in
                if let record = record, error == nil {
                    
                    record["explicitInterests"] = explicitInterests
                    self.container.publicCloudDatabase.save(record) { record, error in
                        if let error = error {
                            completion?(.failure(error))
                        } else {
                            if let returnRecordID = record?.recordID {
                                completion?(.success(returnRecordID))
                            } else {
                                completion?(.failure(CustomError.unknown))
                            }
                        }//end else
                    }
                }
            }
        } else {
            completion?(.failure(CustomError.unknown))
        }
    }//end updateInterests
}

