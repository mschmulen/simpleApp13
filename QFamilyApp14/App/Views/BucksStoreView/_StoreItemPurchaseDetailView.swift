//
//  StoreItemPurchaseDetailView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/27/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

/*
import SwiftUI
import Combine
import FamilyKit
import SimpleGames

struct RewardDetailView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var storeItemDefinitionService: CKPrivateModelService<CKBuckRewardDefinitionModel>
    @EnvironmentObject var storeItemPurchaseService: CKPrivateModelService<CKBuckRewardModel>
    
    @State var devMessage: String?
    var enableEdit:Bool = true
    
    @State var model: CKBuckRewardModel
    @State var showActivityIndicator: Bool = false
    @State var activityIndicatorMessage: String = "Saving"
    
    var infoView: some View {
        Section(header: Text("Data")) {
            Text("title \(model.title ?? "~")")
            Text("info: \(model.info ?? "~")")
            Text("bucks: \(model.bucks)")
            Text("status: \(model.fulfillmentStatus.rawValue)")
            
            Text("purchasing player: \(model.purchasingPlayerReference?.recordID.recordName ?? "~")")
            Text("store reference: \(model.storeItemReference?.recordID.recordName ?? "~")")
        }
    }
    
    var editView: some View {
        Section(header: Text("edit")) {
            
            if model.fulfillmentStatus == CKBuckRewardModel.FulfillmentStatus.purchased {
                Button(action: {
                    self.model.fulfillmentStatus = .fulfilled
                    self.onSave()
                }) {
                    Text("Fulfill")
                }
            } else {
                Text("\(model.fulfillmentStatus.rawValue)")
            }
            
//            Button(action:self.onSave) {
//                HStack {
//                    Text("Save")
//                    Image(systemName: "square.and.arrow.up")
//                }.foregroundColor(.blue)
//            }
//            Picker(selection: $model.fulfillmentStatus, label: Text("status")) {
//                ForEach(CKStoreItemPurchaseModel.FulfillmentStatus.allCases, id: \.self) {
//                    Text($0.rawValue)
//                }
//            }.pickerStyle(SegmentedPickerStyle())
        }
    }
    
    var photoView: some View {
        Section(header: Text("Photos")) {
            Text("TODO Photo upload ")
        }
    }
    
    var chatView: some View {
        Section(header: Text("Chats")) {
            Text("TODO chat ")
        }
    }
    
    var body: some View {
        ActivityIndicatorView(
            isDisplayed: $showActivityIndicator,
            indicatorMessage: $activityIndicatorMessage
        ) {
            List{
                DevMessageView(devMessage: self.$devMessage)
                
                self.infoView
                if self.enableEdit {
                    self.editView
                }
                self.photoView
                self.chatView
                
            }//end List
                .onAppear {
                    self.fetchData()
            }
        }
    }
    
    func onSave() {
        self.showActivityIndicator = true
        self.storeItemPurchaseService.pushUpdateCreate(model: self.model) { (result) in
            switch result {
            case .success(let item):
                self.model = item
                self.devMessage = "save success"
                DispatchQueue.main.async {
                    
                    self.storeItemPurchaseService.fetch(sortDescriptor: .none, searchPredicate: .predicateTrue) { (result) in
                        switch result {
                        case .failure(let error):
                            print( "failure \(error)")
                        case .success(_):
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            case .failure(let error):
                self.devMessage = "error \(error)"
            }
            self.showActivityIndicator = false
        }
    }
    
    func fetchData() {
        print("fetchData")
    }
    
}//end StoreItemPurchaseDetailView

struct StoreItemPurchaseDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RewardDetailView(model: CKBuckRewardModel.mock)
        }
    }
}
*/

