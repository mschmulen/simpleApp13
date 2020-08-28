//
//  StoreItemPurchaseDetailView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/27/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import Combine
import FamilyKit
import SimpleGames

struct StoreItemPurchaseDetailView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var storeItemDefinitionService: CKPrivateModelService<CKStoreItemDefinitionModel>
    @EnvironmentObject var storeItemPurchaseService: CKPrivateModelService<CKStoreItemPurchaseModel>
    
    @State var devMessage: String?
    
    @State var model: CKStoreItemPurchaseModel
    
    var editView: some View {
        Section(header: Text("Data")) {
            Text("title \(model.title ?? "~")")
            
            TextField("name", text: $model.name ?? "")
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("info", text: $model.info ?? "")
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("bucks", value: $model.bucks, formatter: NumberFormatter())
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            
            Picker(selection: $model.fulfillmentStatus, label: Text("status")) {
                ForEach(CKStoreItemPurchaseModel.FulfillmentStatus.allCases, id: \.self) {
                    Text($0.rawValue)
                }
            }.pickerStyle(SegmentedPickerStyle())
            
        }
    }
    
    var body: some View {
        List{
            DevMessageView(devMessage: $devMessage)
            
            Button(action:onSave) {
                HStack {
                    Text("Save")
                    Image(systemName: "square.and.arrow.up")
                }.foregroundColor(.blue)
            }
            editView
        }//end List
            .onAppear {
        }
    }
    
    func onSave() {
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
    
}//end StoreItemPurchaseDetailView

struct StoreItemPurchaseDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StoreItemPurchaseDetailView(model: CKStoreItemPurchaseModel.mock)
        }
    }
}
