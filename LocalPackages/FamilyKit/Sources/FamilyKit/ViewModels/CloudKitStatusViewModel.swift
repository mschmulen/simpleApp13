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
    
    //private let monitor = NWPathMonitor()
    //private let queue = DispatchQueue(label: "Monitor")
    
    @Published public private(set) var accountStatus: CKAccountStatus = CKAccountStatus.couldNotDetermine

    @Published public private(set) var hasUbiquityIdentityToken = false
    
    public override init() {
        super.init()
        //let ubiquityIdentityToken = FileManager.default.ubiquityIdentityToken
        
        if FileManager.default.ubiquityIdentityToken == nil {
            hasUbiquityIdentityToken = false
        } else {
            hasUbiquityIdentityToken =  true
        }
                
        CKContainer.default().accountStatus { (accountStatus, error) in
            self.accountStatus = accountStatus
            switch accountStatus {
            case .available:
                print("iCloud Available")
                //return true
            case .noAccount:
                print("No iCloud account")
                //return false
            case .restricted:
                print("iCloud restricted")
               // return false
            case .couldNotDetermine:
                print("Unable to determine iCloud status")
                //return false
            }
        }
        
        
//        monitor.pathUpdateHandler = { path in
//            self.pathStatus = path.status
//            self.isExpensive = path.isExpensive
//        }
        //        let cellMonitory = NWPathMonitor(requiredInterfaceType: .cellular)
        //        let wifiMonitory = NWPathMonitor(requiredInterfaceType: .wifi)
//
//        self.pathStatus = monitor.currentPath.status
//        self.isExpensive = monitor.currentPath.isExpensive
//
//        monitor.start(queue: queue)
    }
}
