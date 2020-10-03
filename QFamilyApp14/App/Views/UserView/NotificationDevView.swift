//
//  NotificationDevView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 9/10/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit
import CloudKit

struct NotificationDevView: View {
    
    private var chatService: CKPrivateModelService<CKChatMessageModel> = CKPrivateModelService<CKChatMessageModel>(container: CloudKitContainer.CloudContainer(CKContainer(identifier: CKContainerIdentifier)))
    
    private var subscriptionService: CKPrivateSubscriptionService = CKPrivateSubscriptionService(container: CloudKitContainer.CloudContainer(CKContainer(identifier: CKContainerIdentifier)))
    
    @State var subScriptionModels: [SubscriptionModel] = []
    
    var body: some View {
        List{
            
            Section(header: Text("Deep Linking")) {
                
                Button(action: {
                    let manager = LocalNotificationManager()
                    manager.addNotification(
                        title: "LOCAL_TEST_BUCKS_TAB Notification Test",
                        category: LocalNotificationCategory.openBucksTab,
                        userInfo: [String:AnyObject]()
                    )
                    manager.schedule()
                }) {
                    Text("DeepLink BuckStore")
                }
                
                Button(action: {
                    let manager = LocalNotificationManager()
                    manager.addNotification(
                        title: "LOCAL_TEST_YOU_TAB Notification Test",
                        category: LocalNotificationCategory.openYouTab,
                        userInfo: [String : AnyObject]()
                    )
                    manager.schedule()
                }) {
                    Text("DeepLink 'You' tab")
                }
                
                Button(action: {
                    let manager = LocalNotificationManager()
                    manager.addNotification(
                        title: "LOCAL_TEST_CHAT_TAB Notification Test",
                        category: LocalNotificationCategory.openChatTab,
                        userInfo: [String : AnyObject]()
                    )
                    manager.schedule()
                }) {
                    Text("DeepLink Family Chat")
                }
                
                Button(action: {
                    let manager = LocalNotificationManager()
                    manager.addNotification(
                        title: "LOCAL_TEST_FAMILY_TAB Notification Test",
                        category: LocalNotificationCategory.openFamilyTab,
                        userInfo: [String : AnyObject]()
                    )
                    manager.schedule()
                }) {
                    Text("DeepLink Family Tab")
                }
            }//end Section

            Section(header: Text("Subscriptions \(self.subScriptionModels.count)")) {
                ForEach( self.subScriptionModels) { model in
                    NavigationLink(
                        destination: SubscriptionViewDetail(
                            model: model
                        )
                    ){
                        VStack {
                            Text("\(model.subscription.notificationInfo?.category ?? "~")")
                            Text("\(model.subscription.subscriptionID)")
                                .font(.caption)
                        }
                    }
                }//end ForEach
                //.onDelete(perform: deletePrivate)
            } // end Section
            
            //                    NavigationLink(
            //                        destination: SubscriptionViewDetail(
            //                            model: model
            //                        )
            //                    ){
            //                        CKActivityActiveItemView(model: model)
            //                    }.contextMenu {
            //                        Button(action: {
            //                            if let recordName = model.recordID?.recordName {
            //                                    let manager = LocalNotificationManager()
            //                                    var userInfo = [String : AnyObject]()
            //                                    userInfo["RECORD_NAME"] = recordName as AnyObject
            //                                    userInfo["RECORD_TYPE"] =  CKActivityModel.recordName as AnyObject
            //                                    manager.addNotification(
            //                                        title: "deepLinkModalView CKActivityDescriptionModel",
            //                                        category: LocalNotificationCategory.deepLinkModalView,
            //                                        userInfo: userInfo
            //                                    )
            //                                    manager.schedule()
            //                            }
            //                        }) {
            //                            Text("Modal Notification")
            //                            Image(systemName: "timer")
            //                        }
            //
            //                        Button(action: {
            //                            if let recordName = model.recordID?.recordName {
            //                                let manager = LocalNotificationManager()
            //                                var userInfo = [String : AnyObject]()
            //                                userInfo["RECORD_NAME"] = recordName as AnyObject
            //                                userInfo["RECORD_TYPE"] =  CKActivityModel.recordName as AnyObject
            //                                manager.addNotification(
            //                                    title: "deepLinkModalView CKActivityDescriptionModel",
            //                                    category: LocalNotificationCategory.openFamilyTab,
            //                                    userInfo: userInfo
            //                                )
            //                                manager.schedule()
            //                            }
            //                        }) {
            //                            Text("FamilyTab Notification")
            //                            Image(systemName: "timer")
            //                        }
            //
            //                    }
            //                }//end ForEach
            ////                    .onDelete(perform: deletePrivate)
            //            }//
            
            Section(header: Text("Subscription MGMT")) {
                Button(action: {
                    self.subscriptionService.fetchAndDeleteAllSubscriptions { (result) in
                        print( "result fetchAndDeleteAllSubscriptions \(result)")
                        switch result {
                        case .failure(let error):
                            print("error \(error)")
                        case .success(_):
                            self.fetchSubscriptions()
                        }
                    }
                }) {
                    Text("DELETE ALL SUBSCRIPTIONS")
                        .foregroundColor(.red)
                }
                
                Button(action: {
                    self.subscriptionService.fetchAllSubscriptions { (result) in
                        print( "result dumpAllSubscriptions \(result)")
                        switch result {
                        case .failure(let error):
                            print("error \(error)")
                        case .success(let models):
                            self.subScriptionModels = models
                        }
                    }
                }) {
                    Text("dumpAllSubscriptions")
                }
            }//end Section
            
        } //end list
            .onAppear {
                self.fetchSubscriptions()
        }
    } //end body
    
    func fetchSubscriptions() {
        self.subscriptionService.fetchAllSubscriptions { (result) in
            switch result {
            case .failure(let error):
                print("error \(error)")
            case .success(let models):
                print( "\(models.count)")
                self.subScriptionModels = models
            }
        }

    }
} //end View

struct SubscriptionViewDetail: View {
    
    var model: SubscriptionModel
    
    var body: some View {
        List {
            Text("SUBSCRIPTION")
            
            Section(header: Text("subscription info")) {
                Text("subscriptionID: \(model.subscription.subscriptionID)")
                Text("subscriptionType: \(model.subscription.subscriptionType.rawValue)")
            }
            
            Section(header: Text("notification info")) {
                Text("category: \(model.subscription.notificationInfo?.category ?? "~")")
                Text("alertActionLocalizationKey: \(model.subscription.notificationInfo?.alertActionLocalizationKey ?? "~")")
                Text("alertBody: \(model.subscription.notificationInfo?.alertBody ?? "~")")
                Text("collapseIDKey: \(model.subscription.notificationInfo?.collapseIDKey ?? "~")")
                Text("desiredKeys.count: \(model.subscription.notificationInfo?.desiredKeys?.count ?? 0 )")
            }
            
            if model.subscription.notificationInfo?.desiredKeys?.count != nil {
                Section(header: Text("desiredKeys\(model.subscription.notificationInfo!.desiredKeys!.count)")) {
                    Text("keys")
                    
                    ForEach( model.subscription.notificationInfo!.desiredKeys!, id:\.self) { key in
                        Text("key \(key)")
                    }
                }

            }
        }
    }
}
