//
//  SceneDelegate.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 7/19/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import UIKit
import SwiftUI
import FamilyKit
import CloudKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        ProductPurchaseStore.shared.initializeProducts()
        
        var container = CKContainer.default()
        container = CKContainer(identifier: CKContainerIdentifier)
        
        let familyKitAppState = FamilyKitAppState(
            container: container
        )
        familyKitAppState.onStartup()
        
        
        // ---------------------------------------------
        // Activity Description
        let activityDescriptionService = CKPrivateModelService<CKActivityDescriptionModel>(
            container: container
        )
        activityDescriptionService.fetch(
            sortDescriptor: .none, searchPredicate: .predicateTrue,
            completion: { result in
//            switch result {
//            case .success(let models) :
//                print( "privateChoreService success \(models)")
//            case .failure(let error):
//                print( "privateChoreService error \(error)")
//            }
        })
        activityDescriptionService.subscribe(isSilent: true, message: "new ActivityDescription or change")
        activityDescriptionService.listenForNotifications()
        // ---------------------------------------------

       
        // ---------------------------------------------
        // Activity
        let activityService = CKPrivateModelService<CKActivityModel>(
            container: container
        )
        activityService.fetch(
            sortDescriptor: .none, searchPredicate: .predicateTrue,
            completion: { result in
        })
        activityService.subscribe(isSilent: false, message: "new Activity or activity changed")
        activityService.listenForNotifications()
        // ---------------------------------------------
        
        // ---------------------------------------------
        // StoreItem
//        let storeService = CKPrivateModelService<CKStoreItemModel>(
//            container: container
//        )
//        storeService.fetch(completion: { result in
//            //            switch result {
//            //            case .success(let models) :
//            //                print( "privateActiveChoreService success \(models)")
//            //            case .failure(let error):
//            //                print( "privateActiveChoreService error \(error)")
//            //            }
//        })
//        storeService.subscribe(isSilent: false, message: "new Store Item or changed")
//        storeService.listenForNotifications()
        // ---------------------------------------------
        
        
        // ---------------------------------------------
//        let chatService = ChatService(container: CKContainer(identifier: CKContainerIdentifier))
//        chatService.onRefresh()
//        chatService.chatMessageService.subscribe(isSilent: false, message: "New Chat")
//        chatService.chatMessageService.listenForNotifications()
//        chatService.onStartUp()
        // ---------------------------------------------
        
        let appState = AppState()
        appState.onStartup()
        
        let contentView = ContentView()
            .environment(\.window, window)
            .environmentObject(appState)
            .environmentObject(familyKitAppState)
            .environmentObject(activityDescriptionService)
            .environmentObject(activityService)
            //.environmentObject(chatService)
        
        //        let contentView = ContentView()
        //            .environment(\.window, window)
        //            .environmentObject(appState)
        
        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        // Save changes in the application's managed object context when the application transitions to the background.
        //(UIApplication.shared.delegate as? AppDelegate)?.saveContext()
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
