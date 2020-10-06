//
//  QFamilyTabScene.swift
//  QFamilyApp14
//
//  Created by Matthew Schmulen on 10/3/20.
//

/*
import SwiftUI
import FamilyKit
import CloudKit

struct QFamilyTabScene: Scene {
    
    @Environment(\.scenePhase) private var phase
    
    let container:CKContainer = CKContainer(identifier: CKContainerIdentifier)
    
    var appState:AppState = AppState()
    //    @EnvironmentObject var appState: AppState

    //    @ObservedObject var familyKitAppState: FamilyKitAppState
    @ObservedObject var familyKitAppState: FamilyKitAppState
//    var familyKitAppState: FamilyKitAppState
    
    
    
    
    let activityDescriptionService: CKPrivateModelService<CKActivityDescriptionModel>
    let activityService: CKPrivateModelService<CKActivityModel>
    let storeItemDefinitionService: CKPrivateModelService<CKBuckRewardDefinitionModel>
    let storeItemPurchaseService: CKPrivateModelService<CKBuckRewardModel>
    
    @State var devMessage: String?
    
    init(
         familyKitAppState: ObservedObject<FamilyKitAppState>
    ) {
        // ProductPurchaseStore.shared.initializeProducts()

        _familyKitAppState = familyKitAppState
//        familyKitAppState = FamilyKitAppState(
//            container: CloudKitContainer.CloudContainer(container)
//        )
        activityDescriptionService = CKPrivateModelService<CKActivityDescriptionModel>(
            container: CloudKitContainer.CloudContainer(container)
        )
        activityService = CKPrivateModelService<CKActivityModel>(
            container: CloudKitContainer.CloudContainer(container)
        )
        storeItemDefinitionService = CKPrivateModelService<CKBuckRewardDefinitionModel>(container: CloudKitContainer.CloudContainer(container))
        storeItemPurchaseService = CKPrivateModelService<CKBuckRewardModel>(container: CloudKitContainer.CloudContainer(container))
    }
    
    var body: some Scene {
        WindowGroup {
            //RootView().environmentObject(familyKitAppState)
            if devMessage != nil {
                Text("\(devMessage!)").foregroundColor(.red).onTapGesture { self.devMessage = nil }
            }
            
            // top level app state
            if appState.topView == .onboardingView {
                OnboardingView()
                    //.environment(\.window, window)
                    .environmentObject(appState)
                    .environmentObject(familyKitAppState)
                    .environmentObject(activityDescriptionService)
                    .environmentObject(activityService)
            }//end if .onboardingView
            else if appState.topView == .purchaseView {
                PurchaseView()
                    .environmentObject(appState)
            }//end if .purchaseView
            else if appState.topView == .mainView {
                if familyKitAppState.currentPlayerModel == nil {
                    VStack {
                        PlayerSelectView()
                            .environmentObject(familyKitAppState)
                        Text("version \(AppModel().appShortVersion)(\(AppModel().appBuildVersion))")
                            .font(.caption)
                    }
                } else {
                    
                    TabView {
                        Text("ViewA")
                        Text("ViewB")
                        Text("ViewC")
                    }
                    
                    /*
                     // we have a valid player
                     TabView(selection: appState.selectedTab) {
                     //                    TabView(selection: $selectedTab) {
                MainYouView()
                     .environment(\.window, window)
                     .environmentObject(appState)
                     .environmentObject(familyKitAppState)
                     .environmentObject(activityDescriptionService)
                     .environmentObject(activityService)
                     .tabItem {
                     Image(systemName: "person.circle")
                     Text("\(familyKitAppState.currentPlayerModel?.name ?? "none")")
                     }.tag(TabViewIndex.you.rawValue)
                     
                     MainFamilyView()
                     .environment(\.window, window)
                     .environmentObject(appState)
                     .environmentObject(familyKitAppState)
                     .environmentObject(activityDescriptionService)
                     .environmentObject(activityService)
                     .tabItem {
                     Image(systemName: "house")
                     Text("Family")
                     }.tag(TabViewIndex.family.rawValue)
                     
                     MainRewardsView()
                     .environment(\.window, window)
                     .environmentObject(appState)
                     .environmentObject(familyKitAppState)
                     .environmentObject(activityDescriptionService)
                     .environmentObject(activityService)
                     .environmentObject(storeItemDefinitionService)
                     .environmentObject(storeItemPurchaseService)
                     .tabItem {
                     Image(systemName: "dollarsign.circle")
                     // .font(.system(size: 28, weight: .light))
                     Text("Rewards")
                     }.tag(TabViewIndex.rewards.rawValue)
                     
                     FamilyChatView()
                     .environment(\.window, window)
                     .environmentObject(appState)
                     .environmentObject(familyKitAppState)
                     .environmentObject(activityDescriptionService)
                     .environmentObject(activityService)
                     .tabItem {
                     Image(systemName: "person.3")
                     Text("Chat")
                     }.tag(TabViewIndex.familyChat.rawValue)
                     } //end TabView
                     */
                    
                } // end else .currentPlayerModel == nil
            }
        }
        .onChange(of: phase) { newPhase in
            switch newPhase {
            case .active:
                print("App became active")
                onBecameActive()
            case .inactive:
                print("App became inactive")
                onBecameInactive()
            case .background:
                print("App is running in the background")
                onInBackground()
            @unknown default:
                print("Fallback for future cases")
            }
        }
    }
    
    
    func onBecameActive() {
        //appDelegate.appState.onStartup()
        familyKitAppState.onStartup()
        
        activityDescriptionService.fetch(
            sortDescriptor: .custom(key: "creationDate", ascending: true),
            searchPredicate: .predicateTrue,
            completion: { result in
                switch result {
                case .success(let models) :
                    print( "privateChoreService success \(models)")
                case .failure(let error):
                    print( "privateChoreService error \(error)")
                }
            })
        activityDescriptionService.createSilentSubscription() { result in
            print( "createSilentSubscription \(result)")
        }
        activityDescriptionService.listenForRemoteNotifications()
        
        activityService.fetch(
            sortDescriptor: .custom(key: "modificationDate", ascending: false),
            searchPredicate: .predicateTrue,
            completion: { result in
            })
        activityService.createSilentSubscription() { result in
            print( "createSilentSubscription \(result)")
        }
        activityService.listenForRemoteNotifications()
        
        
        
        storeItemPurchaseService.fetch(
            sortDescriptor: .none, // .custom(key: "modificationDate", ascending: false),
            searchPredicate: .predicateTrue,
            completion: { result in
            })
        storeItemDefinitionService.fetch(
            sortDescriptor: .none, //.custom(key: "modificationDate", ascending: false),
            searchPredicate: .predicateTrue,
            completion: { result in
            })
        
    }//end onBecameActive
    
    func onInBackground() {
        print( "onInBackground")
    }
    
    func onBecameInactive() {
        print( "onBecameInactive")
    }
    
    
}

*/

