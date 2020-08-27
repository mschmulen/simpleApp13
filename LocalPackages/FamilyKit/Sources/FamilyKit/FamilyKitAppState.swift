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

public class FamilyKitAppState: ObservableObject {
    
    private let container: CKContainer
    
    private let thisDeviceModel: DeviceModel = DeviceModel()
    private var deviceService: CKPrivateModelService<CKDeviceModel>
    
    public let objectWillChange = ObservableObjectPublisher()
    public let isSimulator: Bool
    
    var anyCancellable: AnyCancellable? = nil
    
    @Published public private (set) var userService: CKUserService<CKUser>
    @Published public private (set) var playerService: CKPrivateModelService<CKPlayerModel>
    
    @Published public private (set) var currentPlayerModel: CKPlayerModel?
    
    // @State players:[CKPlayerModel] = [CKPlayerModel]()
    
    public init(
        container: CKContainer
    ) {
        
        self.container = container
        userService = CKUserService<CKUser>(container: container)
        
        playerService = CKPrivateModelService<CKPlayerModel>(
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
        
//        anyCancellable = Publishers.CombineLatest(kidService.$models,adultService.$models).sink(receiveValue: {_ in
//            self.objectWillChange.send()
//        })
        
    }
    
    private func updateChanges() {
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
    
}

// MARK: - StartupServices
extension FamilyKitAppState {
    
    public func onStartup() {
        
        playerService.fetch(
            sortDescriptor: .none,
            searchPredicate: .predicateTrue,
            completion: { result in
            switch result {
            case .success(_) :
                self.updateChanges()
            case .failure(let error):
                print( "kidService error \(error)")
            }
        })
        playerService.subscribe(isSilent: true, message: "player Change")
        playerService.listenForNotifications()
        
        // TODO: fetch create the CKDevice Model based on device
        //print( "thisDeviceModel idfv \(self.thisDeviceModel.idfv?.uuidString ?? "~")")
        //        ckDeviceModel = CKDeviceModel(deviceModel: DeviceModel())
//            deviceService.pushUpdateCreate(model: ckDeviceModel) { (result) in
//                print( "device push update create \(result)")
//            }
        
    }
    
    public func onRefetchFromServer(afterDelay: Double = 0.00) {
        DispatchQueue.main.asyncAfter(deadline: .now() + afterDelay) {
            self.playerService.fetch(
                sortDescriptor: .none,
                searchPredicate: .predicateTrue
            ) { (result) in
                switch result {
                case .failure(_):
                    self.updateChanges()
                case .success(_):
                    self.updateChanges()
                }
            }
        }
    }
}

// MARK: - User Services
extension FamilyKitAppState {
    
    public func setCurrentPlayer(playerModel:CKPlayerModel){
        self.currentPlayerModel = playerModel
        //self.currentPlayer = player
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
}

// MARK: - findUserForRecord
extension FamilyKitAppState {
    
    public func findPlayerModelForRecord(recordReference: CKRecord.Reference ) -> CKPlayerModel? {
        for kid in playerService.models {
            if let kidRecordID = kid.recordID {
                if kidRecordID == recordReference.recordID {
                    return kid
                }
            }
        }
        return nil
    }
    
}

// MARK: - Player Points
extension FamilyKitAppState {
    
    public func addBucks( playerModel:CKPlayerModel, bucks: Int) {
        
        playerModel.bucks = (playerModel.bucks ?? 0) + bucks
        self.playerService.pushUpdateCreate(model: playerModel) { (result) in
            switch result {
            case .failure(let error):
                print("failed up updaet the player \(error)" )
            case .success(_):
                print( "player is updated")
            }
        }
    }//end addBucks
    
    public func resetAllFamilyBucks() {
        for playerModel in self.playerService.models {
            playerModel.bucks = 0
            
            self.playerService.pushUpdateCreate(model: playerModel) { (result) in
                switch result {
                case .failure(let error):
                    print("failed up updaet the player \(error)" )
                case .success(_):
                    print( "player is updated")
                }
            }
        }
    }
}

// MARK: - Helper methods

extension FamilyKitAppState {
    
    public func isCurrentPlayerOwnerOrEmpty(model: CKActivityModel) ->Bool {
        
        guard let playerReference = self.currentPlayerModel?.ckRecord?.recordID else {
            return false
        }
        
        guard let modelKidReferenceRecordID = model.kidReference?.recordID else {
            return true
        }
        
        if modelKidReferenceRecordID == playerReference {
            return true
        } else {
            return false
        }
    }
    
    public func isCurrentPlayerOwnerOrAdult(model: CKActivityModel) ->Bool {
        
        guard let currentPlayer = self.currentPlayerModel else {
            return false
        }

        guard let playerReference = currentPlayer.ckRecord?.recordID else {
            return false
        }
        
        if currentPlayer.isAdult {
            return true
        }
        
        guard let modelKidReferenceRecordID = model.kidReference?.recordID else {
            return true
        }
        
        if modelKidReferenceRecordID == playerReference {
            return true
        } else {
            return false
        }
    }
    
    
}



