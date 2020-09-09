//
//  CKChoreDescriptionListView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/1/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit
import CloudKit

struct CKActivityActiveListView: View {
    
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
            
            Section(header: Text("Activities (CKChoreActiveModel)")) {
                ForEach( self.activityService.models) { model in
                    NavigationLink(
                        destination: CKActivityActiveDetailView(
                            model: model,
                            localActivityStatus: model.status,
                            showStatusButtons: true
                        )
                    ){
                        CKActivityActiveItemView(model: model)
                    }
                }//end ForEach
                    .onDelete(perform: deletePrivate)
            }//end List
        }.onAppear {
            
        }
        .onReceive(NotificationCenter.default.publisher(for: FamilyKitNotifications.CKRemoteModelChangedNotification)) { _ in
            print("Notification.Name(CloudKitModelService) recieved")
            self.devMessage = "silent Push! DB changed"
            self.activityDescriptionService.fetch(
                sortDescriptor: .custom(key: "creationDate", ascending: false),
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

struct CKChoreActiveListView_Previews: PreviewProvider {
    
    static let container = CKContainer(identifier: CKContainerIdentifier)
    
    static var previews: some View {
        CKActivityActiveListView()
            .environmentObject(AppState())
            .environmentObject((FamilyKitAppState(container: CloudKitContainer.MockContainer(container))))
            .environmentObject(CKPrivateModelService<CKActivityDescriptionModel>(container: CloudKitContainer.MockContainer(container)))
            .environmentObject(CKPrivateModelService<CKActivityModel>(container: CloudKitContainer.MockContainer(container)))
    }
}
