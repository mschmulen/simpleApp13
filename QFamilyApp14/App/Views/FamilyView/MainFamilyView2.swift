//
//  MainFamilyView2.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 10/2/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation
import SwiftUI
import FamilyKit
import CloudKit

struct MainFamilyView2: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var activityDescriptionService: CKPrivateModelService<CKActivityDescriptionModel>
    @EnvironmentObject var activityService: CKPrivateModelService<CKActivityModel>
    @EnvironmentObject var storeItemPurchaseService: CKPrivateModelService<CKBuckRewardModel>
    
    var chatService: ChatService = ChatService( container: CKContainer(identifier: CKContainerIdentifier) )
    
    @State var devMessage: String?
    
    // playerPickerView
    let cardSize: CGFloat = 50
    let cardRadius: CGFloat = 20
    
    //@State var playerFilteredActivities: [CKActivityModel] = [CKActivityModel]()
    
    @State var playerFilter = MainFamilyPlayerFilterView.PlayerFilter.none
    
    //@State var showActivityStatusFilter: Bool = false
    //@State var activityStatusFilter = ActivityStatus.active
    
    @State var deepLinkModel : CKActivityModel?
    
    var body: some View {
        NavigationView {
            VStack {
                DevMessageView(devMessage: $devMessage)
                
                if deepLinkModel != nil {
                    NavigationLink(destination: CKActivityActiveDetailView(
                        model: deepLinkModel!,
                        localActivityStatus: deepLinkModel!.status,
                        showStatusButtons: true
                    )
                    ,tag: deepLinkModel!,
                    selection: $deepLinkModel) {
                        EmptyView()
                    }
                }
                
                ScrollView {
                    LazyVStack {
                        MainFamilyPlayerFilterView(
                            currentFilter: $playerFilter
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
                        
                        Section() {
                            CKRewardRowView(
                                categoryName: "Active Rewards",
                                items: storeItemPurchaseService.models
                                    .filter({ (model) -> Bool in
                                        switch playerFilter {
                                        case .none:
                                            return model.fulfillmentStatus == .purchased
                                        case .person(let player):
                                            guard let kidReference = model.purchasingPlayerReference?.recordID else {
                                                return false
                                            }
                                            guard let playerReference = player.ckRecord?.recordID else {
                                                return false
                                            }
                                            if kidReference != playerReference {
                                                return false
                                            }
                                            return model.fulfillmentStatus == .purchased
                                        }
                                    })
                            )
                        }
                        .listRowInsets(EdgeInsets())
                        
                        Section() {
                            CKRewardRowView(
                                categoryName: "Fulfilled Rewards",
                                items: storeItemPurchaseService.models
                                    .filter({ (model) -> Bool in
                                        switch playerFilter {
                                        case .none:
                                            return model.fulfillmentStatus == .fulfilled
                                        case .person(let player):
                                            guard let kidReference = model.purchasingPlayerReference?.recordID else {
                                                return false
                                            }
                                            guard let playerReference = player.ckRecord?.recordID else {
                                                return false
                                            }
                                            if kidReference != playerReference {
                                                return false
                                            }
                                            return model.fulfillmentStatus == .fulfilled
                                        }
                                    })
                            )
                        }
                        .listRowInsets(EdgeInsets())
                        
                    }//end List
                }//end scrollview
                
                
                //
                //                Text("version \(AppModel().appShortVersion)(\(AppModel().appBuildVersion))")
                //                    .font(.caption)
            }//end VStack
            .onAppear(perform: {
                self.checkForDeepLink()
            })
            .onReceive(NotificationCenter.default.publisher(for: FamilyKitNotifications.CKRemoteModelChangedNotification)) { _ in
                print("Notification.Name(CloudKitModelService) recieved")
                //self.devMessage = "silent Push! DB changed"
                
                self.activityService.fetch(
                    sortDescriptor: .none,
                    searchPredicate: .predicateTrue
                ) { (result) in
                    print( "result")
                }
                
                self.storeItemPurchaseService.fetch(sortDescriptor: .none, searchPredicate: .predicateTrue) { (result) in
                    print( "result")
                }
                
            }
            .navigationBarTitle("Family")
            .navigationBarItems(leading: leadingButton, trailing: trailingButton)
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
                        PlayerSelectView()
                        .environment(\.window, window)
                        .environmentObject(familyKitAppState)
                        .environmentObject(activityDescriptionService)
        ){
            HStack {
                Text("change player")
            }
        }
    }
    
    private func checkForDeepLink() {
        print( "check for deep link")
        
        switch appState.activeDeepLink {
        case .none:
            break
        case .tabFamily(let recordName, let recordType):
            if let recordType = recordType, let recordName = recordName {
                // self.showActivityIndicator = true
                let ckRecordID = CKRecord.ID(recordName: recordName)
                let recordReference =  CKRecord.Reference(recordID: ckRecordID, action: .none)
                activityService.fetchByReference(modelReference: recordReference) { (result) in
                    switch result {
                    case .success(let model):
                        print( "found the model \(model)")
                        self.deepLinkModel = model
                    case .failure(let error):
                        print( "errors \(error)")
                    }
                    //self.showActivityIndicator = false
                }
            }
        default:
            break
        }
    }//end check for deeplinks
}

struct MainFamilyView2_Previews: PreviewProvider {
    
    static let container = CKContainer(identifier: CKContainerIdentifier)
    
    static var previews: some View {
        MainFamilyView2()
            .environmentObject(AppState())
            .environmentObject((FamilyKitAppState(container: CloudKitContainer.MockContainer(container))))
            .environmentObject(CKPrivateModelService<CKActivityDescriptionModel>(container:CloudKitContainer.MockContainer(container)))
            .environmentObject(CKPrivateModelService<CKActivityModel>(container: CloudKitContainer.MockContainer(container)))
        //.environmentObject(ChatService(container:container))
        
    }
}


