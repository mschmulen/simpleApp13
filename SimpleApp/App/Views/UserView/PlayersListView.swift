//
//  PlayersListView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/9/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit
import CloudKit

struct PlayersListView: View {
    
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
            Section(header: Text("Players: \(self.familyKitAppState.playerService.models.count)")) {
                
                NavigationLink(destination: PlayerDetailView(model: CKPlayerModel())) {
                    Text("Add a new Player to this account")
                        .foregroundColor(.blue)
                }
                
                ForEach( self.familyKitAppState.playerService.models ) { model in
                    NavigationLink(destination: PlayerDetailView(model: model)) {
                        HStack {
                            Text("\(model.emoji ?? "~")")
                            Text("\(model.name ?? "~")")
                        }
                    }
                }//end ForEach
                    .onDelete(perform: delete)
            }//end section kids
        }.onAppear(perform: {
            self.familyKitAppState.onRefresh()
        })
        //.navigationBarItems(trailing: trailingButton)
        //                    .navigationBarTitle("CKUser")
    }
    
    func delete(at offsets: IndexSet) {
        for deleteIndex in offsets {
            let deleteModel = self.familyKitAppState.playerService.models[deleteIndex]
            self.familyKitAppState.playerService.pushDelete(model: deleteModel) { (result) in
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

struct PlayersListView_Previews: PreviewProvider {
    static var previews: some View {
        PlayersListView()
        .environmentObject(AppState())
        .environmentObject((FamilyKitAppState(container: CKContainer(identifier: CKContainerIdentifier))))
        .environmentObject(CKPrivateModelService<CKActivityDescriptionModel>(container: CKContainer(identifier: CKContainerIdentifier)))
        .environmentObject(CKPublicModelService<CKActivityDescriptionModel>(container: CKContainer(identifier: CKContainerIdentifier)))
    }
}
