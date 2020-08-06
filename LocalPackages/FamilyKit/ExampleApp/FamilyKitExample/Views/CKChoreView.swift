//
//  CKChoreview.swift
//  FamilyKitDemo
//
//  Created by Matthew Schmulen on 7/29/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit

struct CKChoreView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var choreService: CKPublicModelService<CKChoreModel>
    @EnvironmentObject var connectService: CKPublicModelService<CKConnectModel>
    @EnvironmentObject var funService: CKPublicModelService<CKFunModel>
    
    @State var devMessage: String?
    
    var deleteDisabled = false
    
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
                
                Section(header: Text("public Chores")) {
                    NavigationLink(destination: CKChoreDetailView(model: CKChoreModel())) {
                        Image(systemName: "plus")
                    }
                    
                    ForEach( self.choreService.models) { model in
                        NavigationLink(destination: CKChoreDetailView(model: model)) {
                            Text(model.title ?? "~" )
                        }
                        .deleteDisabled(self.deleteDisabled)
                    }//end ForEach
                    .onDelete(perform: deletePublic)
                }
                
//                Section(header: Text("private Chores")) {
//                    NavigationLink(destination: CKChoreDetailView(model: CKChoreModel())) {
//                        Image(systemName: "plus")
//                    }
//
//                    ForEach( self.choreService.models) { model in
//                        NavigationLink(destination: CKChoreDetailView(model: model)) {
//                            Text(model.title ?? "~" )
//                        }
//                        // .deleteDisabled(!self.appState.canEdit)
//                    }//end ForEach
//                    .onDelete(perform: deletePrivate)
//                }
            }
//                .disabled(yack.items.isEmpty)
            .navigationBarTitle("Activities")
            .navigationBarItems(trailing: trailingButton)
        }.onAppear {
            self.choreService.fetch { (result) in
                print( "fetch \(result)")
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: CKChangedNotification)) { _ in
            print("Notification.Name(CloudKitModelService) recieved")
            self.devMessage = "silent Push! DB changed"
            self.choreService.fetch { (result) in
                print( "fetch \(result)")
            }
        }
    }
    
    func deletePublic(at offsets: IndexSet) {
        for deleteIndex in offsets {
            let deleteModel = self.choreService.models[deleteIndex]
            self.choreService.pushDelete(model: deleteModel) { (result) in
                switch result {
                case .failure(let error):
                    print("delete.error \(error)")
                case .success(let recordID):
                    print("delete.success \(recordID)")
                }
            }
        }
    }
    
    func deletePrivate(at offsets: IndexSet) {
         for deleteIndex in offsets {
             let deleteModel = self.choreService.models[deleteIndex]
             self.choreService.pushDelete(model: deleteModel) { (result) in
                 switch result {
                 case .failure(let error):
                     print("delete.error \(error)")
                 case .success(let recordID):
                     print("delete.success \(recordID)")
                 }
             }
         }
     }
    
    private var trailingButton: some View {
        HStack {
            Text("\(familyKitAppState.currentPlayer.emoji) \(familyKitAppState.currentPlayer.name)")
            Button(action:onTrailing) { Image(systemName: "person.circle.fill") }
        }
    }
    
//
//        private var leadingButton: some View {
//            NavigationLink(destination: CKChoreDetailView(model: CKChoreModel(), containerConfig: .privateCloudDatabase)) {
//                Image(systemName: "plus")
//            }
//            // Button(action:onAdd) { Image(systemName: "plus") }
//        }
        
//        func onAdd() {
//            self.publicChoreService.pushNewPublic(model: CKChoreModel.mock) { (result) in
//                print("\(result)")
//            }
//        }
        
        func onTrailing() {
            print( "onTrailing")
        }
}
