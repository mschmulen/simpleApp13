//
//  CKFunView.swift
//  FamilyKitDemo
//
//  Created by Matthew Schmulen on 7/29/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit

struct CKFunView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var familyKitState: FamilyKitState
    
        @EnvironmentObject var choreService: CKModelService<CKChoreModel>
    @EnvironmentObject var connectService: CKModelService<CKConnectModel>
    @EnvironmentObject var funService: CKModelService<CKFunModel>

    
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
                
                Section(header: Text("public Fun")) {
                    ForEach( self.funService.allModels) { model in
                        NavigationLink(destination: CKFunDetailView(model: model)) {
                            Text(model.title ?? "~" )
                        }
                        // .deleteDisabled(!self.appState.canEdit)
                    }//end ForEach
                    .onDelete(perform: delete)
                }
            }
            .navigationBarTitle("Fun")
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
                let deleteModel = self.choreService.allModels[deleteIndex]
                self.choreService.pushDelete(model: deleteModel) { (result) in
                    switch result {
                    case .failure(let error):
                        print("error \(error)")
                    case .success(let recordID):
                        print("success \(recordID)")
                    }
                }
            }
        }
    
    private var trailingButton: some View {
        HStack {
            if self.familyKitState.userService.currentUser == nil {
                Button(action:onTrailing) { Image(systemName: "person.circle") }
            } else {
                Text("\(self.familyKitState.userService.currentUser!.appleIDProvider_credential_user_givenName ?? "??")")
                Button(action:onTrailing) { Image(systemName: "person.circle.fill") }
            }
        }
    }
    
    private var leadingButton: some View {
        NavigationLink(destination: CKFunDetailView(model: CKFunModel())) {
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

