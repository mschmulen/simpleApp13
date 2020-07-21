//
//  UserView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 7/19/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct UserView: View {
    
    @Environment(\.window) var window: UIWindow?
    
    @EnvironmentObject var appState: AppState
    
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
                
                Section(header: Text("User Information")) {
                    Text("email: \(appState.currentUserModel?.email ?? "~")")
                    Text("id: \(appState.currentUserModel?.id.uuidString ?? "~")")
                }
                
                Section(header: Text("Actions")) {
                    
                    if appState.currentUserModel == nil {
                        
                        Button(action: {
                            self.appState.signIn(email: "matt@matt.com", password: "password")
                        }) {
                            Text("SignIn")
                        }
                        
                        Button(action: {
                            self.appState.register(email: "matt@matt.com", password: "password")
                        }) {
                            Text("Register")
                        }
                    }
                    else {
                        Button(action: {
                            self.appState.signOut()
                        }) {
                            Text("SignOut")
                        }
                    }
                }
                
                Section(header: Text("Purchase Information")) {
                    Text("purchaseStatus: \(appState.currentPurchaseModel?.purchaseStatus.friendlyName ?? "~")")
                    Text("id: \(appState.currentPurchaseModel?.id.uuidString ?? "~")")
                }
                
                Section(header: Text("Device Information")) {
                    Text("idfv: \(appState.currentDeviceInfo.idfv?.uuidString ?? "~")")
                    Text("localeLanguageCode: \(appState.currentDeviceInfo.localeLanguageCode ?? "~")")
                    Text("localeRegionCode: \(appState.currentDeviceInfo.localeRegionCode ?? "~")")
                }
                    
                Section(header: Text("App Information")) {
                    Text("appID: \(appState.currentAppInfo.appID)")
                    Text("appBuildVersin: \(appState.currentAppInfo.appBuildVersin)")
                    Text("appShortVersion: \(appState.currentAppInfo.appShortVersion)")
                }
                
                
            }.onAppear {
                print("UserView.onAppear")
            }
            .navigationBarTitle("User")
        }
    }
}
