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
    
    @EnvironmentObject var activityDescriptionService: CKPrivateModelService<CKActivityDescriptionModel>
    @EnvironmentObject var activityService: CKPrivateModelService<CKActivityModel>
    
    @EnvironmentObject var chatService: ChatService
    
    @State var devMessage: String?
    
    var body: some View {
        List{
            DevMessageView(devMessage: $devMessage)
            Section(header: Text("Family: \(self.familyKitAppState.playerService.models.count)")) {
                
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
            
            Section(header: Text("Share: Work In progress")) {
                ForEach( self.familyKitAppState.playerService.models ) { model in
                    if model.ckRecord != nil {
                        NavigationLink(destination: ShareInviteView(share: CKShare(rootRecord: model.ckRecord!), rootRecord: model.ckRecord!)) {
                            Text("share record \(model.name ?? "?")")
                                .foregroundColor(.blue)
                        }
                    } else {
                        Text("nil record")
                    }
                }
            }//end Share
            
        }.onAppear(perform: {
            self.familyKitAppState.onRefetchFromServer()
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
                case .success(_):
                    self.familyKitAppState.onRefetchFromServer()
                }
            }
        }
    }
    
}

struct PlayersListView_Previews: PreviewProvider {
    
    static let container = CKContainer(identifier: CKContainerIdentifier)
    
    static var previews: some View {
        PlayersListView()
            .environmentObject(AppState())
            .environmentObject((FamilyKitAppState(container: CloudKitContainer.CloudContainer(container))))
            .environmentObject(CKPrivateModelService<CKActivityDescriptionModel>(container: CloudKitContainer.CloudContainer(container)))
            .environmentObject(CKPrivateModelService<CKActivityModel>(container: CloudKitContainer.CloudContainer(container)))
    }
}
