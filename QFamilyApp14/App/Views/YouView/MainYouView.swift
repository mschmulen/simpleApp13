//
//  MainYouViews.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 10/2/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation
import SwiftUI
import FamilyKit
import CloudKit

struct MainYouView: View {
    
    @Environment(\.window) var window: UIWindow?
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var activityDescriptionService: CKPrivateModelService<CKActivityDescriptionModel>
    @EnvironmentObject var activityService: CKPrivateModelService<CKActivityModel>
    
    @State var devMessage: String?
    
    @State var showAgent = false
    
    var activeActivities: some View {
        Section() {
            CKActivityActiveRowView(
                categoryName: "Active Activities (\(familyKitAppState.currentPlayerModel?.name ?? "none"))",
                items: activityService.models.filter({ (model) -> Bool in
                    if model.kidReference == familyKitAppState.currentPlayerModel?.recordReference {
                        return true
                    } else {
                        return false
                    }
                })
            )
        }
        .listRowInsets(EdgeInsets())
    }
    
    func sectionHeader(title:String, showAdd:Bool) -> some View {
        return HStack {
            if showAdd == true {
                Text("\(title)")
                .padding(.leading, 5)
                Spacer()
                NavigationLink(
                    destination: NewActivityDescriptionWizardView (
                        model: CKActivityDescriptionModel()
                    )
                ) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("ADD")
                    }.padding(.trailing, 20)
                }
            } else {
                Text("\(title)")
                    .padding(.leading, 5)
                Spacer()
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                DevMessageView(devMessage: $devMessage)
                
                if showAgent {
                    NavigationLink(
                        destination: AgentDetailView(
                            agentService: familyKitAppState.agentService
                        )
                    ) {
                        HStack {
                            Spacer()
                            Text("Agent \(familyKitAppState.agentService.name) \(familyKitAppState.agentService.emoji)")
                                .padding()
                        }
                    }
                }
                
                ScrollView {
                    LazyVStack {
                        
                        ForEach(ActivityCategory.allCases.filter {$0 != .none }, id: \.self) { category in
                            // Section(header: self.sectionHeader(title: "\(category.rawValue)", showAdd: self.familyKitAppState.currentPlayerModel?.isAdult ?? false))
                            Section() {
                                CKActivityDescriptionCardsRowView(
                                    categoryName: "\(category.rawValue) Activities:",
                                    items: self.activityDescriptionService.models.filter { $0.category == category },
                                    isPrivate: true,
                                    showAdd: self.familyKitAppState.currentPlayerModel?.isAdult ?? false
                                )
                            }
                            .listRowInsets(EdgeInsets())
                        }
                        
                        // this users active activities
                        activeActivities
                        
                    }//end LazyVStack
                }//end ScrollView
                
                Text("version \(appState.currentAppInfo.appShortVersion)(\(appState.currentAppInfo.appBuildVersion))")
                    .font(.caption)
            }.onReceive(NotificationCenter.default.publisher(for: FamilyKitNotifications.CKRemoteModelChangedNotification)) { _ in
                print("Notification.Name(CloudKitModelService) recieved")
                //self.devMessage = "silent Push! DB changed"
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
                }
            }
            .navigationBarTitle("\(familyKitAppState.currentPlayerModel?.name ?? "none")")
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
//            .background(
//                    NavigationLink(destination: UserView(), isActive: $showUserView) {
//                      EmptyView()
//                    }
//                )
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
            PlayerSelectView()
                .environment(\.window, window)
                .environmentObject(familyKitAppState)
        ){
            Text("change")
        }
    }
}

struct MainYouView_Previews: PreviewProvider {
    
    static let container = CKContainer(identifier: CKContainerIdentifier)
    
    static var previews: some View {
        MainYouView()
            .environmentObject(AppState())
            .environmentObject((FamilyKitAppState(container: CloudKitContainer.MockContainer(container))))
            .environmentObject(CKPrivateModelService<CKActivityDescriptionModel>(container: CloudKitContainer.MockContainer(container)))
            .environmentObject(CKPrivateModelService<CKActivityModel>(container: CloudKitContainer.MockContainer(container)))
            //.environmentObject(ChatService(container: container))
    }
}

//struct TabToolbar: ToolbarContent {
//
//    let userInfo: String
//    let showUserDetail: () -> Void
//    let changeUser: () -> Void
//
//    var body: some ToolbarContent {
//
//        ToolbarItem(placement: .primaryAction) {
//            Button("\(userInfo)", action: showUserDetail)
//        }
//
//        ToolbarItemGroup(placement: .primaryAction) {
//            Button("\(userInfo)", action: showUserDetail)
//            Button("change Player", action: changeUser)
//        }
//
////        ToolbarItem(placement: .primaryAction) {
////            Button("\(userInfo)", action: showUserDetail)
////        }
//
////        ToolbarItemGroup(placement: .bottomBar) {
////            Button("changeUser", action: changeUser)
////            Button("changeUser", action: changeUser)
////        }
//    }
//}