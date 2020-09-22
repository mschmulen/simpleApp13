//
//  MainRewardsView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/13/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation
import SwiftUI
import FamilyKit
import CloudKit

struct MainRewardsView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var activityDescriptionService: CKPrivateModelService<CKActivityDescriptionModel>
    @EnvironmentObject var activityService: CKPrivateModelService<CKActivityModel>
    
    @EnvironmentObject var storeItemDefinitionService: CKPrivateModelService<CKBuckRewardDefinitionModel>
    @EnvironmentObject var storeItemPurchaseService: CKPrivateModelService<CKBuckRewardModel>

    @State var devMessage: String?
    
    var leaderBoard: some View {
        VStack {
            Text("Leaderboard")
                .modifier(PrimaryBoldLabel(color: .black))
            
            ForEach( self.familyKitAppState.playerService.models.sorted(by: { (modelA, modelB) -> Bool in
                (modelA.bucks ?? 0) > (modelB.bucks ?? 0)
            }) ) { player in
                HStack {
                    Text("\(player.emoji ?? "")")
                    Text("\(player.name ?? ""):")
                        .modifier(PrimaryMediumLabel(color: .black))
                    Text("\(player.bucks ?? 0)")
                        .modifier(PrimaryMediumLabel(color: .black))
                    Spacer()
                }
            }
        }
        .padding()
    }
    
    var adultView: some View {
        VStack {
            NavigationLink(
                destination: RewardDefinitionEditDetailView(
                    model: CKBuckRewardDefinitionModel()
                )
            ) {
                Text("new reward definition")
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
                    Section(header: Text("available rewards")) {
                        ForEach( storeItemDefinitionService.models) { model in
                            NavigationLink(destination: RewardDefinitionEditDetailView(model: model) ) {
                                VStack {
                                    Text("\(model.name ?? "")")
                                    Text("\(model.bucks)")
                                }
                            }
                            //.deleteDisabled(self.deleteDisabled)
                        }//end ForEach
                        .onDelete(perform: onDeleteDefinition)
                    }
                    Section(header: Text("Active rewards")) {
                        ForEach( storeItemPurchaseService.models) { model in
                            NavigationLink(destination: RewardDetailView(model: model) ) {
                                VStack{
                                    Text("\(model.name ?? "")")
                                    Text("\(model.fulfillmentStatus.rawValue)")
                                }
                            }
                            //.deleteDisabled(self.deleteDisabled)
                        }//end ForEach
                        .onDelete(perform: onDeletePurchase)
                    }
                }
                
                Text("version \(AppModel().appShortVersion)(\(AppModel().appBuildVersion))")
                    .font(.caption)
            }.onReceive(NotificationCenter.default.publisher(for: FamilyKitNotifications.CKRemoteModelChangedNotification)) { _ in
                print("Notification.Name(CloudKitModelService) recieved")
                //self.devMessage = "silent Push! DB changed"
                
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

    func onDeleteDefinition(at offsets: IndexSet) {
        for deleteIndex in offsets {
            let deleteModel = self.storeItemDefinitionService.models[deleteIndex]
            self.storeItemDefinitionService.pushDelete(model: deleteModel) { (result) in
                print("delete result \(result)")
            }
        }
    }
    
    func onDeletePurchase(at offsets: IndexSet) {
        for deleteIndex in offsets {
            let deleteModel = self.storeItemPurchaseService.models[deleteIndex]
            self.storeItemPurchaseService.pushDelete(model: deleteModel) { (result) in
                print("delete result \(result)")
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
        MainRewardsView()
            .environmentObject(AppState())
            .environmentObject(
                FamilyKitAppState(
                    container: CloudKitContainer.MockContainer(container)
                )
        )
            .environmentObject(
                CKPrivateModelService<CKActivityDescriptionModel>(
                    container: CloudKitContainer.MockContainer(container)
                )
        )
            .environmentObject(
                CKPrivateModelService<CKActivityDescriptionModel>(
                    container: CloudKitContainer.MockContainer(container)
                )
        )
    }
}
