//
//  FamilyAppKitState.swift
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
    
    public var emoji: String {
        switch self {
        case .adult(let model):
            return model.emoji ?? "🌞"
        case .kid(let model):
            return model.emoji ?? "🌞"
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

public class FamilyKitAppState: ObservableObject {
    
    private let container: CKContainer
    
    private let thisDeviceModel: DeviceModel = DeviceModel()
    private var deviceService: CKPrivateModelService<CKDeviceModel>
    
    public let objectWillChange = ObservableObjectPublisher()
    public let isSimulator: Bool
    
    var anyCancellable: AnyCancellable? = nil
    
    @Published public private (set) var userService: CKUserService<CKUser>
    @Published public private (set) var kidService: CKPrivateModelService<CKKidModel>
    @Published public private (set) var adultService: CKPrivateModelService<CKAdultModel>
    
    @Published public private (set) var currentPlayer: Player = Player.none {
        didSet {
            print( "did update the current player")
            // TODO: fire off an update to the device service to udpate the current CKDeviceModel
        }
    }
    
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
        
        deviceService = CKPrivateModelService<CKDeviceModel>(
            container: container
        )
        
        #if targetEnvironment(simulator)
            isSimulator = true
        #else
            isSimulator = false
        #endif
        
        anyCancellable = Publishers.CombineLatest(kidService.$models,adultService.$models).sink(receiveValue: {_ in
            self.objectWillChange.send()
        })
        
    }
    
    private func updateChanges() {
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
}

// MARK: - StartupServices
extension FamilyKitAppState {
    
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
        
        adultService.fetch(completion: { result in
            switch result {
            case .success(let models) :
                print( "adultService success \(models)")
                //self.kids = self.kidService.models
                self.onUpdate()
            case .failure(let error):
                print( "adultService error \(error)")
                self.onUpdate()
            }
        })
        adultService.subscribe()
        adultService.listenForNotifications()
        
        // TODO: fetch create the CKDevice Model based on device
        print( "thisDeviceModel idfv \(self.thisDeviceModel.idfv?.uuidString ?? "~")")
        //        ckDeviceModel = CKDeviceModel(deviceModel: DeviceModel())
//            deviceService.pushUpdateCreate(model: ckDeviceModel) { (result) in
//                print( "device push update create \(result)")
//            }
        
    }
    
    private func checkAuthStatus() {
        print( "FamilKitState.checkAuthStatus")
    }
}

// MARK: - Authentication Services
extension FamilyKitAppState {

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

// MARK: - Player Points
extension FamilyKitAppState {
    
    public func modifyCurrentPlayersBucks( bucks:Int) {
        // TODO: Fix the bucks
//        switch currentPlayer {
//        case .adult(let adultModel):
//            adultModel.bucks += bucks
//        case .kid(let kidModel):
//            adultModel.bucks += bucks
//        }
    }
}

