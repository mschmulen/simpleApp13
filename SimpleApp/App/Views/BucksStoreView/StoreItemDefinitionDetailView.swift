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

struct StoreItemDefinitionDetailView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @State var devMessage: String?
    
    @State var model: CKStoreItemDefinitionModel
    
    var editView: some View {
        Section(header: Text("Data")) {
            Text("title \(model.title ?? "~")")
            
            TextField("name", text: $model.name ?? "")
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("info", text: $model.info ?? "")
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("bucks", value: $model.bucks, formatter: NumberFormatter())
                .textFieldStyle(RoundedBorderTextFieldStyle())
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
    
}//end StoreItemDefinitionDetailView

struct StoreItemDefinitionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StoreItemDefinitionDetailView(model: CKStoreItemDefinitionModel.mock)
        }
    }
}
