//
//  AdultsListView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/9/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation
import SwiftUI
import FamilyKit

struct AdultsListView: View {
    
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
            Section(header: Text("Adults: \(self.familyKitAppState.adultService.models.count)")) {
                NavigationLink(destination: AdultDetailView(model: CKAdultModel())) {
                    Text("Add a new Adult to this account")
                        .foregroundColor(.blue)
                }
                
                ForEach( self.familyKitAppState.adultService.models ) { model in
                    NavigationLink(destination: AdultDetailView(model: model)) {
                        Text(model.name ?? "~" )
                    }
                }//end ForEach
                    .onDelete(perform: delete)
            }//end section kids
        }.onAppear(perform: {
            self.familyKitAppState.adultService.fetch { (result) in
                print("result")
                self.familyKitAppState.onRefresh()
            }
        })
        //.navigationBarItems(trailing: trailingButton)
        //                    .navigationBarTitle("CKUser")
    }
    
    func delete(at offsets: IndexSet) {
        for deleteIndex in offsets {
            let deleteModel = self.familyKitAppState.adultService.models[deleteIndex]
            self.familyKitAppState.adultService.pushDelete(model: deleteModel) { (result) in
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
