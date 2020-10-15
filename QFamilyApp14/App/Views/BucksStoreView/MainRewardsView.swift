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
    
    @State var showNewRewardDefinitionWizardViewSheet = false
    
    let columns = [
        // make the grid to fit in as many items per row as possible, using a minimum size of 80 points each
        GridItem(.adaptive(minimum: 150))
    ]
    
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
            //            NavigationLink(
            //                destination: RewardDefinitionEditDetailView(
            //                    model: CKBuckRewardDefinitionModel()
            //                )
            //            ) {
            //                Text("new reward definition")
            //            }
            
            Button(action: {
                showNewRewardDefinitionWizardViewSheet.toggle()
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("New Reward Definition")
                }
                .padding()// .trailing, 20)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                DevMessageView(devMessage: $devMessage)
                
                leaderBoard
                
                adultView
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                    //LazyVStack {
                        //List {
                        Section(header: Text("available rewards")) {
                            ForEach( storeItemDefinitionService.models) { model in
                                NavigationLink(destination: RewardDefinitionDetailView(model: model) ) {
                                    RewardDefinitionCardView(model:model)
                                        .padding()
                                }
                                //.deleteDisabled(self.deleteDisabled)
                            }//end ForEach
                            .onDelete(perform: onDeleteDefinition)
                        }
                        Section(header: Text("Active rewards")) {
                            ForEach( storeItemPurchaseService.models) { model in
                                NavigationLink(destination: RewardDetailView(model: model) ) {
                                    RewardCardView(model: model)
                                        .padding()

                                }
                                //.deleteDisabled(self.deleteDisabled)
                            }//end ForEach
                            .onDelete(perform: onDeletePurchase)
                        }//end Section
                    }//end LazyVStack
                }//end Scrollview
                
                Text("version \(AppModel().appShortVersion)(\(AppModel().appBuildVersion))")
                    .font(.caption)
            }
            .sheet(isPresented: $showNewRewardDefinitionWizardViewSheet) {
                NewRewardDefinitionWizardView (
                    model: CKBuckRewardDefinitionModel()
                )
            }
            .onReceive(NotificationCenter.default.publisher(for: FamilyKitNotifications.CKRemoteModelChangedNotification)) { _ in
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
            .navigationBarTitleDisplayMode(NavigationBarItem.TitleDisplayMode.inline)
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Text("")
                        trailingButton
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        Text("")
                        leadingButton
                    }
                }
            }//end .toolbar
            
        }//end Nav
    }//end body
    
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
                        PlayerSelectView()
                        .environment(\.window, window)
                        .environmentObject(familyKitAppState)
                        .environmentObject(activityDescriptionService)
        ){
            HStack {
                Text("change")
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
