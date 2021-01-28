//
//  KidUserView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/6/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit
import CloudKit
import SimpleGames

struct KidUserView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var activityDescriptionService: CKPrivateModelService<CKActivityDescriptionModel>
    @EnvironmentObject var activityService: CKPrivateModelService<CKActivityModel>

    @State var devMessage: String?
    
    var body: some View {
        List{
            DevMessageView(devMessage: $devMessage)
            
            Section(header: Text("Current Player")) {
                Text("\(familyKitAppState.currentPlayerModel?.name ?? "none")")
                
                NavigationLink(destination: PlayerSelectView(backgroundColor: .constant(SemanticAppColor.random))) {
                    Text("Change Current Player")
                        .foregroundColor(.blue)
                }
            }
            
            Section(header: Text("Dev Stuff")) {
                NavigationLink(destination: NotificationDevView()) {
                    Text("NotificationDevView")
                        .foregroundColor(.blue)
                }
                
                NavigationLink(destination: CKActivityActiveListView()) {
                    Text("Show Active Activities")
                        .foregroundColor(.blue)
                }
                
                if self.familyKitAppState.userService.ckAccountStatus == .available {
                    Text("CloudKit is available")
                    VStack {
                        Text("appleIDCredentialIdentifier:")
                        Text("\(self.familyKitAppState.userService.localUserDefaults_appleIDCredentialIdentifier ?? "")")
                    }
                } else {
                    VStack {
                        Text("CloudKit is NOT available")
                        Text("\(self.familyKitAppState.userService.ckAccountStatus.friendlyString)")
                    }
                }
            }
            
        }
        .onAppear(perform: {
            self.familyKitAppState.onRefetchFromServer()
        })
        .navigationBarTitle("\(familyKitAppState.currentPlayerModel?.name ?? "none")")
    }
}

struct KidUserView_Previews: PreviewProvider {

    static let container = CKContainer(identifier: CKContainerIdentifier)
    
    static var previews: some View {
        Group {
            KidUserView()
                //.environment(\.window, window)
                .environmentObject(AppState())
                .environmentObject(FamilyKitAppState(container: CloudKitContainer.MockContainer(container)))
                .previewDevice(PreviewDevice(rawValue: "iPad Air 2"))
            
            KidUserView()
                //.environment(\.window, window)
                .environmentObject(AppState())
                .environmentObject(FamilyKitAppState(container: CloudKitContainer.MockContainer(container)))
            .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
            .previewDisplayName("iPhone SE")
            
            KidUserView()
                //.environment(\.window, window)
                .environmentObject(AppState())
                .environmentObject(FamilyKitAppState(container: CloudKitContainer.MockContainer(container)))
            .previewDevice(PreviewDevice(rawValue: "iPhone XS Max"))
            .previewDisplayName("iPhone XS Max")

        }
    }
}

