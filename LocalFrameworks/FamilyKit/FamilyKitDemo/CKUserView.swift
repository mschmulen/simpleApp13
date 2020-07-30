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
    
    @EnvironmentObject var choreService: CKModelService<CKChoreModel>
    @EnvironmentObject var connectService: CKModelService<CKConnectModel>
    @EnvironmentObject var funService: CKModelService<CKFunModel>
    @EnvironmentObject var kidService: CKModelService<CKKidModel>
    
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
                
                Section(header: Text("Kid Information: \(kidService.publicModels.count)")) {
                    NavigationLink(destination: CKKidDetailView(model: CKKidModel())) {
                        Text("NEW KID" )
                    }
                    
                    ForEach( kidService.publicModels) { model in
                        NavigationLink(destination: CKKidDetailView(model: model)) {
                            Text(model.name ?? "~" )
                        }
                    }//end ForEach
                }//end section kids
                
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
                                    print( "UNUserNotificationCenter requestAuthorization.error \(error)")
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
            }.onAppear(perform: {
                self.kidService.fetchPrivate { (result) in
                    print("result")
                    self.familyKitState.onUpdate()
                }
                self.kidService.fetchPublic { (result) in
                    print("result")
                    self.familyKitState.onUpdate()
                }
            })
            .navigationBarTitle("CKUser")
        }
    }
}

