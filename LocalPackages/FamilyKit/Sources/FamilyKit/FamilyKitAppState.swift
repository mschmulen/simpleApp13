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

// TODO: Deprecate this Player enum
public enum Player {
    case adult( CKPlayerModel )
    case kid( CKPlayerModel )
    case none
    
    public var recordReference: CKRecord.Reference? {
        switch self {
        case .adult(let model):
            if let id = model.recordID {
                let reference = CKRecord.Reference(recordID: id, action: .deleteSelf)
                return reference
            } else {
                return nil
            }
        case .kid(let model):
            if let id = model.recordID {
                let reference = CKRecord.Reference(recordID: id, action: .deleteSelf)
                return reference
            } else {
                return nil
            }
        case .none:
            return nil
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
    @Published public private (set) var playerService: CKPrivateModelService<CKPlayerModel>
    
    @Published public private (set) var currentPlayerModel: CKPlayerModel?
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
    
    public func onRefresh() {
        playerService.fetch(
            sortDescriptor: .none
        ) { (result) in
            self.updateChanges()
        }
        
        self.updateChanges()
    }
}

// MARK: - User Services
extension FamilyKitAppState {
    
    public func setCurrentPlayer(player: Player, playerModel:CKPlayerModel){
        self.currentPlayerModel = playerModel
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
}

// MARK: - findUserForRecord
extension FamilyKitAppState {
    
    public func findUserForRecord(recordReference: CKRecord.Reference ) -> Player? {
        for kid in playerService.models {
            if let kidRecordID = kid.recordID {
                if kidRecordID == recordReference.recordID {
                    return Player.kid(kid)
                }
            }
        }
        return nil
    }
    
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
    
    public func addBucks( player:Player, bucks: Int) {
        switch player {
        case .adult(var playerModel):
            if let currentBucks = playerModel.bucks {
                playerModel.mutateBucks(newBucks: currentBucks + bucks)
            } else {
                playerModel.mutateBucks(newBucks: bucks)
            }
            
            self.playerService.pushUpdateCreate(model: playerModel) { (result) in
                switch result {
                case .failure(let error):
                    print("failed up updaet the player \(error)" )
                case .success(_):
                    print( "player is updated")
                }
            }
        case .kid(var playerModel):
            if let currentBucks = playerModel.bucks {
                playerModel.mutateBucks(newBucks: currentBucks + bucks)
            } else {
                playerModel.mutateBucks(newBucks: bucks)
            }
            
            self.playerService.pushUpdateCreate(model: playerModel) { (result) in
                switch result {
                case .failure(let error):
                    print("failed up updaet the player \(error)" )
                case .success(_):
                    print( "player is updated")
                }
            }
        case .none:
            print( "yack")
        }
        
    }//end addBucks
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



