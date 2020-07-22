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
    
    private var serverConfig: ServerConfig
    
    private var userStore = SimpleUserStore()
    var currentDeviceInfo: DeviceModel = DeviceModel()
    var currentAppInfo: AppModel = AppModel()
    
    @Published var currentUserModel: UserModel? = nil
    @Published var currentPurchaseModel: PurchaseModel? = nil
    
    @Published var topView: ContentView.TopView = .tabView {
        willSet {
            updateChanges()
        }
    }
    
    init(
    ) {
        #if targetEnvironment(simulator)
            isSimulator = true
            serverConfig = .mock
        #else
            isSimulator = false
            serverConfig = .mock
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
        // TODO: checkAuthStatus
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
        self.userStore.signOut() { (result) in
            switch result {
            case .failure(let error):
                print("error \(error)")
            case .success(let model):
                self.currentUserModel = model
            }
            self.updateChanges()
        }
    }
    
    public func signIn(
        email: String,
        password:String,
        completion: @escaping (Result<UserModel, Error>) -> ()
    ){
        
        self.userStore.signIn(email: email, password: password) { (result) in
            switch result {
            case .failure(let error):
                print("error \(error)")
            case .success(let model):
                self.currentUserModel = model
            }
            
            completion(result)
            self.updateChanges()
        }
    }
    
    public func register(
        email: String,
        password:String,
        completion: @escaping (Result<UserModel, Error>) -> ()
    ) {
        self.userStore.register(email: email, password: password) { (result) in
                        switch result {
            case .failure(let error):
                print("error \(error)")
            case .success(let model):
                self.currentUserModel = model
            }
            completion(result)
            self.updateChanges()
        }
    }
    
}
