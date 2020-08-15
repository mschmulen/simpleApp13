//
//  UserView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 7/19/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit
import CloudKit
import SimpleGames

struct AdultUserView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var privateChoreService: CKPrivateModelService<CKActivityDescriptionModel>
    @EnvironmentObject var privateActiveChoreService: CKPrivateModelService<CKActivityModel>
    @EnvironmentObject var chatService: ChatService
    
    @State var devMessage: String?
    
    var body: some View {
        List{
            DevMessageView(devMessage: $devMessage)
            
            HStack {
                Text("\(familyKitAppState.currentPlayer.emoji)")
                Text("\(familyKitAppState.currentPlayer.name)")
            }
            
            Text("Bucks: \(familyKitAppState.currentPlayer.bucks)")
            
            NavigationLink(destination: PlayerOnboardingView()) {
                Text("Change Current Player")
                    .foregroundColor(.blue)
            }
            
            Section(header: Text("Family")) {
                NavigationLink(destination: PlayersListView()) {
                    Text("Show Players")
                        .foregroundColor(.blue)
                }
                
                NavigationLink(destination: ChatSessionView()) {
                    Text("Show Chat")
                        .foregroundColor(.blue)
                }
                
                NavigationLink(destination: CKActivityDescriptionListView()) {
                    Text("Show Activity Descriptions")
                        .foregroundColor(.blue)
                }
                
                NavigationLink(destination: CKActivityActiveListView()) {
                    Text("Show Active Activities")
                        .foregroundColor(.blue)
                }
            }
                        
            Section(header: Text(" Dev Stuff")) {
                
                NavigationLink(destination: PurchaseView()) {
                    Text("PurchaseView")
                        .foregroundColor(.blue)
                }
                
                // Dev stuff
                if self.familyKitAppState.userService.ckAccountStatus == .available {
                    Text("CloudKit is available")
                    //                        if self.appState.userService.currentUser != nil {
                    //                            Text("\(self.appState.userService.currentUser?.recordID?.recordName ?? "~")")
                    //                        }
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
                
//                if familyKitAppState.isSimulator == false {
//                    // Notifications
//                    Button(action: {
//                        print("Enable Notifications")
//                        let center = UNUserNotificationCenter.current()
//                        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
//                            if let error = error {
//                                // Handle the error here.
//                                print( "UNUserNotificationCenter requestAuthorization.error \(error)")
//                            }
//                            // TODO: Enable or disable features based on the authorization.
//                        }
//                    }) {
//                        HStack {
//                            Text("Enable Notifications")
//                                .font(.system(size: 27, weight: .medium, design: .rounded))
//                                .foregroundColor(Color(.systemBackground))
//                                .padding()
//                        }
//                        .frame(height: 50)
//                        .background(Color(.label))
//                        .cornerRadius(25)
//                    }
//                }
            }
            
            Text("version \(AppModel().appShortVersion)(\(AppModel().appBuildVersion))")
                .font(.caption)
        }.onAppear(perform: {
            self.familyKitAppState.onRefresh()
        })
        .navigationBarTitle("\(familyKitAppState.currentPlayer.name)")
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AdultUserView()
                //.environment(\.window, window)
                .environmentObject(AppState())
                .environmentObject(FamilyKitAppState(container: CKContainer(identifier: CKContainerIdentifier)))
                .previewDevice(PreviewDevice(rawValue: "iPad Air 2"))
            
            AdultUserView()
                //.environment(\.window, window)
                .environmentObject(AppState())
                .environmentObject(FamilyKitAppState(container: CKContainer(identifier: CKContainerIdentifier)))
            .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
            .previewDisplayName("iPhone SE")
            AdultUserView()
                //.environment(\.window, window)
                .environmentObject(AppState())
                .environmentObject(FamilyKitAppState(container: CKContainer(identifier: CKContainerIdentifier)))
            .previewDevice(PreviewDevice(rawValue: "iPhone XS Max"))
            .previewDisplayName("iPhone XS Max")

        }
    }
}
