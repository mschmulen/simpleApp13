//
//  CKShareService.swift
//  
//
//  Created by Matthew Schmulen on 9/22/20.
//

import SwiftUI
import Combine
import CloudKit

public final class CKShareService: ObservableObject {
    
    internal var container: CKContainer
    
    private var cloudKitApplicationPermissionStatus: CKContainer_Application_PermissionStatus? = nil
    
    public init(container: CloudKitContainer) {
        switch container {
        case .CloudContainer(let container):
            self.container = container
        case .MockContainer(let container):
            self.container = container
        }
    }
    
}

// reference https://medium.com/@valv0/custom-cloudkit-sharing-workflow-522d67ec0c00
// MARK: CKSharing stuff
extension CKShareService {
    
    // TODO: request this for sharing Step 1.
    func requestUserDiscoverability(completion: @escaping (Result<Bool, Error>) -> ()) {
        
        print( "cloudKitApplicationPermissionStatus: \(String(describing: cloudKitApplicationPermissionStatus))")
        
        //ask for userDiscoverability otherwise you will obtain nil each time you try to search for him
        container.requestApplicationPermission(CKContainer_Application_Permissions.userDiscoverability) { (status, error) in
            
            self.cloudKitApplicationPermissionStatus = status
            
            switch status {
            case .granted:
                completion(.success(true))
            case .denied:
                completion(.failure(error ?? CustomError.ckContainerApplicationPermissionError_denied))
            case .initialState:
                completion(.failure(error ?? CustomError.ckContainerApplicationPermissionError_initialState))
            case .couldNotComplete:
                completion(.failure(error ?? CustomError.ckContainerApplicationPermissionError_couldNotComplete))
            default:
                completion(.failure(error ?? CustomError.unknown))
            }
            
        }

    }
    
    
    
    // Demo only Step2
    private func createPublicRecord_step2() {
        let aRecord = CKRecord(recordType: "MyUser")
        aRecord.setObject("John" as CKRecordValue, forKey: "firstName")
        aRecord.setObject("Appleseed" as CKRecordValue, forKey: "lastName")

        let container = CKContainer.default()
        let publicDatabase = container.publicCloudDatabase
        
        publicDatabase.save(aRecord, completionHandler: { (record, error) -> Void in
            if let error = error {
                print(error)
            }
            else {
                print("record saved successfully")
            }
        })
    }
    
    // Demo only Step3
    func createFamilyZone_step3(completionHandler:@escaping (CKRecordZone?, Error?)->Void) {
        let container = CKContainer.default()
        let privateDatabase = container.privateCloudDatabase
        let customZone = CKRecordZone(zoneName: "FamilyZone")
        
        privateDatabase.save(customZone, completionHandler: ({returnRecord, error in
            completionHandler(returnRecord, error)
        }))
    }//end createFamilyZone
    
    // Demo only Step4
    private func createPrivateRecord_step4() {
        let container = CKContainer.default()
        let privateDatabase = container.privateCloudDatabase

        let recordZone: CKRecordZone = CKRecordZone(zoneName: "FamilyZone")
        let aRecord = CKRecord(recordType: "PrivateInfo", zoneID: recordZone.zoneID)
        
        aRecord.setObject("+393331112223" as CKRecordValue, forKey: "phoneNumber")
        aRecord.setObject("john@appleseed.com" as CKRecordValue, forKey: "email")

        
        privateDatabase.save(aRecord, completionHandler: { (record, error) -> Void in
            if let error = error {
                print(error)
            }
            else {
                print("record saved successfully")
            }
        })
    }//end createPrivateRecord
    
    
    // Demo only Step5
    
    /*
    As you could point out, we still haven’t written the privateShareUrl field that is part of the public record; this is the crucial part of the whole approach described in this article. The standard behaviour, in fact, is based on the UICloudSharingController that will prompt the user with a dialog containing what and how to share the information. The result of the dialog is an URL that we need to use with third party apps such as Message, Email or whatever in order to communicate our intention to share something.
     
     To make things even worst, on the other side, the receiver needs to click the link that, in turn, will open our app calling a corresponding UIApplocation delegate method. The latter, at the end, will give us a CKShareMetadata instance that we can use to fetch shared information.
     
     Apple states that the share url for CKShare is stable and will not change unless you change the root record associated with it.
     
    */
    
}


extension CKShareService {

    public func sendInvite() {
        print( "CKShareService. sendInvite")
    }
    
    public func removeInvite() {
        print( "CKShareService. removeInvite")
    }


}
