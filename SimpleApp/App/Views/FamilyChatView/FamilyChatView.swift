//
//  FamilyChatView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/26/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation
import SwiftUI
import FamilyKit
import CloudKit

struct FamilyChatView: View {
    
    @Environment(\.window) var window: UIWindow?
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var activityDescriptionService: CKPrivateModelService<CKActivityDescriptionModel>
    @EnvironmentObject var activityService: CKPrivateModelService<CKActivityModel>
    
    @State var devMessage: String?
    
    @State var chatService: ChatService = ChatService( container: CKContainer(identifier: CKContainerIdentifier) )
    @State var chatSessionModel: CKChatSessionModel?
    
//    @State var showActivityIndicator: Bool = false
//    @State var activityIndicatorMessage: String = "Loading"
    
    var body: some View {
        NavigationView {
            VStack {
                DevMessageView(devMessage: $devMessage)
//                ActivityIndicatorView(
//                    isDisplayed: $showActivityIndicator,
//                    indicatorMessage: $activityIndicatorMessage
//                ) {
                    VStack {
                        
                        if self.chatSessionModel != nil {
                            ChatSessionView(
                                chatSession: self.chatSessionModel!,
                                showTextField: true
                            )
                        } else {
                            Text("NO FAMILY SESSION")
                        }
                    }
//                }
            }
            .navigationBarTitle("Family Chat")
            //.navigationBarItems(leading: leadingButton, trailing: trailingButton)
        }.onAppear(perform: {
            self.configureChatSession()
            self.familyKitAppState.onRefetchFromServer()
        })
            .onReceive(NotificationCenter.default.publisher(for: FamilyKitNotifications.CKRemoteModelChangedNotification)) { _ in
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
        //}
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
    
    func configureChatSession() {
        //self.showActivityIndicator = true
        chatService.findOrMakeFamilySession { (result) in
            switch result {
            case .success(let sessionModel):
                self.chatSessionModel = sessionModel
                //self.showActivityIndicator = false
            case .failure(let error):
                self.devMessage = "error! \(error)"
                //self.showActivityIndicator = false
            }
        }
    }
}

struct FamilyChatView_Previews: PreviewProvider {
    
    static let container = CKContainer(identifier: CKContainerIdentifier)
    
    static var previews: some View {
        FamilyChatView()
            .environmentObject(AppState())
            .environmentObject((FamilyKitAppState(container: container)))
            .environmentObject(CKPrivateModelService<CKActivityDescriptionModel>(container:container))
            .environmentObject(CKPrivateModelService<CKActivityDescriptionModel>(container: container))
    }
}
