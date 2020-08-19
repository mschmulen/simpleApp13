//
//  YouView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/6/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation
import SwiftUI
import FamilyKit
import CloudKit

struct YouView: View {
    
    @Environment(\.window) var window: UIWindow?
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var privateChoreService: CKPrivateModelService<CKActivityDescriptionModel>
    @EnvironmentObject var privateActiveChoreService: CKPrivateModelService<CKActivityModel>
    @EnvironmentObject var chatService: ChatService
    
    @State var devMessage: String?
    let appInfo = AppModel()
    
    var body: some View {
        NavigationView {
            VStack {
                DevMessageView(devMessage: $devMessage)
                List{
                    Section() {
                        CKActivityDescriptionCardsRowView(
                            categoryName: "Activities Todo:",
                            items: $privateChoreService.models,
                            isPrivate: true,
                            showAdd: self.familyKitAppState.currentPlayerModel?.isAdult ?? false
                        )
                    }
                    .listRowInsets(EdgeInsets())
                    
                    Section() {
                        CKActivityActiveRowView(
                            categoryName: "Active Activities (\(familyKitAppState.currentPlayerModel?.name ?? "none"))",
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
                Text("version \(appInfo.appShortVersion)(\(appInfo.appBuildVersion))")
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
            .navigationBarTitle("\(familyKitAppState.currentPlayerModel?.name ?? "none")")
            .navigationBarItems(leading: leadingButton, trailing: trailingButton)
        }
    }
    
    private var trailingButton: some View {
        Group {
            if (self.familyKitAppState.currentPlayerModel?.isAdult ?? false) {
                NavigationLink(destination:
                    AdultUserView()
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
            } else {
                NavigationLink(destination:
                    KidUserView()
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
    }
    
    private var leadingButton: some View {
        NavigationLink(destination:
            PlayerOnboardingView()
                .environment(\.window, window)
                .environmentObject(familyKitAppState)
        ){
            HStack {
                Text("change player")
            }
        }
    }
}

struct MainKidView_Previews: PreviewProvider {
    
    static let container = CKContainer(identifier: CKContainerIdentifier)
    
    static var previews: some View {
        YouView()
            .environmentObject(AppState())
            .environmentObject((FamilyKitAppState(container: container)))
            .environmentObject(CKPrivateModelService<CKActivityDescriptionModel>(container: container))
            .environmentObject(CKPrivateModelService<CKActivityModel>(container: container))
            .environmentObject(ChatService(container: container))
    }
}

