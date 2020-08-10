//
//  MainView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 7/23/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation
import SwiftUI
import FamilyKit
import CloudKit

struct MainAdultView: View {
    
    @Environment(\.window) var window: UIWindow?
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var privateChoreService: CKPrivateModelService<CKActivityDescriptionModel>
    @EnvironmentObject var privateActiveChoreService: CKPrivateModelService<CKActivityModel>
    @EnvironmentObject var chatService: ChatService
        
    // TODO: Clean up remove
    @State var funStore:FunStore = FunStore(storeConfig: StoreConfig.local)
    @State var choreStore:ChoreStore = ChoreStore(storeConfig: StoreConfig.local)
    @State var connectStore:ConnectStore = ConnectStore(storeConfig: StoreConfig.local)
    
    @State var devMessage: String?
    
    var body: some View {
        NavigationView {
            VStack {
                if devMessage != nil {
                    Text("\(devMessage!)")
                        .foregroundColor(.red)
                        .onTapGesture {
                            self.devMessage = nil
                    }
                }
                
                VStack {
                    Text("Adult View")
                }
                
                List {
                    Section() {
                        CKChoreDescriptionRowView(
                            categoryName: "Activity Definition",
                            items: privateChoreService.models,
                            isPrivate: true,
                            showAdd: familyKitAppState.currentPlayer.isAdult
                        )
                    }
                    .listRowInsets(EdgeInsets())
                    ForEach( self.familyKitAppState.kidService.models ) { kid in
                        Section() {
                            CKChoreActiveRowView(
                                categoryName: " \(kid.name ?? "~") Activities",
                                items: self.privateActiveChoreService.models.filter({ (model) -> Bool in
                                    model.kidReference?.recordID == kid.recordID
                                })
                            )
                        }
                        .listRowInsets(EdgeInsets())
                    }//end ForEach
                    
//                    ForEach(self.items) { model in
//                        NavigationLink(
//                            destination: CKChoreActiveDetailView(
//                                model: model
//                            )
//                        ) {
//                            CKChoreActiveItemView(model: model)
//                        }
//                    }
                    
//                    Section() {
//                        FunRowView(categoryName: "Fun", items: funStore.models)
//                    }
//                    .listRowInsets(EdgeInsets())
                }
                Text("version \(AppModel().appShortVersion)(\(AppModel().appBuildVersion))")
                    .font(.caption)
            }.onReceive(NotificationCenter.default.publisher(for: CKChangedNotification)) { _ in
                print("Notification.Name(CloudKitModelService) recieved")
                self.devMessage = "silent Push! DB changed"
                
                self.privateChoreService.fetch { (result) in
                    print( "result")
                }
                self.privateActiveChoreService.fetch { (result) in
                    print( "result")
                }
            }
            .navigationBarItems(leading: leadingButton, trailing: trailingButton)
        }
    }
    
    private var trailingButton: some View {
        Group {
            NavigationLink(destination:
                AdultUserView()
                    .environment(\.window, window)
                    .environmentObject(appState)
                    .environmentObject(familyKitAppState)
            ){
                HStack {
                    Text("\(familyKitAppState.currentPlayer.name)")
                    Text("\(familyKitAppState.currentPlayer.emoji)")
                    //Image(systemName: "person.circle.fill")
                }
            }
        }
    }
    
    private var leadingButton: some View {
        NavigationLink(destination:
            PlayerOnboardingView()
                .environment(\.window, window)
                .environmentObject(familyKitAppState)
                .environmentObject(privateChoreService)
        ){
            HStack {
                Text("change player")
                //Text("\(familyKitAppState.currentPlayer.emoji)")
                //Text("\(familyKitAppState.currentPlayer.name)")
                //Image(systemName: "person.circle.fill")
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainAdultView()
            //.environment(\.window, window)
            .environmentObject(AppState())
            .environmentObject((FamilyKitAppState(container: CKContainer(identifier: CKContainerIdentifier))))
            .environmentObject(CKPrivateModelService<CKActivityDescriptionModel>(container: CKContainer(identifier: CKContainerIdentifier)))
            .environmentObject(CKPublicModelService<CKActivityDescriptionModel>(container: CKContainer(identifier: CKContainerIdentifier)))
            .environmentObject(CKPublicModelService<CKFunModel>(container: CKContainer(identifier: CKContainerIdentifier)))
            .environmentObject(CKPublicModelService<CKConnectModel>(container: CKContainer(identifier: CKContainerIdentifier)))
    }
}
