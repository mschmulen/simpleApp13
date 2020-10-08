//
//  CKUserView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 9/22/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit
import CloudKit

struct CKUserView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var activityDescriptionService: CKPrivateModelService<CKActivityDescriptionModel>
    @EnvironmentObject var activityService: CKPrivateModelService<CKActivityModel>
    
    @EnvironmentObject var chatService: ChatService
    
    @State var devMessage: String?
    
    var body: some View {
        List{
            
            DevMessageView(devMessage: $devMessage)
            Text("DEV CKUser Stuff")
            
            Section(header: Text("current CK user")) {
                if familyKitAppState.userService.currentUser != nil {
                    Text("name: \(familyKitAppState.userService.currentUser!.name ?? "~")")
                    Text("emoji: \(familyKitAppState.userService.currentUser!.emoji ?? "~")")
                    Text("localeCurrentLanguageCode: \(familyKitAppState.userService.currentUser!.localeCurrentLanguageCode ?? "~")")
                    Text("localeCurrentRegionCode: \(familyKitAppState.userService.currentUser!.localeCurrentRegionCode ?? "~")")
                } else {
                    Text("current user is nil")
                }
                
//                ForEach( self.familyKitAppState.playerService.models ) { model in
//                    if model.ckRecord != nil {
//                        NavigationLink(destination: ShareInviteView(share: CKShare(rootRecord: model.ckRecord!), rootRecord: model.ckRecord!)) {
//                            Text("\(model.name ?? "?"): share record ")
//                                .foregroundColor(.blue)
//                        }
//                    } else {
//                        Text("nil record")
//                    }
//                }
            }//end Section
            
            Section(header: Text("localePreferredLanguages:")) {
                if familyKitAppState.userService.currentUser!.localePreferredLanguages != nil {
                    ForEach( familyKitAppState.userService.currentUser!.localePreferredLanguages!, id:\.self ) { langString in
                        Text("language: \(langString)")
                    }
                } else {
                    Text("none ")
                }
            }
            
        }.onAppear(perform: {
            self.familyKitAppState.onRefetchFromServer()
        })
        //.navigationBarItems(trailing: trailingButton)
        //                    .navigationBarTitle("CKUser")
    }
    
}

struct CKUserView_Previews: PreviewProvider {
    
    static let container = CKContainer(identifier: CKContainerIdentifier)
    
    static var previews: some View {
        CKUserView()
            .environmentObject(AppState())
            .environmentObject((FamilyKitAppState(container: CloudKitContainer.CloudContainer(container))))
            .environmentObject(CKPrivateModelService<CKActivityDescriptionModel>(container: CloudKitContainer.CloudContainer(container)))
            .environmentObject(CKPrivateModelService<CKActivityModel>(container: CloudKitContainer.CloudContainer(container)))
    }
}

