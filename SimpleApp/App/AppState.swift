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
    
    var currentAppInfo: AppModel = AppModel()
    
    @Published var topView: ContentView.TopView = .testView { // .mainView
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
        
    }
        
}

// MARK: - Purchase Services
extension AppState {
    
//    public func makePurchase(
//        purchase: PurchaseModel.PurchaseStatus
//    ) -> Result<PurchaseModel,Error> {
//        let newModel = PurchaseModel(id: UUID(), status: purchase)
//        self.currentPurchaseModel = newModel
//        return .success(newModel)
//    }
//    
//    public func verifyPurchase(
//        purchase: String
//    ) -> Result<PurchaseModel?,Error> {
//        guard let activePurchase = self.currentPurchaseModel else {
//            return .success(nil)
//        }
//        return .success(activePurchase)
//    }
    
}

