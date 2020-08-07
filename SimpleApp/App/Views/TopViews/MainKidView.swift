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
    @EnvironmentObject var chatService: ChatService

    @State var devMessage: String?
    let appInfo = AppModel()
    
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
                Text("version \(appInfo.appShortVersion)(\(appInfo.appBuildVersion))")
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

