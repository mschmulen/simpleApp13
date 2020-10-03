//
//  ShareInviteView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 9/22/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit
import CloudKit

struct ShareInviteView: View {
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @State var name: String = ""
    @State var emailString: String = ""
    
    var objectToShare:ObjectToShare = ObjectToShare()
    var share: CKShare
    var rootRecord: CKRecord
    
    @State var isShowing: Bool = false
    
    var body: some View {
        VStack {
            Text("Sharing")
            
//            TextField("email", text: $emailString)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
            
//            Button(action: {
//                print( "invite")
//                self.familyKitAppState.shareService.sendInvite()
//            }) {
//                Text("SEND INVITE")
//            }
            
            Button(action: {
                self.isShowing = true
            }) {
                Text("Share one record")
            }
            
            CloudSharingController(
                toShare: objectToShare,
                share: share,
                rootRecord: rootRecord,
                container: familyKitAppState.container,
                isShowing: $isShowing
            )
            
            // TODO: Share all by setting the parent object to some universally sharable object, maybe a family record
            
            Button(action: {
                print( "share all ")
            }) {
                Text("Share All")
            }
            
        }
    }
}


