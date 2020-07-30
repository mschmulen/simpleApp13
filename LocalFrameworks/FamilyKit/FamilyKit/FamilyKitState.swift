//
//  FamilyKitState.swift
//  FamilyKit
//
//  Created by Matthew Schmulen on 7/29/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import CloudKit

public enum Player {
    case adult( CKAdultModel )
    case kid( CKKidModel )
    case none
    
    public var name: String {
        switch self {
        case .adult(let model) :
            return model.name ?? "~"
        case .kid(let model):
            return model.name ?? "~"
        case .none:
            return "none"
        }
    }
    
    public var isNone: Bool {
        switch self {
        case .none:
            return true
        default:
            return false
        }
    }
    
    public var isAdult: Bool {
        switch self {
        case .none:
            return false
        case .adult(_) :
            return true
        case .kid(_):
            return false
        }
    }
}

public class FamilyKitState: ObservableObject {
    
    public let objectWillChange = ObservableObjectPublisher()
    
    public let isSimulator: Bool
    
    private var container: CKContainer
    
    @Published public private (set) var userService: CKUserService<CKUser>
    
    //@Published public private (set) var currentPlayer: Player = Player.none
    @Published public private (set) var currentPlayer: Player = Player.kid(CKKidModel.mock)

    @Published public private (set) var kidService: CKPrivateModelService<CKKidModel>
    @Published public private (set) var adultService: CKPrivateModelService<CKAdultModel>
    
    //    var currentDeviceInfo: DeviceModel = DeviceModel()
    //    var currentAppInfo: AppModel = AppModel()
    
    public init(
        container: CKContainer
    ) {
        
        self.container = container
        userService = CKUserService<CKUser>(container: container)
        
        kidService = CKPrivateModelService<CKKidModel>(
            container: container
        )
        
        adultService = CKPrivateModelService<CKAdultModel>(
            container: container
        )
        
        #if targetEnvironment(simulator)
            isSimulator = true
        #else
            isSimulator = false
        #endif
    }
    
    private func updateChanges() {
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
}

// MARK: - StartupServices
extension FamilyKitState {
    
    public func onUpdate() {
        checkAuthStatus()
        kidService.fetch { (result) in
            print( "kidService fetch \(result)")
            self.updateChanges()
        }
        
        adultService.fetch { (result) in
            print( "adultService fetch \(result)")
            self.updateChanges()
        }
        self.updateChanges()
    }
    
    public func onStartup() {
        checkAuthStatus()
        kidService.fetch(completion: { result in
            switch result {
            case .success(let models) :
                print( "kidService success \(models)")
                //self.kids = self.kidService.models
                self.onUpdate()
            case .failure(let error):
                print( "kidService error \(error)")
                self.onUpdate()
            }
        })
        kidService.subscribe()
        kidService.listenForNotifications()
    }
    
    private func checkAuthStatus() {
        print( "FamilKitState.checkAuthStatus")
    }
}

// MARK: - Authentication Services
extension FamilyKitState {

    public func setCurrentPlayer(player: Player){
        self.currentPlayer = player
        self.updateChanges()
    }
    
    public var isCloudKitAvailable: Bool {
        
        if FileManager.default.ubiquityIdentityToken == nil {
            return false
        } else {
            return true
        }
        
//        CKContainer.default().accountStatus { (accountStatus, error) in
//            switch accountStatus {
//            case .available:
//                print("iCloud Available")
//                return true
//            case .noAccount:
//                print("No iCloud account")
//                return false
//            case .restricted:
//                print("iCloud restricted")
//                return false
//            case .couldNotDetermine:
//                print("Unable to determine iCloud status")
//                return false
//            }
//        }
    }
//    func modifyCurrentPlayersBucks( amount: Int) {
//        if let currentPlayer = currentPlayer, let bucks = currentPlayer.bucks {
//            self.currentPlayer?.bucks = bucks + amount
//            kidService.pushUpdateCreate(model: currentPlayer) { (result) in
//                print( "reasult \(result)")
//            }
//        }
//        self.updateChanges()
//    }
    
//    func addPlayer( model: CKKidModel ) {
//        updateChanges()
//    }
}

