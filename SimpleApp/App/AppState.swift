//
//  AppState.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 7/19/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import Combine
import CloudKit

class AppState: ObservableObject {
    
    public let objectWillChange = ObservableObjectPublisher()
    
    public let isSimulator: Bool
    
    private var serverConfig: StoreConfig

    var currentDeviceInfo: DeviceModel = DeviceModel()
    var currentAppInfo: AppModel = AppModel()
    
    @Published var userStore = UserStore(storeConfig: StoreConfig.local)
    @Published var currentUserModel: UserModel? = nil
    @Published var currentPurchaseModel: PurchaseModel? = nil
    
    //@Published var topView: ContentView.TopView = .tabView {
    @Published var topView: ContentView.TopView = .mainView {
        willSet {
            updateChanges()
        }
    }
    
    init(
    ) {
        #if targetEnvironment(simulator)
            isSimulator = true
            serverConfig = .local
        #else
            isSimulator = false
            serverConfig = .local
        #endif
    }
    
    private func updateChanges() {
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
}

// MARK: - StartupServices
extension AppState {
    
    public func onStartup() {
        checkAuthStatus()
        checkPurchaseStatus()
        updateDeviceAndAppDataOnServer()
    }
    
    private func checkAuthStatus() {
        if currentUserModel == nil {
            topView = .pickPlayerView
        }
    }
    
    private func checkPurchaseStatus() {
        // TODO: checkPurchaseStatus
    }
    
    private func updateDeviceAndAppDataOnServer() {
        // TODO: updateDeviceAndAppDataOnServer
    }
    
}

// MARK: - Purchase Services
extension AppState {
    
    public func makePurchase(
        purchase: PurchaseModel.PurchaseStatus
    ) -> Result<PurchaseModel,Error> {
        let newModel = PurchaseModel(id: UUID(), status: purchase)
        self.currentPurchaseModel = newModel
        return .success(newModel)
    }
    
    public func verifyPurchase(
        purchase: String
    ) -> Result<PurchaseModel?,Error> {
        guard let activePurchase = self.currentPurchaseModel else {
            return .success(nil)
        }
        return .success(activePurchase)
    }
    
}

// MARK: - Authentication Services
extension AppState {

    public func signOut(){
        self.currentUserModel = nil
        self.updateChanges()
    }
    
    public func signIn(
        user: UserModel
    ){
        self.currentUserModel = user
        self.updateChanges()
    }
    
}

// MARK: - Authentication Services
extension AppState {
    
    func modifyCurrentPlayersPoints( points:Int) {
        self.currentUserModel?.currentPoints += points
    }
    
    func addPlayer( model:UserModel) {
        self.userStore.addPlayer(model: model)
        updateChanges()
    }
}
