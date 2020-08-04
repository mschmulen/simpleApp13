//
//  CKChoreListView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/1/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit
import CloudKit

struct CKChoreListView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var privateChoreService: CKPrivateModelService<CKChoreModel>
    @EnvironmentObject var publicChoreService: CKPublicModelService<CKChoreModel>
    @EnvironmentObject var connectService: CKPublicModelService<CKConnectModel>
    @EnvironmentObject var funService: CKPublicModelService<CKFunModel>
    
    @State var devMessage: String?
    
    var deleteDisabled = false
    
    var body: some View {
        List{
            if devMessage != nil {
                Text("\(devMessage!)")
                    .foregroundColor(.red)
                    .onTapGesture {
                        self.devMessage = nil
                }
            }
            
            Section(header: Text("Chores (public)")) {
                NavigationLink(destination: CKChoreDetailView(model: CKChoreModel(), isPrivate:false, enableEdit: true)) {
                    Image(systemName: "plus")
                }
                
                ForEach( self.publicChoreService.models) { model in
                    NavigationLink(destination: CKChoreDetailView(model: model, isPrivate:false,enableEdit: true)) {
                        HStack {
                            Text(model.emoji ?? "~" )
                            Text(model.title ?? "~" )
                        }
                    }
                }//end ForEach
                    .onDelete(perform: deletePublic)
            }
            
            Section(header: Text("Chores (private)")) {
                NavigationLink(destination: CKChoreDetailView(model: CKChoreModel(), isPrivate:true, enableEdit: true)) {
                    Image(systemName: "plus")
                }
                
                ForEach( self.privateChoreService.models) { model in
                    NavigationLink(destination: CKChoreDetailView(model: model, isPrivate:true, enableEdit: true)) {
                        HStack {
                            Text(model.emoji ?? "~" )
                            Text(model.title ?? "~" )
                        }
                    }
                }//end ForEach
                    .onDelete(perform: deletePrivate)
            }//end List
        }.onAppear {
            self.publicChoreService.fetch { (result) in
                print( "fetch \(result)")
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: CKChangedNotification)) { _ in
            print("Notification.Name(CloudKitModelService) recieved")
            self.devMessage = "silent Push! DB changed"
            self.publicChoreService.fetch { (result) in
                print( "fetch \(result)")
            }
        }
    }
    
    func deletePublic(at offsets: IndexSet) {
        for deleteIndex in offsets {
            let deleteModel = self.publicChoreService.models[deleteIndex]
            self.publicChoreService.pushDelete(model: deleteModel) { (result) in
                switch result {
                case .failure(let error):
                    print("delete.error \(error)")
                    self.devMessage = "delete.error \(error)"
                case .success(let recordID):
                    print("delete.success \(recordID)")
                }
            }
        }
    }
    
    func deletePrivate(at offsets: IndexSet) {
        for deleteIndex in offsets {
            let deleteModel = self.publicChoreService.models[deleteIndex]
            self.publicChoreService.pushDelete(model: deleteModel) { (result) in
                switch result {
                case .failure(let error):
                    print("delete.error \(error)")
                    self.devMessage = "delete.error \(error)"
                case .success(let recordID):
                    print("delete.success \(recordID)")
                }
            }
        }
    }
}

struct CKChoreListView_Previews: PreviewProvider {
    static var previews: some View {
        CKChoreListView()
            .environmentObject(AppState())
            .environmentObject((FamilyKitAppState(container: CKContainer(identifier: CKContainerIdentifier))))
            .environmentObject(CKPrivateModelService<CKChoreModel>(container: CKContainer(identifier: CKContainerIdentifier)))
            .environmentObject(CKPublicModelService<CKChoreModel>(container: CKContainer(identifier: CKContainerIdentifier)))
            .environmentObject(CKPublicModelService<CKFunModel>(container: CKContainer(identifier: CKContainerIdentifier)))
            .environmentObject(CKPublicModelService<CKConnectModel>(container: CKContainer(identifier: CKContainerIdentifier)))
    }
}
