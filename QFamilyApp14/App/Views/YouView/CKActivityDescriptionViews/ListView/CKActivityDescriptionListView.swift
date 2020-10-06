//
//  CKActivityDescriptionListView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/1/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit
import CloudKit

struct CKActivityDescriptionListView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var activityDescriptionService: CKPrivateModelService<CKActivityDescriptionModel>
    @EnvironmentObject var activityService: CKPrivateModelService<CKActivityModel>
    
    @State var devMessage: String?
    
    var deleteDisabled = false
    
    var body: some View {
        List{
            DevMessageView(devMessage: $devMessage)
            
            Section(header: Text("Activities (Family)")) {
                NavigationLink(destination: NewActivityDescriptionWizardView(
                    model: CKActivityDescriptionModel()
                )) {
                    Image(systemName: "plus")
                }
                
                ForEach( self.activityDescriptionService.models) { model in
                    
                    NavigationLink(destination: CKActivityDescriptionDetailView(
                        model: model
                    )) {
                        CKActivityDescriptionCardView(model: model)
                    }.contextMenu {
                        Button(action: {
                            if let recordName = model.recordID?.recordName {
                                let manager = LocalNotificationManager()
                                var userInfo = [String : AnyObject]()
                                userInfo["RECORD_NAME"] = recordName as AnyObject
                                userInfo["RECORD_TYPE"] =  CKActivityDescriptionModel.recordName as AnyObject
                                manager.addNotification(
                                    title: "deepLinkModalView CKActivityDescriptionModel",
                                    category: LocalNotificationCategory.deepLinkModalView,
                                    userInfo: userInfo
                                )
                                manager.schedule()
                            }
                        }) {
                            Text("Modal Notification")
                            Image(systemName: "timer")
                        }
                    }
                    
                }//end ForEach
                    .onDelete(perform: deletePrivate)
            }//end List
        }.onAppear {
            
        }
        .onReceive(NotificationCenter.default.publisher(for: FamilyKitNotifications.CKRemoteModelChangedNotification)) { _ in
            print("Notification.Name(CloudKitModelService) recieved")
            //self.devMessage = "silent Push! DB changed"
            self.activityDescriptionService.fetch(
                sortDescriptor: .none,
                searchPredicate: .predicateTrue
            ) { (result) in
                print( "fetch \(result)")
            }
        }
    }
    
    func deletePrivate(at offsets: IndexSet) {
        for deleteIndex in offsets {
            let deleteModel = self.activityDescriptionService.models[deleteIndex]
            self.activityDescriptionService.pushDelete(model: deleteModel) { (result) in
                switch result {
                case .failure(let error):
                    print("delete.error \(error)")
                    self.devMessage = "delete.error \(error)"
                case .success(let recordID):
                    print("delete.success \(recordID)")
                }
            }
        }
    }
}

struct CKActivityDescriptionListView_Previews: PreviewProvider {
    
    static let container = CKContainer(identifier: CKContainerIdentifier)
    
    static var previews: some View {
        CKActivityDescriptionListView()
            .environmentObject(AppState())
            .environmentObject((FamilyKitAppState(container: CloudKitContainer.MockContainer(container))))
            .environmentObject(CKPrivateModelService<CKActivityDescriptionModel>(container: CloudKitContainer.MockContainer(container)))
            .environmentObject(CKPrivateModelService<CKActivityModel>(container: CloudKitContainer.MockContainer(container)))
    }
}
