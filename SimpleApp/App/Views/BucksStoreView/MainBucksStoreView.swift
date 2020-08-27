//
//  MainBucksStoreView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/13/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation
import SwiftUI
import FamilyKit
import CloudKit

struct MainBucksStoreView: View {
    
    @Environment(\.window) var window: UIWindow?
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var activityDescriptionService: CKPrivateModelService<CKActivityDescriptionModel>
    @EnvironmentObject var activityService: CKPrivateModelService<CKActivityModel>
    
    @State var devMessage: String?
    
    // For tomorrow
    // let storeItemDefinitionService: CKPrivateModelService<CKStoreItemDefinitionModel> = CKPrivateModelService<CKStoreItemDefinitionModel>(container: CKContainer(identifier: CKContainerIdentifier))
    
    var leaderBoard: some View {
        VStack {
            Text("Leaderboard")
                .font(.system(size: 15, weight: .bold, design: .rounded))
            
            ForEach( self.familyKitAppState.playerService.models.sorted(by: { (modelA, modelB) -> Bool in
                (modelA.bucks ?? 0) > (modelB.bucks ?? 0)
            }) ) { player in
                HStack {
                    Text("\(player.emoji ?? "")")
                    Text("\(player.name ?? ""):")
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                    Text("\(player.bucks ?? 0)")
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                    Spacer()
                }
            }
        }
        .padding()
    }
    
    var adultView: some View {
        VStack {
            NavigationLink(destination: StoreItemDefinitionDetailView(model: CKStoreItemDefinitionModel()) ) {
                Text("new Item definition")
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                DevMessageView(devMessage: $devMessage)
                
                leaderBoard
                
                adultView
                
                List {
                    Section(header: Text("Items for purchase")) {
                        NavigationLink(destination: StoreItemDefinitionDetailView(model: CKStoreItemDefinitionModel()) ) {
                            Text("TODO")
                        }
                        
                        NavigationLink(destination: StoreItemDefinitionDetailView(model: CKStoreItemDefinitionModel()) ) {
                            Text("TODO")
                        }
                        
                        NavigationLink(destination: StoreItemDefinitionDetailView(model: CKStoreItemDefinitionModel()) ) {
                            Text("TODO")
                        }
                        
                    }
                    Section(header: Text("purchased items")) {
                        
                        NavigationLink(destination: StoreItemPurchaseDetailView(model: CKStoreItemPurchaseModel()) ) {
                            Text("TODO")
                        }
                        
                        NavigationLink(destination: StoreItemPurchaseDetailView(model: CKStoreItemPurchaseModel()) ) {
                            Text("TODO")
                        }
                        
                    }
                }
                
                Text("version \(AppModel().appShortVersion)(\(AppModel().appBuildVersion))")
                    .font(.caption)
            }.onReceive(NotificationCenter.default.publisher(for: FamilyKitNotifications.CKRemoteModelChangedNotification)) { _ in
                print("Notification.Name(CloudKitModelService) recieved")
                self.devMessage = "silent Push! DB changed"
                
                self.activityDescriptionService.fetch(
                    sortDescriptor: .none, searchPredicate: .predicateTrue
                ) { (result) in
                    print( "result")
                }
                self.activityService.fetch(
                    sortDescriptor: .none, searchPredicate: .predicateTrue
                ) { (result) in
                    print( "result")
                }
            }
            .navigationBarTitle("Bucks Store")
            .navigationBarItems(leading: leadingButton, trailing: trailingButton)
        }
    }
    
    private var trailingButton: some View {
        Group {
            NavigationLink(destination:
                UserView()
                    .environment(\.window, window)
                    .environmentObject(appState)
                    .environmentObject(familyKitAppState)
            ){
                HStack {
                    Text("\(familyKitAppState.currentPlayerModel?.name ?? "none")")
                    Text("\(familyKitAppState.currentPlayerModel?.emoji ?? "🌞")")
                    Text("(\(familyKitAppState.currentPlayerModel?.bucks ?? 0 ))")
                }
            }
        }
    }
    
    private var leadingButton: some View {
        NavigationLink(destination:
            PlayerOnboardingView()
                .environment(\.window, window)
                .environmentObject(familyKitAppState)
                .environmentObject(activityDescriptionService)
        ){
            HStack {
                Text("change player")
            }
        }
    }
}

struct MainBucksStoreView_Previews: PreviewProvider {
    
    static let container = CKContainer(identifier: CKContainerIdentifier)
    
    static var previews: some View {
        MainBucksStoreView()
            .environmentObject(AppState())
            .environmentObject((FamilyKitAppState(container: container)))
            .environmentObject(CKPrivateModelService<CKActivityDescriptionModel>(container:container))
            .environmentObject(CKPrivateModelService<CKActivityDescriptionModel>(container: container))
    }
}
