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

struct StoreItemDefinitionEditDetailView: View {
    
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
                    
                    // edit view
                    VStack {
                        TextField("name", text: self.$model.name ?? "")
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        TextField("info", text: self.$model.info ?? "")
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Stepper("Bucks: \(self.model.bucks)", value: self.$model.bucks, in: 1...50)
                        
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
       Button(action:self.onSave) {
            HStack {
                Text("Save")
                Image(systemName: "square.and.arrow.up")
            }.foregroundColor(.blue)
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


//struct KeyboardAdaptive: ViewModifier {
//
//    @State private var keyboardHeight: CGFloat = 0
//
//    func body(content: Content) -> some View {
//        content
//            .padding(.bottom, keyboardHeight)
//            .onReceive(Publishers.keyboardHeight) { self.keyboardHeight = $0 }
//    }
//}
//
//extension View {
//    func keyboardAdaptive() -> some View {
//        ModifiedContent(content: self, modifier: KeyboardAdaptive())
//    }
//}


//struct StoreItemDefinitionDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            StoreItemDefinitionDetailView(
//                model: CKStoreItemDefinitionModel.mock, storeItemDefinitionService: <#CKPrivateModelService<CKStoreItemDefinitionModel>#>
//            )
//        }
//    }
//}


/*
//    @ObservedObject var input = NumbersOnly()

class NumbersOnly: ObservableObject {
    @Published var value = "" {
        didSet {
            let filtered = value.filter { $0.isNumber }
            
            if value != filtered {
                value = filtered
            }
        }
    }
}
*/


//struct IntSlider: View {
//
//    @Binding var sliderValue:Int
//
//    @State private var val = 0.0
//
//    var body: some View {
//        VStack {
//            Slider(value: $val, in: 1...50, step: 1)
//                .padding()
//                .accentColor(Color.green)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 15.0)
//                        .stroke(lineWidth: 2.0)
//                        .foregroundColor(Color.green)
//            )
//        }
//    }
//}
