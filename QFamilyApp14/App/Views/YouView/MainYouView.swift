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
    
    let columns = [
        // make the grid to fit in as many items per row as possible, using a minimum size of 150 points each
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        return NavigationView {
            VStack {
                
                DevMessageView(devMessage: $devMessage)
                
                if showAgent {
                    agentView
                }
                
                if let currentPlayer = self.familyKitAppState.currentPlayerModel, currentPlayer.isAdult {
                    newActivityView
                }
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(activityDescriptionService.models, id: \.self) { model in
                            NavigationLink(
                                destination: CKActivityDescriptionDetailView(
                                    model: model
                                )
                            ) {
                                CKActivityDescriptionCardView(model: model)
                            }.contextMenu {
                                Button(action: {
                                    self.activityDescriptionService.pushDelete(model: model) { (result) in
                                        print("delete result \(result)")
                                    }
                                }) {
                                    Text("Delete")
                                    Image(systemName: "trash")
                                }
                            }
                        }//end ForEach
                        
                        activeActivities
                        
                    }//end LazyVGrid
                }//end ScrollView
                Text("version \(appState.currentAppInfo.appShortVersion)(\(appState.currentAppInfo.appBuildVersion))")
                    .font(.caption)
            }//end VStack
            .onReceive(NotificationCenter.default.publisher(for: FamilyKitNotifications.CKRemoteModelChangedNotification)) { _ in
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
        }//end NavigationView
    }//end body
    
    var agentView: some View {
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
    
    var newActivityView: some View {
        NavigationLink(
            destination: NewActivityDescriptionWizardView (
                model: CKActivityDescriptionModel()
            )
        ) {
            HStack {
                Image(systemName: "plus.circle.fill")
                Text("New Activity Description")
            }
            .padding(.top, 4)
            .padding(.bottom, 2)
        }
    }
    
    var xactiveActivities: some View {
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
        }//end Section
        .listRowInsets(EdgeInsets())
    }
    
//    var a = activityService.models.filter({ (model) -> Bool in
//        if model.kidReference == familyKitAppState.currentPlayerModel?.recordReference {
//            return true
//        } else {
//            return false
//        }
//    })

    
    var activeActivities: some View {
        Section() {
            
            //            CKActivityActiveRowView(
            //                categoryName: "Active Activities (\(familyKitAppState.currentPlayerModel?.name ?? "none"))",
            //                items: activityService.models.filter({ (model) -> Bool in
            //                    if model.kidReference == familyKitAppState.currentPlayerModel?.recordReference {
            //                        return true
            //                    } else {
            //                        return false
            //                    }
            //                })
            //            )
            
            VStack(alignment: .leading) {
                Text("Active Activities (\(familyKitAppState.currentPlayerModel?.name ?? "none"))")
                    .font(.headline)
                    .padding(.leading, 15)
                    .padding(.top, 5)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top, spacing: 0) {
                        
                        ForEach(activityService.models.filter({ (model) -> Bool in
                            if model.kidReference == familyKitAppState.currentPlayerModel?.recordReference {
                                return true
                            } else {
                                return false
                            }
                        })) { model in
                            NavigationLink(
                                destination: CKActivityActiveDetailView(
                                    model: model,
                                    localActivityStatus: model.status
                                )
                            ) {
                                CKActivityActiveItemView(model: model)
                            }.contextMenu {
                                if self.familyKitAppState.isCurrentPlayerOwnerOrAdult(model: model) {
                                    Button(action: {
                                        self.activityService.pushDelete(model: model) { (result) in
                                            print("delete result \(result)")
                                        }
                                    }) {
                                        Text("Delete")
                                        Image(systemName: "trash")
                                    }
                                } else {
                                    Text("No Context Action")
                                }
                            }
                        }
                    }
                }
                .frame(height: 185)
            }//end VStack
            .frame(maxWidth: .infinity)
        }//end Section
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
            PlayerSelectView(backgroundColor: .constant(SemanticAppColor.random))
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


