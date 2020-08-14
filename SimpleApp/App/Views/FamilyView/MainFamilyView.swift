//
//  MainFamilyView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/13/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation
import SwiftUI
import FamilyKit
import CloudKit

struct MainFamilyView: View {
    
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
    
    var playerPickerView: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack {
                VStack {
                    Text("🏡")
                    Text("Family")
                        .font(.headline)
                }
                .frame(width: 80, height: 80)
                .padding()
                .border(Color.gray)
                
                ForEach( self.familyKitAppState.playerService.models ) { player in
                    VStack {
                        Text("\(player.emoji ?? "")")
                        Text("\(player.name ?? "")")
                            .font(.headline)
                    }
                    .frame(width: 80, height: 80)
                    .padding()
                    .border(Color.gray)
                }
            }.padding()
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                DevMessageView(devMessage: $devMessage)
                
                Text("Family View")
                
                playerPickerView
                
                List {
                    ForEach( self.privateActiveChoreService.models) { model in
                        NavigationLink(
                            destination: CKChoreActiveDetailView(
                                model: model
                            )
                        ){
                            FamilyActivityCardView(model:model)
                        }
                    }
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
            }
        }
    }
}

struct MainFamilyView_Previews: PreviewProvider {
    
    static let container = CKContainer(identifier: CKContainerIdentifier)
    
    static var previews: some View {
        MainFamilyView()
            .environmentObject(AppState())
            .environmentObject((FamilyKitAppState(container: container)))
            .environmentObject(CKPrivateModelService<CKActivityDescriptionModel>(container:container))
            .environmentObject(CKPublicModelService<CKActivityDescriptionModel>(container: container))
            .environmentObject(CKPublicModelService<CKFunModel>(container: container))
            .environmentObject(CKPublicModelService<CKConnectModel>(container: container))
    }
}
