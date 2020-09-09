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
    
    //public let objectWillChange = ObservableObjectPublisher()
    
    public let isSimulator: Bool
    
    private var serverConfig: StoreConfig
    
    var currentAppInfo: AppModel = AppModel()
    
    @Published var topView: TopView = TopView.mainView
//        {
//        willSet {
//            updateChanges()
//        }
//    }
    
    @Published var selectedTab: Int = TabViewIndex.you.rawValue
//        {
//        willSet {
//            updateChanges()
//        }
//    }
    
    enum DeepLink {
        case none

        case tabYou
        case tabFamilyChat
        case tabFamily
        case tabBucks
        
        
        
        case detailScreenActivityDescription ( recordID: String )
        case activityUpdated ( recordID: String )
        case purchaseItem ( recordID: String )
    }
    
    @Published var activeDeepLink: DeepLink = .none
//        {
//        willSet {
//            updateChanges()
//        }
//    }
    
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

extension AppState {
    
    public func goToScreen(deepLink: DeepLink) {
        print("goToScreen \(deepLink)")
        switch deepLink {
        case .tabYou:
            topView = .mainView
            selectedTab = TabViewIndex.you.rawValue
        case .tabFamilyChat:
            topView = .mainView
            selectedTab = TabViewIndex.familyChat.rawValue
        case .tabFamily:
            topView = .mainView
            selectedTab = TabViewIndex.family.rawValue
        case .tabBucks:
            topView = .mainView
            selectedTab = TabViewIndex.bucksStore.rawValue
        default:
            return
        }
        updateChanges()
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

