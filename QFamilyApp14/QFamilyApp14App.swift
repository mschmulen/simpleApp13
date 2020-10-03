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
            //.environment(\.window, window)
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
        
        // TODO: figure out how to use the Scene object
//        #if os(watchOS)
//        QFamilyTabScene(familyKitAppState: familyKitAppState)
//        #else
//        QFamilyTabScene(familyKitAppState: .constant(familyKitAppState))
//        #endif
    }
    
    func onBecameActive() {
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








/*

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // ------------------------------------------------------------
        // configure push notification
        // TODO: this needs to be moved to onboarding
        //        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (authorized, error) in
        //            print( "requestAuthorization \(authorized) ")
        //            print( "requestAuthorization \(String(describing: error)) ")
        //
        //            if authorized {
        //                DispatchQueue.main.async {
        //                    print( "registerForRemoteNotifications")
        //                    application.registerForRemoteNotifications()
        //                }
        //            }
        //        }
        //        UNUserNotificationCenter.current().delegate = self
        // ------------------------------------------------------------
        
        return true
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        //let dict = userInfo as! [String : NSObject]
        //print( "didReceiveRemoteNotification userInfo:\(userInfo)")
        // THIS IS FOR SILENT PUSH ?
        if let notification = CKQueryNotification(fromRemoteNotificationDictionary: userInfo) {
            
            // TODO: hande specific notifications
            print( "HANDLE SPECIFIC STORE NOTIFCATIONS")
            
            print( "userInfo \(userInfo)")
            
            print( "\(notification.recordFields)" )
            
            //            userInfo [AnyHashable("ck"): {
            //                ce = 2;
            //                cid = "iCloud.com.jumptack.FamilyKit";
            //                ckuserid = "_50125824373cb9a38c4142e6c601eb14";
            //                nid = "c18c8006-e1e4-4870-9cc4-e118c97dffcc";
            //                qry =     {
            //                    dbs = 1;
            //                    fo = 1;
            //                    rid = "F339154A-3AE0-45C1-9191-78620DAF3458";
            //                    sid = "E5F7E902-C020-4F9F-9E7D-13E53B4D4615";
            //                    zid = "_defaultZone";
            //                    zoid = "_50125824373cb9a38c4142e6c601eb14";
            //                };
            //            }, AnyHashable("aps"): {
            //                "content-available" = 1;
            //            }]
            
            CKPrivateModelService<CKActivityDescriptionModel>.notificationReceive( notification: notification)
            if notification.queryNotificationReason == .recordCreated {
                print( ".recordCreated")
                // ContentView().fetchRecord(record: (notification?.recordID)!)
            }
            if notification.queryNotificationReason == .recordUpdated {
                print( ".recordUpdated")
                //later
            }
            if notification.queryNotificationReason == .recordDeleted {
                print( ".recordDeleted")
                //ContentView().deleteRecord(record: (notification?.recordID)!)
            }
        }
    }
    
    func application(_ application: UIApplication, userDidAcceptCloudKitShareWith cloudKitShareMetadata: CKShare.Metadata) {
        let acceptShareOperation: CKAcceptSharesOperation =
            CKAcceptSharesOperation(shareMetadatas:
                                        [cloudKitShareMetadata])
        
        acceptShareOperation.qualityOfService = .userInteractive
        acceptShareOperation.perShareCompletionBlock = {meta, share,
                                                        error in
            print("userDidAcceptCloudKitShareWith share was accepted")
        }
        acceptShareOperation.acceptSharesCompletionBlock = {
            error in
            print( "error userDidAcceptCloudKitShareWith. error \(String(describing: error))")
            /// Send your user to where they need to go in your app
        }
        fatalError("TODO: userDidAcceptCloudKitShareWith needs to be implimented")
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // will show the notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("userNotificationCenter.willPresent notification \(notification)")
        
        let userInfo = notification.request.content.userInfo
        
        //print( "userInfo: \(userInfo)")
        print( "notification.request.content.categoryIdentifier: \(notification.request.content.categoryIdentifier)")
        
        if let notificationCategory = LocalNotificationCategory(rawValue: notification.request.content.categoryIdentifier) {
            switch notificationCategory {
            case .openBucksTab:
                completionHandler([.alert, .sound, .badge])
                return
            case .openChatTab:
                completionHandler([.alert, .sound, .badge])
                return
            case .openFamilyTab:
                completionHandler([.alert, .sound, .badge])
                return
            case .openYouTab:
                completionHandler([.alert, .sound, .badge])
                return
            case .deepLinkModalView:
                completionHandler([.alert, .sound, .badge])
                return
            }
        } else {
            if let queryNotification = CKQueryNotification(fromRemoteNotificationDictionary: userInfo) {
                print( "digested by a CKQueryNotification")
                print( "notification \(notification)")
                
                let recordFields = queryNotification.recordFields
                print( "recordFields \(recordFields)")
                
                //notification.request.content.subtitle = "yack"
                
                //recordFields Optional(["ownerName": Jay, "sessionReferenceID": B790B4D8-2011-4E89-B534-1A47DD057767, "ownerEmoji": 🐦])
                
                completionHandler([.alert, .sound, .badge])
                return
            } else {
                completionHandler(UNNotificationPresentationOptions(rawValue:0))
                return
            }
        }
    }
    
    // User did tap the notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("userNotificationCenter.didReceive didReceive")
        
        let userInfo = response.notification.request.content.userInfo
        //        print( "title: \(response.notification.request.content.title)")
        //        print( "subtitle: \(response.notification.request.content.subtitle)")
        //        print( "body: \(response.notification.request.content.body)")
        //        print( "userInfo: \(userInfo)")
        
        //        switch response.actionIdentifier {
        ////        case NotificationActions.HighFive.rawValue:
        ////            print("High Five Delivered!")
        //        default:
        //            print( "response.actionIdentifier: \(response.actionIdentifier)")
        //            break
        //        }
        
        print( "response.actionIdentifier: \(response.actionIdentifier)")
        print( "categoryIdentifier: \(response.notification.request.content.categoryIdentifier)")
        
        // check for LocalNotification processing
        if let notificationCategory = LocalNotificationCategory(rawValue: response.notification.request.content.categoryIdentifier) {
            
            print( "notificationCategory \(notificationCategory)")
            
            // TODO: fix self.appState
            /*
             switch notificationCategory {
             case .openBucksTab:
             self.appState.goToScreen(deepLink: .tabBucks)
             completionHandler()
             return
             case .openChatTab:
             self.appState.goToScreen(deepLink: .tabFamilyChat)
             completionHandler()
             return
             case .openFamilyTab:
             let recordName = userInfo["RECORD_NAME"] as? String
             let recordType = userInfo["RECORD_TYPE"] as? String
             self.appState.goToScreen(deepLink: .tabFamily(recordName: recordName, recordType: recordType))
             completionHandler()
             return
             case .openYouTab:
             self.appState.goToScreen(deepLink: .tabYou)
             completionHandler()
             return
             case .deepLinkModalView:
             if let recordName = userInfo["RECORD_NAME"] as? String,
             let recordType = userInfo["RECORD_TYPE"] as? String {
             
             self.appState.goToScreen(deepLink:
             .modalViewRecord(
             recordName: recordName,
             recordType: recordType
             )
             )
             completionHandler()
             } else {
             print( "bad data")
             completionHandler()
             }
             }//end switch
             */
        } else {
            //if let ckNotification = CKNotification(fromRemoteNotificationDictionary: userInfo ) {
            if let ckQueryNotification = CKQueryNotification(fromRemoteNotificationDictionary: userInfo) {
                processCKQueryNotification( with: ckQueryNotification )
            }
            completionHandler()
        }
    }
}

extension AppDelegate {
    
    func processCKQueryNotification(with queryNotification: CKQueryNotification) {
        print( "AppDelegate.processNotification")
        print( "pushNotificationInfo: \(queryNotification)")
        if let recordID = queryNotification.recordID {
            let recordName = recordID.recordName
            print("recordName \(recordName)")
        }
        
        if let categoryString = queryNotification.category, let familyKitCategory = NotificationCategory(rawValue: categoryString) {
            print( "category \(categoryString)")
            switch familyKitCategory {
            case .familyKitCategoryFamilyChatCreate:
                // check if it is a chat notification
                if let recordFields = queryNotification.recordFields {
                    print( "recordFields \(recordFields)")
                    if let ownerEmoji = recordFields["ownerEmoji"] as? String ,
                       let ownerName = recordFields["ownerName"] as? String,
                       let sessionReferenceID = recordFields["sessionReferenceID"] as? String {
                        
                        print( "\(ownerEmoji) \(ownerName) \(sessionReferenceID)")
                        
                        // TODO: fix self.appState
                        //self.appState.goToScreen(deepLink: .tabFamilyChat)
                    }
                }
            case .familyKitCategorySilentPushGeneric:
                print( "silent push generic do nothing")
                break
            case .familyKitCategorySilentPushPlayer:
                print( "silent push generic do nothing")
                break
            case .familyKitCategorySilentPushChore:
                print( "silent push generic do nothing")
                break
            case .familyKitCategorySilentPushChoreActive:
                print( "silent push generic do nothing")
                break
            case .familyKitCategorySilentPushChatMessage:
                print( "silent push generic do nothing")
                break
            case .familyKitCategorySilentPushStoreItemPurchase:
                print( "silent push generic do nothing")
                break
            case .familyKitCategorySilentPushChatSession:
                print( "silent push generic do nothing")
                break
            }
        } else {
            print( "failed to resovle the FamilyKitCKNotificationCategory from queryNotification.category: \(queryNotification.category ?? "~")")
        }
    }
    
    //    AppDelegate.presentView
    //    [AnyHashable("ck"): {
    //        ce = 2;
    //        cid = "iCloud.com.jumptack.FamilyKit";
    //        ckuserid = "_50125824373cb9a38c4142e6c601eb14";
    //        nid = "66a1bfd5-4f7c-437f-b5ad-4bae0b71b4a0";
    //        qry =     {
    //            dbs = 1;
    //            fo = 1;
    //            rid = "C8FA4AC1-B27B-4448-BDFD-5CCB048D40ED";
    //            sid = "AC91174C-55F0-49EA-ABA0-0D1B1796E273";
    //            zid = "_defaultZone";
    //            zoid = "_50125824373cb9a38c4142e6c601eb14";
    //        };
    //    }, AnyHashable("aps"): {
    //        alert = "New Chat";
    //        badge = 180;
    //        sound = default;
    //    }]
}

*/
