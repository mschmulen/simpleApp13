//
//  CKUserView.swift
//  FamilyKitDemo
//
//  Created by Matthew Schmulen on 7/29/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit

struct CKUserView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var familyKitState: FamilyKitState
    
    @State var devMessage: String?
    
    var body: some View {
        NavigationView {
            List{
                if devMessage != nil {
                    Text("\(devMessage!)")
                        .foregroundColor(.red)
                        .onTapGesture {
                            self.devMessage = nil
                    }
                }
                
                Section(header: Text("Kid Information")) {
                    
                    NavigationLink(destination: CKKidDetailView(model: CKKidModel())) {
                        Text("NEW KID" )
                    }
                    
                    ForEach( self.familyKitState.kidService.allModels) { model in
                        NavigationLink(destination: CKKidDetailView(model: model)) {
                            Text(model.name ?? "~" )
                        }
                        // .deleteDisabled(!self.appState.canEdit)
                    }//end ForEach
                }
                
//                Section(header: Text("Authentiation")) {
//                    if self.appState.userService.isUserAuthenticated {
//                        Button(action: {
//                            self.appState.signOutUser()
//                        }) {
//                            Text("SignOut")
//                                .foregroundColor(.blue)
//                        }
//                    }
//
//                    if self.appState.userService.isUserAuthenticated == false {
//                        Button(action: {
//                            self.appState.topView = .authenticationView
//                        }) {
//                            Text("SignIn")
//                                .foregroundColor(.blue)
//                        }
//                    }
//                }
                
                Section(header: Text("Dev Stuff")) {
                    // Dev stuff
                    if self.familyKitState.userService.ckAccountStatus == .available {
                        Text("CloudKit is available")
//                        if self.appState.userService.currentUser != nil {
//                            Text("\(self.appState.userService.currentUser?.recordID?.recordName ?? "~")")
//                        }
                        VStack {
                            Text("appleIDCredentialIdentifier:")
                            Text("\(self.familyKitState.userService.localUserDefaults_appleIDCredentialIdentifier ?? "")")
                        }
                        
                    } else {
                        VStack {
                            Text("CloudKit is NOT available")
                            Text("\(self.familyKitState.userService.ckAccountStatus.friendlyString)")
                        }
                    }
                    
                    if familyKitState.isSimulator == false {
                        // Notifications
                        Button(action: {
                            print("Enable Notifications")
                            let center = UNUserNotificationCenter.current()
                            center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                                if let error = error {
                                    // Handle the error here.
                                    print( "error \(error)")
                                }
                                // TODO: Enable or disable features based on the authorization.
                            }
                        }) {
                            HStack {
                                Text("Enable Notifications")
                                    .font(.system(size: 27, weight: .medium, design: .rounded))
                                    .foregroundColor(Color(.systemBackground))
                                    .padding()
                            }
                            .frame(height: 50)
                            .background(Color(.label))
                            .cornerRadius(25)
                        }
                    }
                }
                
                if self.familyKitState.userService.isUserAuthenticated {
                    Section(header: Text("user info")) {
                        
                        Text("familyName: \(self.familyKitState.userService.currentUser?.appleIDProvider_credential_user_familyName ?? "~")")
                        Text("givenName: \(self.familyKitState.userService.currentUser?.appleIDProvider_credential_user_givenName ?? "~")")
                        Text("email: \(self.familyKitState.userService.currentUser?.appleIDProvider_credential_user_email ?? "~")")
                        
                        Text("localeLanguageCode \(self.familyKitState.userService.currentUser?.localeCurrentLanguageCode ?? "~")")
                        Text("localeRegionCode \(self.familyKitState.userService.currentUser?.localeCurrentRegionCode ?? "~")")
                        Text("emoji: \(self.familyKitState.userService.currentUser?.emoji ?? "~")")
                        // optionalText(title: "birthDate",text: self.appState.userService.currentUser?.birthDate)
                        
                    }
                }
                
//                Section(header: Text("Purchase Information")) {
//
//                    if appState.currentPurchaseModel != nil {
//                        Text("purchaseStatus: \(appState.currentPurchaseModel!.status.friendlyName)")
//                        Text("id: \(appState.currentPurchaseModel!.id.uuidString)")
//                    } else {
//                        Button(action: {
//                            self.appState.topView = .purchaseView
//                        }) {
//                            Text("Show Purchase View ")
//                                .foregroundColor(.blue)
//                        }
//                    }
//                }
                
//                Section(header: Text("Device Information")) {
//                    Text("idfv: \(appState.currentDeviceInfo.idfv?.uuidString ?? "~")")
//                    Text("localeLanguageCode: \(appState.currentDeviceInfo.localeLanguageCode ?? "~")")
//                    Text("localeRegionCode: \(appState.currentDeviceInfo.localeRegionCode ?? "~")")
//                }
//                
//                Section(header: Text("App Information")) {
//                    Text("appID: \(appState.currentAppInfo.appID)")
//                    Text("appBuildVersin: \(appState.currentAppInfo.appBuildVersin)")
//                    Text("appShortVersion: \(appState.currentAppInfo.appShortVersion)")
//                }
            }
            .navigationBarTitle("CKUser")
        }
    }
}

