//
//  MainKidView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/6/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation
import SwiftUI
import FamilyKit
import CloudKit

struct MainKidView: View {
    
    @Environment(\.window) var window: UIWindow?
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var privateChoreService: CKPrivateModelService<CKActivityDescriptionModel>
    @EnvironmentObject var privateActiveChoreService: CKPrivateModelService<CKActivityModel>
    
    @EnvironmentObject var connectService: CKPublicModelService<CKConnectModel>
    @EnvironmentObject var funService: CKPublicModelService<CKFunModel>
    
    @State var funStore:FunStore = FunStore(storeConfig: StoreConfig.local)
    @State var choreStore:ChoreStore = ChoreStore(storeConfig: StoreConfig.local)
    @State var connectStore:ConnectStore = ConnectStore(storeConfig: StoreConfig.local)
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Text("Kid View")
                }
                
                List{
                    Section() {
                        CKChoreDescriptionRowView(
                            categoryName: "Activities (Family)",
                            items: privateChoreService.models,
                            isPrivate: true,
                            showAdd: familyKitAppState.currentPlayer.isAdult
                        )
                    }
                    .listRowInsets(EdgeInsets())
                    
                    Section() {
                        CKChoreActiveRowView(
                            categoryName: "Activities (\(familyKitAppState.currentPlayer.name)",
                            items: privateActiveChoreService.models.filter({ (model) -> Bool in
                                if model.kidReference == familyKitAppState.currentPlayer.recordReference {
                                    return true
                                } else {
                                    return false
                                }
                            })
                        )
                    }
                    .listRowInsets(EdgeInsets())
                }
            }
            .navigationBarItems(leading: leadingButton, trailing: trailingButton)
        }
    }
    
    private var trailingButton: some View {
        Group {
            NavigationLink(destination:
                KidUserView()
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

struct MainKidView_Previews: PreviewProvider {
    static var previews: some View {
        MainKidView()
            //.environment(\.window, window)
            .environmentObject(AppState())
            .environmentObject((FamilyKitAppState(container: CKContainer(identifier: CKContainerIdentifier))))
            .environmentObject(CKPrivateModelService<CKActivityDescriptionModel>(container: CKContainer(identifier: CKContainerIdentifier)))
            .environmentObject(CKPublicModelService<CKActivityDescriptionModel>(container: CKContainer(identifier: CKContainerIdentifier)))
            .environmentObject(CKPublicModelService<CKFunModel>(container: CKContainer(identifier: CKContainerIdentifier)))
            .environmentObject(CKPublicModelService<CKConnectModel>(container: CKContainer(identifier: CKContainerIdentifier)))
    }
}

