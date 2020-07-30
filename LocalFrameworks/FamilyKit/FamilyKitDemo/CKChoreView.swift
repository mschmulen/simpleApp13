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
    @EnvironmentObject var familyKitState: FamilyKitState
    
    @EnvironmentObject var choreService: CKModelService<CKChoreModel>
    @EnvironmentObject var connectService: CKModelService<CKConnectModel>
    @EnvironmentObject var funService: CKModelService<CKFunModel>
    
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
                    ForEach( self.choreService.allModels) { model in
                        NavigationLink(destination: CKChoreDetailView(model: model, containerConfig: .publicCloudDatabase)) {
                            Text(model.title ?? "~" )
                        }
                        .deleteDisabled(self.deleteDisabled)
                    }//end ForEach
                    .onDelete(perform: delete)
                }
                
//                Section(header: Text("private Chores")) {
//                    ForEach( self.privateChoreService.allModels) { model in
//                        NavigationLink(destination: CKChoreDetailView(model: model, containerConfig: .privateCloudDatabase)) {
//                            Text(model.title ?? "~" )
//                        }
//                        // .deleteDisabled(!self.appState.canEdit)
//                    }//end ForEach
//                }
            }
//                .disabled(yack.items.isEmpty)
            .navigationBarTitle("Chores")
            .navigationBarItems(leading: leadingButton, trailing: trailingButton)
        }.onAppear {
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
        
//        if let first = offsets.first {
//            print( "first \(first)")
//            let deleteModel = self.choreService.allModels[first]
//            self.choreService.pushDelete(model: deleteModel) { (result) in
//                print("result \(result)")
//            }
//        }
//        self.choreService.allModels.remove(at: offsets)

        //users.remove(atOffsets: offsets)
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
            NavigationLink(destination: CKChoreDetailView(model: CKChoreModel(), containerConfig: .privateCloudDatabase)) {
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
