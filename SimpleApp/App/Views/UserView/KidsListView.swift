//
//  KidsListView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/9/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit

struct KidsListView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var privateChoreService: CKPrivateModelService<CKActivityDescriptionModel>
    @EnvironmentObject var privateActiveChoreService: CKPrivateModelService<CKActivityModel>
    @EnvironmentObject var chatService: ChatService
    
    @State var devMessage: String?
    
    var body: some View {
        List{
            if devMessage != nil {
                Text("\(devMessage!)")
                    .foregroundColor(.red)
                    .onTapGesture {
                        self.devMessage = nil
                }
            }
            Section(header: Text("Kids: \(self.familyKitAppState.kidService.models.count)")) {
                NavigationLink(destination: KidDetailView(model: CKKidModel())) {
                    Text("Add a new Kid to this account")
                        .foregroundColor(.blue)
                }
                
                ForEach( self.familyKitAppState.kidService.models ) { model in
                    NavigationLink(destination: KidDetailView(model: model)) {
                        HStack {
                            Text("\(model.emoji ?? "~")")
                            Text("\(model.name ?? "~")")
                        }
                    }
                }//end ForEach
                    .onDelete(perform: delete)
            }//end section kids
        }.onAppear(perform: {
            self.familyKitAppState.kidService.fetch { (result) in
                print("result")
                self.familyKitAppState.onRefresh()
            }
        })
        //.navigationBarItems(trailing: trailingButton)
        //                    .navigationBarTitle("CKUser")
    }
    
    func delete(at offsets: IndexSet) {
        for deleteIndex in offsets {
            let deleteModel = self.familyKitAppState.kidService.models[deleteIndex]
            self.familyKitAppState.kidService.pushDelete(model: deleteModel) { (result) in
                switch result {
                case .failure(let error):
                    print("delete.error \(error)")
                case .success(let recordID):
                    print("delete.success \(recordID)")
                }
            }
        }
    }

}
