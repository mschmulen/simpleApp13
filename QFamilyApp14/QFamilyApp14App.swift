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
    
    //@UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    //let context = PersistentCloudKitContainer.persistentContainer.viewContext
    
    //let container = CKContainer.default()
    let container:CKContainer = CKContainer(identifier: CKContainerIdentifier)
    
    let familyKitAppState: FamilyKitAppState
    let activityDescriptionService: CKPrivateModelService<CKActivityDescriptionModel>
    let activityService: CKPrivateModelService<CKActivityModel>
    let storeItemDefinitionService: CKPrivateModelService<CKBuckRewardDefinitionModel>
    let storeItemPurchaseService: CKPrivateModelService<CKBuckRewardModel>
    
    var appState:AppState = AppState()
    
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
            //            .environment(\.window, window)
            
        }
    }
    
    init() {
        
        // ProductPurchaseStore.shared.initializeProducts()
        
        familyKitAppState = FamilyKitAppState(
            container: CloudKitContainer.CloudContainer(container)
        )
        // familyKitAppState.onStartup()
        
        // ---------------------------------------------
        // Activity Services
        activityDescriptionService = CKPrivateModelService<CKActivityDescriptionModel>(
            container: CloudKitContainer.CloudContainer(container)
        )
        activityDescriptionService.fetch(
            sortDescriptor: .custom(key: "creationDate", ascending: true),
            searchPredicate: .predicateTrue,
            completion: { result in
                //            switch result {
                //            case .success(let models) :
                //                print( "privateChoreService success \(models)")
                //            case .failure(let error):
                //                print( "privateChoreService error \(error)")
                //            }
            })
        activityDescriptionService.createSilentSubscription() { result in
            print( "createSilentSubscription \(result)")
        }
        activityDescriptionService.listenForRemoteNotifications()
        // ---------------------------------------------
        
        // ---------------------------------------------
        // activityService
        activityService = CKPrivateModelService<CKActivityModel>(
            container: CloudKitContainer.CloudContainer(container)
        )
        activityService.fetch(
            sortDescriptor: .custom(key: "modificationDate", ascending: false),
            searchPredicate: .predicateTrue,
            completion: { result in
            })
        activityService.createSilentSubscription() { result in
            print( "createSilentSubscription \(result)")
        }
        activityService.listenForRemoteNotifications()
        // ---------------------------------------------
        
        
        // ---------------------------------------------
        // Store Services
        storeItemDefinitionService = CKPrivateModelService<CKBuckRewardDefinitionModel>(container: CloudKitContainer.CloudContainer(container))
        storeItemDefinitionService.fetch(
            sortDescriptor: .none, //.custom(key: "modificationDate", ascending: false),
            searchPredicate: .predicateTrue,
            completion: { result in
            })
        // storeItemDefinitionService.subscribe(isSilent: false, message: "new Activity or activity changed")
        //storeItemDefinitionService.listenForNotifications()
        // ---------------------------------------------
        
        // ---------------------------------------------
        //
        storeItemPurchaseService = CKPrivateModelService<CKBuckRewardModel>(container: CloudKitContainer.CloudContainer(container))
        storeItemPurchaseService.fetch(
            sortDescriptor: .none, // .custom(key: "modificationDate", ascending: false),
            searchPredicate: .predicateTrue,
            completion: { result in
            })
        // ---------------------------------------------
        
    }
    
    func onStartup() {
        
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //let contentView = ContentView().environmentObject(appDelegate.viewRouter)
        //appDelegate.appState.onStartup()
        
        //        let contentView = ContentView()
        
    }
    
}



class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        return true
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
