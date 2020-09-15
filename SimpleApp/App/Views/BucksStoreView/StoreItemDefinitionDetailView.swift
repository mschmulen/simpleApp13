//
//  StoreItemDefinitionDetailView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 9/3/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import FamilyKit
import SimpleGames
import CloudKit

struct StoreItemDefinitionDetailView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var storeItemDefinitionService: CKPrivateModelService<CKStoreItemDefinitionModel>
    @EnvironmentObject var storeItemPurchaseService: CKPrivateModelService<CKStoreItemPurchaseModel>
    
    @ObservedObject private var keyboard = KeyboardResponder()
    
    @State var devMessage: String?
    
    @State var model: CKStoreItemDefinitionModel
    
    @State var showActivityIndicator: Bool = false
    @State var activityIndicatorMessage: String = "Saving"
    
    var body: some View {
        VStack {
            ActivityIndicatorView(
                isDisplayed: $showActivityIndicator,
                indicatorMessage: $activityIndicatorMessage
            ) {
                VStack{
                    DevMessageView(devMessage: self.$devMessage)
                    
                    if self.model.recordID != nil {
                        LargeButton(title: "PURCHASE") {
                            self.onPurchase()
                        }
                    }
                    
                    VStack {
                        Text( "name: \(self.model.name ?? "")")
                        Text( "info: \(self.model.info ?? "")")
                        Text( "bucks: \(self.model.bucks)")
                    }
                    .padding()
                    .padding(.bottom, self.keyboard.currentHeight)
                }//end List
            }
             .navigationBarItems(trailing: trailingButton)
        }.onAppear {
            self.model.bucks = 2
        }
    }
    
    private var trailingButton: some View {
        NavigationLink(destination: StoreItemDefinitionEditDetailView(model: model)) {
            Text("EDIT")
        }
    }
    
    func onPurchase() {
        guard let name = model.name, let info = model.info else {
            self.devMessage = "invalid record info"
            return
        }
        
        guard let currrentPlayerModel = familyKitAppState.currentPlayerModel else {
            self.devMessage = "invalid player"
            return
        }
        
        guard let currentPlayerBucks = currrentPlayerModel.bucks else {
            self.devMessage = "no bucks"
            return
        }
        
        if currentPlayerBucks < model.bucks {
            self.devMessage = "not enough bucks"
            return
        }
        
        var newPurchase = CKStoreItemPurchaseModel(
            purchasingPlayer: currrentPlayerModel,
            storeItemReference: model
        )
        newPurchase.name = name
        newPurchase.info = info
        newPurchase.bucks = model.bucks
        newPurchase.fulfillmentStatus = .purchased
        
        storeItemPurchaseService.pushUpdateCreate(model: newPurchase) { (result) in
            switch result {
            case .failure(let error):
                self.devMessage = "purchase failure\(error)"
            case .success(let model):
                self.devMessage = "purchase success\(model.name ?? "")"
                self.familyKitAppState.addBucks(playerModel: currrentPlayerModel, bucks: (-1 * model.bucks))
                
                DispatchQueue.main.async {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
    

    
}//end StoreItemDefinitionDetailView
