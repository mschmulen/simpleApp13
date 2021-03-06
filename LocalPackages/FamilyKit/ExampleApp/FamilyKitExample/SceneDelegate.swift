//
//  SceneDelegate.swift
//  FamilyKitExample
//
//  Created by Matthew Schmulen on 7/31/20.
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
        
        let choreService = CKPublicModelService<CKChoreModel>(
            container: container
        )
        choreService.fetch(completion: { result in
            switch result {
            case .success(let models) :
                print( "choreService success \(models)")
            case .failure(let error):
                print( "choreService error \(error)")
            }
        })
        choreService.subscribe()
        choreService.listenForNotifications()
        
        let connectService = CKPublicModelService<CKConnectModel>(
            container: container
        )
        connectService.fetch(completion: { result in
            switch result {
            case .success(let models) :
                print( "connectService success \(models)")
            case .failure(let error):
                print( "connectService error \(error)")
            }
        })
        connectService.subscribe()
        connectService.listenForNotifications()
        
        let funService = CKPublicModelService<CKFunModel>(
            container: container
        )
        funService.fetch(completion: { result in
            switch result {
            case .success(let models) :
                print( "funService success \(models)")
            case .failure(let error):
                print( "funService error \(error)")
            }
        })
        funService.subscribe()
        funService.listenForNotifications()
        
        //        let kidService = CKPrivateModelService<CKKidModel>(
        //            container: container
        //        )
        //        kidService.fetch(completion: { result in
        //            switch result {
        //            case .success(let models) :
        //                print( "kidService success \(models)")
        //            case .failure(let error):
        //                print( "kidService error \(error)")
        //            }
        //        })
        //        kidService.subscribe()
        //        kidService.listenForNotifications()
        
        let contentView = ContentView()
            .environment(\.window, window)
            .environmentObject(familyKitAppState)
            .environmentObject(choreService)
            .environmentObject(funService)
            .environmentObject(connectService)
        
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
