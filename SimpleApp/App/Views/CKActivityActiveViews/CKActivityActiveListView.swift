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
    
    @EnvironmentObject var privateChoreService: CKPrivateModelService<CKActivityDescriptionModel>
    @EnvironmentObject var privateActiveChoreService: CKPrivateModelService<CKActivityModel>
    @EnvironmentObject var chatService: ChatService
        
    @State var devMessage: String?
    
    var deleteDisabled = false
    
    var body: some View {
        List{
            DevMessageView(devMessage: $devMessage)
            
            Section(header: Text("Activities (CKChoreActiveModel)")) {
                ForEach( self.privateActiveChoreService.models) { model in
                    NavigationLink(
                        destination: CKActivityActiveDetailView(
                            model: model
                        )
                    ){
                        CKActivityActiveItemView(model: model)
                    }
                }//end ForEach
                    .onDelete(perform: deletePrivate)
            }//end List
        }.onAppear {
            
        }
        .onReceive(NotificationCenter.default.publisher(for: FamilyKitNotifications.CKChangedNotification)) { _ in
            print("Notification.Name(CloudKitModelService) recieved")
            self.devMessage = "silent Push! DB changed"
            self.privateChoreService.fetch { (result) in
                print( "fetch \(result)")
            }
        }
    }

    func deletePrivate(at offsets: IndexSet) {
        for deleteIndex in offsets {
            let deleteModel = self.privateChoreService.models[deleteIndex]
            self.privateChoreService.pushDelete(model: deleteModel) { (result) in
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
            .environmentObject((FamilyKitAppState(container: container)))
            .environmentObject(CKPrivateModelService<CKActivityDescriptionModel>(container: container))
            .environmentObject(CKPrivateModelService<CKActivityModel>(container: container))
    }
}
