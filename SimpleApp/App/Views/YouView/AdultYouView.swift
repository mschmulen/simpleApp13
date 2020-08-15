//
//  AdultYouView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 7/23/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation
import SwiftUI
import FamilyKit
import CloudKit

struct AdultYouView: View {
    
    @Environment(\.window) var window: UIWindow?
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var privateChoreService: CKPrivateModelService<CKActivityDescriptionModel>
    @EnvironmentObject var privateActiveChoreService: CKPrivateModelService<CKActivityModel>
    @EnvironmentObject var chatService: ChatService
    
    @State var devMessage: String?
    
    var body: some View {
        NavigationView {
            VStack {
                DevMessageView(devMessage: $devMessage)
                
                VStack {
                    Text("\(familyKitAppState.currentPlayer.name) (Adult)")
                }
                
                List {
                    Section() {
                        CKActivityDescriptionRowView(
                            categoryName: "Activity Definition",
                            items: privateChoreService.models,
                            isPrivate: true,
                            showAdd: familyKitAppState.currentPlayer.isAdult
                        )
                    }
                    .listRowInsets(EdgeInsets())
                    ForEach( self.familyKitAppState.playerService.models ) { kid in
                        Section() {
                            CKActivityActiveRowView(
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
            }.onReceive(NotificationCenter.default.publisher(for: FamilyKitNotifications.CKRemoteModelChangedNotification)) { _ in
                print("Notification.Name(CloudKitModelService) recieved")
                self.devMessage = "silent Push! DB changed"
                
                self.privateChoreService.fetch { (result) in
                    print( "result")
                }
                self.privateActiveChoreService.fetch { (result) in
                    print( "result")
                }
            }
            .navigationBarTitle("\(familyKitAppState.currentPlayer.name) (Adult)")
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
    
    static let container = CKContainer(identifier: CKContainerIdentifier)
    
    static var previews: some View {
        AdultYouView()
            .environmentObject(AppState())
            .environmentObject((FamilyKitAppState(container: container)))
            .environmentObject(CKPrivateModelService<CKActivityDescriptionModel>(container: container))
            .environmentObject(CKPrivateModelService<CKActivityModel>(container: container))
    }
}
