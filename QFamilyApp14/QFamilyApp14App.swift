//
//  QFamilyApp14App.swift
//  QFamilyApp14
//
//  Created by Matthew Schmulen on 10/2/20.
//

import SwiftUI
import FamilyKit
import CloudKit

@main
struct QFamilyApp14App: App {
    
    @UIApplicationDelegateAdaptor(CustomAppDelegate.self) private var appDelegate
    
    @Environment(\.scenePhase) var scenePhase
    
    //    @StateObject var store = Store(
    //        initialState: AppState(),
    //        reducer: appReducer,
    //        environment: .live
    //    )
    
    //let context = PersistentCloudKitContainer.persistentContainer.viewContext
    
    let container:CKContainer = CKContainer(identifier: CKContainerIdentifier)
    
    let familyKitAppState: FamilyKitAppState
    let activityDescriptionService: CKPrivateModelService<CKActivityDescriptionModel>
    let activityService: CKPrivateModelService<CKActivityModel>
    let storeItemDefinitionService: CKPrivateModelService<CKBuckRewardDefinitionModel>
    let storeItemPurchaseService: CKPrivateModelService<CKBuckRewardModel>
    
    var appState:AppState = AppState()
    @State var customNotificationCenterDelegate: CustomNotificationCenterDelegate?
    
    var body: some Scene {
        
        WindowGroup {
            ContentView()
                .environmentObject(familyKitAppState)
                .environmentObject(activityDescriptionService)
                .environmentObject(activityService)
                .environmentObject(storeItemDefinitionService)
                .environmentObject(storeItemPurchaseService)
                .environmentObject(storeItemPurchaseService)
                .environmentObject(appState)
                .onOpenURL { url in
                    // handle the URL that must be opened
                    print( "on open URL \(url)")
                    guard let topView = url.topView else {
                        return
                    }
                    switch topView {
                    case .mainView:
                        appState.topView = .mainView
                        
                        guard let mainViewTabIndex = url.mainViewTabIndex else {
                            return
                        }
                        switch mainViewTabIndex {
                        case .you:
                            appState.selectedTab = TabViewIndex.you.rawValue
                        case .family:
                            appState.selectedTab = TabViewIndex.family.rawValue
                        case .rewards:
                            appState.selectedTab = TabViewIndex.rewards.rawValue
                        case .familyChat:
                            appState.selectedTab = TabViewIndex.familyChat.rawValue
                        case .tabX:
                            appState.selectedTab = TabViewIndex.tabX.rawValue
                        }
                    case .onboardingView:
                        appState.topView = .onboardingView
                    case .purchaseView:
                        appState.topView = .purchaseView
                    case .modalView:
                        appState.topView = .modalView
                    }
                    print("url: \(url.absoluteURL)") // qfamily-test://main/rewards/12345
                    print("scheme: \(String(describing: url.scheme))") // qfamily-test, https
                    print("host: \(String(describing: url.host))") // main
                    print("path: \(url.path)") // /rewards
                    print("components: \(url.pathComponents)") // ["/", "rewards", "12345"]
                }.onAppear {
                    print( "TopView on Appear")
                    
//                    if familyKitAppState.hasAdult {
//                         appState.topView = .mainView
//                    } else {
//                        appState.topView = .onboardingView
//                    }
                    
                }
        }//end WindowGroup
        .onChange(of: scenePhase) { newPhase in
            switch newPhase {
            case .active:
                onBecameActive()
            case .inactive:
                onBecameInactive()
            case .background:
                onInBackground()
            @unknown default:
                print("Fallback for future cases")
            }
        }
        
        // TODO: figure out how to use the Scene object ??
//        #if os(watchOS)
//        QFamilyTabScene(familyKitAppState: familyKitAppState)
//        #else
//        QFamilyTabScene(familyKitAppState: .constant(familyKitAppState))
//        #endif
    }
    
    func onBecameActive() {
        
        if let notificationDelegate = customNotificationCenterDelegate {
            UNUserNotificationCenter.current().delegate = notificationDelegate
        }
        
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
    
    init() {
        // ProductPurchaseStore.shared.initializeProducts()
        familyKitAppState = FamilyKitAppState(
            container: CloudKitContainer.CloudContainer(container)
        )
        activityDescriptionService = CKPrivateModelService<CKActivityDescriptionModel>(
            container: CloudKitContainer.CloudContainer(container)
        )
        activityService = CKPrivateModelService<CKActivityModel>(
            container: CloudKitContainer.CloudContainer(container)
        )
        storeItemDefinitionService = CKPrivateModelService<CKBuckRewardDefinitionModel>(container: CloudKitContainer.CloudContainer(container))
        storeItemPurchaseService = CKPrivateModelService<CKBuckRewardModel>(container: CloudKitContainer.CloudContainer(container))
        
        customNotificationCenterDelegate = CustomNotificationCenterDelegate(appState: appState)
    }
    
    
    
}













// ---------------------------
// Window Key
// ---------------------------
@available(iOS 13.0, *)
struct WindowKey: EnvironmentKey {
    struct Value {
        weak var value: UIWindow?
    }
    
    static let defaultValue: Value = .init(value: nil)
}

@available(iOS 13.0, *)
extension EnvironmentValues {
    var window: UIWindow? {
        get { return self[WindowKey.self].value }
        set { self[WindowKey.self] = .init(value: newValue) }
    }
}







