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
    @Environment(\.presentationMode) var presentationMode
    
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
                    
                    if appState.currentUserModel == nil {
                        Button(action: {
                            self.appState.topView = .authenticationView
                        }) {
                            Text("Sign In")
                                .foregroundColor(.blue)
                        }
                    }
                    else {
                        Text("email: \(appState.currentUserModel?.email ?? "~")")
                        
                        Button(action: {
                            self.appState.signOut()
                        }) {
                            Text("Sign Out")
                                .foregroundColor(.blue)
                        }
                    }
                }
                
                Section(header: Text("Purchase Information")) {
                    
                    Button(action: {
                        self.appState.topView = .purchaseView
                    }) {
                        Text("Show Purchase View ")
                            .foregroundColor(.blue)
                    }
                    
                    Text("purchaseStatus: \(appState.currentPurchaseModel?.status.friendlyName ?? "~")")
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
            }
            .navigationBarTitle("User")
        }
    }
}
