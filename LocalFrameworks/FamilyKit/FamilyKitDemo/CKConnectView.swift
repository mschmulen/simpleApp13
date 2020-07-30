//
//  CKConnectView.swift
//  FamilyKitDemo
//
//  Created by Matthew Schmulen on 7/29/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit

struct CKConnectView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var familyKitState: FamilyKitState
    
    @EnvironmentObject var choreService: CKPublicModelService<CKChoreModel>
    @EnvironmentObject var connectService: CKPublicModelService<CKConnectModel>
    @EnvironmentObject var funService: CKPublicModelService<CKFunModel>
    
    @State var devMessage: String?
    
    var body: some View {
        NavigationView {
            List{
                if devMessage != nil {
                    Text("\(devMessage!)")
                        .foregroundColor(.red)
                        .onTapGesture {
                            self.devMessage = nil
                    }
                }
                
                Section(header: Text("public Connect")) {
                    ForEach( self.connectService.models) { model in
                        NavigationLink(destination: CKConnectDetailView(model: model)) {
                            Text(model.title ?? "~" )
                        }
                        // .deleteDisabled(!self.appState.canEdit)
                    }//end ForEach
                    .onDelete(perform: delete)
                }
                
                Section(header: Text("private Connect")) {
                    ForEach( self.connectService.models) { model in
                        NavigationLink(destination: CKConnectDetailView(model: model)) {
                            Text(model.title ?? "~" )
                        }
                        // .deleteDisabled(!self.appState.canEdit)
                    }//end ForEach
                }
                
            }
            .navigationBarTitle("Connect")
            .navigationBarItems(leading: leadingButton, trailing: trailingButton)
        }
        .onAppear {
            //self.loadCKModels()
        }
        .onReceive(NotificationCenter.default.publisher(for: CKChangedNotification)) { _ in
            print("Notification.Name(CloudKitModelService) recieved")
            self.devMessage = "silent Push! DB changed"
        }
    }
    
    func delete(at offsets: IndexSet) {
        print( "delete \(offsets)")
        
        for deleteIndex in offsets {
            let deleteModel = self.choreService.models[deleteIndex]
            self.choreService.pushDelete(model: deleteModel) { (result) in
                switch result {
                case .failure(let error):
                    print("delete.error \(error)")
                case .success(let recordID):
                    print("success \(recordID)")
                }
            }
        }
    }
    
    private var trailingButton: some View {
        HStack {
            //Button(action:onTrailing) { Image(systemName: "person.circle") }
            Text("\(familyKitState.currentPlayer.name)")
            Button(action:onTrailing) { Image(systemName: "person.circle.fill") }
        }
    }
    
    private var leadingButton: some View {
        NavigationLink(destination: CKConnectDetailView(model: CKConnectModel())) {
            Image(systemName: "plus")
        }
        // Button(action:onAdd) { Image(systemName: "plus") }
    }
    
    //        func onAdd() {
    //            self.publicChoreService.pushNewPublic(model: CKChoreModel.mock) { (result) in
    //                print("\(result)")
    //            }
    //        }
    
    func onTrailing() {
        print( "onTrailing")
    }
}


