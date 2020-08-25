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
    var chatService: ChatService = ChatService( container: CKContainer(identifier: CKContainerIdentifier) )
    
    @State var devMessage: String?
    
    // playerPickerView
    let cardSize:CGFloat = 50
    let cardRadius:CGFloat = 20
    
//    @State var activities: [CKActivityModel] = [CKActivityModel]()
    
    @State var playerFilter = MainFamilyPlayerFilterView.PlayerFilter.none
    @State var showFilterOptions: Bool = true
    @State var activityStatusFilter = ActivityStatus.active
    
    var body: some View {
        NavigationView {
            VStack {
                DevMessageView(devMessage: $devMessage)
                
                List {
                    
                    MainFamilyPlayerFilterView(
                        currentFilter: $playerFilter,
                        showFilterOptions: $showFilterOptions
                    )
                    
                    Section(
                        header: Text("\(playerFilter.name)")
                    ) {
                        ForEach( privateActiveChoreService.models.filter({ (model) -> Bool in
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
                                    model: model, localActivityStatus: model.status
                                )
                            ){
                                FamilyActivityCardView(model:model)
                            }
                            // TODO: fix this context menu ... it breaks stuffq
//                            .contextMenu {
//                                if self.familyKitAppState.isCurrentPlayerOwnerOrAdult(model: model) {
//                                    Button(action: {
//                                        self.privateActiveChoreService.pushDelete(model: model) { (result) in
//                                            print("delete result \(result)")
//                                        }
//                                    }) {
//                                        Text("Delete")
//                                        Image(systemName: "trash")
//                                    }
//                                } else {
//                                    Text("No Context Action")
//                                }
//                            }
                        }
                    }//end Section
                    
                    
                    
//                    MainFamilyViewStatusFilterView(activityStatusFilter: $activityStatusFilter)
//                    Section(header: Text("\(activityStatusFilter.friendlyName) Activities")) {
//                        ForEach( privateActiveChoreService.models.filter({ $0.status == activityStatusFilter}), id: \.self) { model in
//                            NavigationLink(
//                                destination: CKActivityActiveDetailView(
//                                    model: model, localActivityStatus: model.status
//                                )
//                            ){
//                                FamilyActivityCardView(model:model)
//                            }
//                        }
//                    }//end Section
                    
                }
                
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
                    
                    self.privateChoreService.fetch(
                        sortDescriptor: .none
                    ) { (result) in
                        print( "result")
                    }
                    self.privateActiveChoreService.fetch(
                        sortDescriptor: .none
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
            .environmentObject(CKPrivateModelService<CKActivityModel>(container: container))
            //.environmentObject(ChatService(container:container))
        
    }
}
