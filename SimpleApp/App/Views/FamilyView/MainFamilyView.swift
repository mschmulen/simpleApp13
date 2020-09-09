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
    
    @EnvironmentObject var activityDescriptionService: CKPrivateModelService<CKActivityDescriptionModel>
    @EnvironmentObject var activityService: CKPrivateModelService<CKActivityModel>
    var chatService: ChatService = ChatService( container: CKContainer(identifier: CKContainerIdentifier) )
    
    @State var devMessage: String?
    
    // playerPickerView
    let cardSize:CGFloat = 50
    let cardRadius:CGFloat = 20
    
    //@State var playerFilteredActivities: [CKActivityModel] = [CKActivityModel]()
    
    @State var showFilterByPlayerOptions: Bool = false
    @State var playerFilter = MainFamilyPlayerFilterView.PlayerFilter.none
    
    //@State var showActivityStatusFilter: Bool = false
    //@State var activityStatusFilter = ActivityStatus.active
    
    var listViewFancy: some View {
        List {
            
            MainFamilyPlayerFilterView(
                currentFilter: $playerFilter,
                showFilterOptions: $showFilterByPlayerOptions
            )
            
            Section() {
                CKActivityActiveRowView(
                    categoryName: "Completed",
                    items: activityService.models.filter({ (model) -> Bool in
                        
                        switch playerFilter {
                        case .none:
                            return model.status == ActivityStatus.completed
                        case .person(let player):
                            guard let kidReference = model.kidReference?.recordID else {
                                return false }
                            guard let playerReference = player.ckRecord?.recordID else {
                                return false }
                            if kidReference != playerReference {
                                return false
                            }
                            return model.status == ActivityStatus.completed
                        }
                    })
                )
            }
            .listRowInsets(EdgeInsets())
            
            Section() {
                CKActivityActiveRowView(
                    categoryName: "Active",
                    items: activityService.models.filter({ (model) -> Bool in
                        
                        switch playerFilter {
                        case .none:
                            return model.status == ActivityStatus.active
                        case .person(let player):
                            guard let kidReference = model.kidReference?.recordID else {
                                return false
                            }
                            guard let playerReference = player.ckRecord?.recordID else {
                                return false
                            }
                            if kidReference != playerReference {
                                return false
                            }
                            return model.status == ActivityStatus.active
                        }
                    })
                )
            }
            .listRowInsets(EdgeInsets())
            
            Section() {
                CKActivityActiveRowView(
                    categoryName: "Verified",
                    items: activityService.models.filter({ (model) -> Bool in
                        
                        switch playerFilter {
                        case .none:
                            return model.status == ActivityStatus.verified
                        case .person(let player):
                            guard let kidReference = model.kidReference?.recordID else {
                                return false
                            }
                            guard let playerReference = player.ckRecord?.recordID else {
                                return false
                            }
                            if kidReference != playerReference {
                                return false
                            }
                            return model.status == ActivityStatus.verified
                        }
                    })
                )
            }
            .listRowInsets(EdgeInsets())
            
            // TODO: "unknown" ... return model.status == ActivityStatus.unknown
            
        }//end List
    }//end listViewFancy
    
    var listViewSimple: some View {
        List {
            
            MainFamilyPlayerFilterView(
                currentFilter: $playerFilter,
                showFilterOptions: $showFilterByPlayerOptions
            )
            
            Section(
                header: Text("\(playerFilter.name)")
            ) {
                ForEach( activityService.models.filter({ (model) -> Bool in
                    switch playerFilter {
                    case .none: return true
                    case .person(let player):
                        guard let kidReference = model.kidReference?.recordID else { return true }
                        guard let playerReference = player.ckRecord?.recordID else {  return true }
                        if kidReference == playerReference {
                            return true
                        } else {
                            return false
                        }
                    }
                }), id: \.self) { model in
                    NavigationLink(
                        destination: CKActivityActiveDetailView(
                            model: model,
                            localActivityStatus: model.status,
                            showStatusButtons: true
                        ).buttonStyle(PlainButtonStyle())
                    ){
                        FamilyActivityCardView(model:model)
                            .edgesIgnoringSafeArea(.horizontal)
                    }
                }
            }//end Section
        }//end List
    } //end listViewSimple
    
    var body: some View {
        NavigationView {
            VStack {
                DevMessageView(devMessage: $devMessage)
                
//                 listViewSimple
                
                listViewFancy
                
                Text("version \(AppModel().appShortVersion)(\(AppModel().appBuildVersion))")
                    .font(.caption)
            }//end VStack
                .onAppear(perform: {
                    //self.activities = self.privateActiveChoreService.models
                })
                .navigationBarTitle("Family")
                
                .navigationBarItems(leading: leadingButton, trailing: trailingButton)
                .onReceive(NotificationCenter.default.publisher(for: FamilyKitNotifications.CKRemoteModelChangedNotification)) { _ in
                    print("Notification.Name(CloudKitModelService) recieved")
                    self.devMessage = "silent Push! DB changed"
                    
                    self.activityDescriptionService.fetch(
                        sortDescriptor: .none,
                        searchPredicate: .predicateTrue
                    ) { (result) in
                        print( "result")
                    }
                    self.activityService.fetch(
                        sortDescriptor: .none,
                        searchPredicate: .predicateTrue
                    ) { (result) in
                        print( "result")
                    } }
        }//end Navigation
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
                    Text("(\(familyKitAppState.currentPlayerModel?.bucks ??  0 ))")
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

struct MainFamilyView_Previews: PreviewProvider {
    
    static let container = CKContainer(identifier: CKContainerIdentifier)
    
    static var previews: some View {
        MainFamilyView()
            .environmentObject(AppState())
            .environmentObject((FamilyKitAppState(container: CloudKitContainer.MockContainer(container))))
            .environmentObject(CKPrivateModelService<CKActivityDescriptionModel>(container:CloudKitContainer.MockContainer(container)))
            .environmentObject(CKPrivateModelService<CKActivityModel>(container: CloudKitContainer.MockContainer(container)))
        //.environmentObject(ChatService(container:container))
        
    }
}

