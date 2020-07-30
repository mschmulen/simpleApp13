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

public class FamilyKitState: ObservableObject {
    
    public let objectWillChange = ObservableObjectPublisher()
    
    public let isSimulator: Bool
    
    private var container: CKContainer

    @Published public var userService: CKUserService<CKUser>
    @Published public var kidService: CKModelService<CKKitModel>
    
//    private var serverConfig: StoreConfig

//    var currentDeviceInfo: DeviceModel = DeviceModel()
//    var currentAppInfo: AppModel = AppModel()
//
//    @Published var userStore = UserStore(storeConfig: StoreConfig.local)
//    @Published var currentUserModel: UserModel? = nil
//    @Published var currentPurchaseModel: PurchaseModel? = nil
//
//    //@Published var topView: ContentView.TopView = .tabView {
//    @Published var topView: ContentView.TopView = .mainView {
//        willSet {
//            updateChanges()
//        }
//    }
    
    public init(
        container: CKContainer
    ) {
        
        self.container = container
        userService = CKUserService<CKUser>(container: container)
        
        kidService = CKModelService<CKKitModel>(
            container: container
        )
        
        #if targetEnvironment(simulator)
            isSimulator = true
//            serverConfig = .local
        #else
            isSimulator = false
//            serverConfig = .local
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
    
    public func onStartup() {
        checkAuthStatus()
    }
    
    private func checkAuthStatus() {
//        if currentUserModel == nil {
//            topView = .pickPlayerView
//        }
    }
        
}

// MARK: - Authentication Services
extension FamilyKitState {

//    public func signOut(){
//        self.currentUserModel = nil
//        self.updateChanges()
//    }
    
//    public func signIn(
//        user: UserModel
//    ){
//        self.currentUserModel = user
//        self.updateChanges()
//    }
    
}

// MARK: - Authentication Services
//extension AppState {
//
//    func modifyCurrentPlayersPoints( points:Int) {
//        self.currentUserModel?.currentPoints += points
//    }
//
//    func addPlayer( model:UserModel) {
//        self.userStore.addPlayer(model: model)
//        updateChanges()
//    }
//}

