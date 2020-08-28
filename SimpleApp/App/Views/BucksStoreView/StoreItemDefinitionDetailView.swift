//
//  StoreItemDefinitionDetailView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/27/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

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

    @State var devMessage: String?
    
    @State var model: CKStoreItemDefinitionModel
    
    @State var showActivityIndicator: Bool = false
    @State var activityIndicatorMessage: String = "Saving"
    
    var editView: some View {
        Section(header: Text("Data")) {
            Text("title \(model.title ?? "~")")
            
            TextField("name", text: $model.name ?? "")
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("info", text: $model.info ?? "")
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("bucks", value: $model.bucks ?? 0, formatter: NumberFormatter())
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
    
    var purchaseView: some View {
        //LargeTextPillBox("PURCHASE")
        LargeButton(title: "PURCHASE") {
            self.onPurchase()
        }
    }
    
    var body: some View {
        VStack {
            ActivityIndicatorView(
                isDisplayed: $showActivityIndicator,
                indicatorMessage: $activityIndicatorMessage
            ) {
                VStack{
                    DevMessageView(devMessage: self.$devMessage)
                    
                    self.purchaseView
                    
                    Button(action:self.onSave) {
                        HStack {
                            Text("Save")
                            Image(systemName: "square.and.arrow.up")
                        }.foregroundColor(.blue)
                    }
                    self.editView
                }//end List
            }
        }
        .onAppear {
            
            // Auto save it on open
//            if self.model.ckRecord == nil {
//                // save it
//                self.showActivityIndicator = true
//                self.storeItemDefinitionService.pushUpdateCreate(model: self.model) { (result) in
//                    switch result {
//                    case .success(let item):
//                        self.model = item
//                    case .failure(let error):
//                        print( "error \(error)")
//                    }
//                    self.showActivityIndicator = false
//                }
//            }//end if
        }
    }
    
    func onSave() {
        
        self.showActivityIndicator = true
        self.storeItemDefinitionService.pushUpdateCreate(model: self.model) { (result) in
            
            switch result {
            case .success(let item):
                self.model = item
                self.devMessage = "save success"
            case .failure(let error):
                self.devMessage = "error \(error)"
            }
            self.showActivityIndicator = false
        }
        
//        privateChoreService.pushUpdateCreate(model: model) { (result) in
//            switch result {
//            case .failure(let error):
//                self.devMessage = "save error\(error.localizedDescription)"
//            case .success(let record):
//                print( "success \(record)")
//                DispatchQueue.main.async {
//                    self.presentationMode.wrappedValue.dismiss()
//                    self.privateChoreService.fetch(
//                        sortDescriptor: .none,
//                        searchPredicate: .predicateTrue
//                    ) { (result) in
//                        print( "result")
//                    }
//                }
//            }
//        }
    }
    
    func onPurchase() {
        guard let name = model.name, let info = model.info, let bucks = model.bucks else {
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
        
        if currentPlayerBucks < bucks {
            self.devMessage = "not enough bucks"
            return
        }
        
        var newPurchase = CKStoreItemPurchaseModel()
        newPurchase.name = name
        newPurchase.info = info
        newPurchase.bucks = bucks
        
        storeItemPurchaseService.pushUpdateCreate(model: newPurchase) { (result) in
            switch result {
            case .failure(let error):
                self.devMessage = "purchase failure\(error)"
            case .success(let model):
                self.devMessage = "purchase success\(model.name ?? "")"
                self.familyKitAppState.addBucks(playerModel: currrentPlayerModel, bucks: (-1 * bucks))
                
                DispatchQueue.main.async {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
    
}//end StoreItemDefinitionDetailView

//struct StoreItemDefinitionDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            StoreItemDefinitionDetailView(
//                model: CKStoreItemDefinitionModel.mock, storeItemDefinitionService: <#CKPrivateModelService<CKStoreItemDefinitionModel>#>
//            )
//        }
//    }
//}
