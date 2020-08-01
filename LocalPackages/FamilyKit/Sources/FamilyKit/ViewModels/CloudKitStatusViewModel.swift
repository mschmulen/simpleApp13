//
//  File.swift
//  
//
//  Created by Matthew Schmulen on 8/1/20.
//

import Foundation
import SwiftUI
import Combine
import CloudKit

public extension CKAccountStatus {
    var friendlyString: String {
        switch self {
        case .available:
            return "available"
        case .couldNotDetermine:
            return "couldNotDetermine"
        case .noAccount:
            return "noAccount"
        case .restricted:
            return "restricted"
        default:
            return "unknown"
        }
    }
}

public class CloudKitStateViewModel: NSObject, ObservableObject{
    
    //let objectWillChange = PassthroughSubject<Void, Never>()
    
    //    @Published var someVar: Int = 0 {
    //      willSet { objectWillChange.send() }
    //    }
    
    @Published public private(set) var accountStatus: CKAccountStatus = CKAccountStatus.couldNotDetermine

    @Published public private(set) var hasFileManagerUbiquityIdentityToken = false
    
    public override init() {
        super.init()
        
        if FileManager.default.ubiquityIdentityToken == nil {
            hasFileManagerUbiquityIdentityToken = false
        } else {
            hasFileManagerUbiquityIdentityToken =  true
        }
        
        CKContainer.default().accountStatus { (accountStatus, error) in
            self.accountStatus = accountStatus
//            switch accountStatus {
//            case .available:
//                print("iCloud Available")
//            case .noAccount:
//                print("No iCloud account")
//            case .restricted:
//                print("iCloud restricted")
//            case .couldNotDetermine:
//                print("Unable to determine iCloud status")
//            }
        }
    }
}
