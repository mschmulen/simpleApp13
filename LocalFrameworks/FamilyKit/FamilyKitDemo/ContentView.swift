//
//  ContentView.swift
//  FamilyKitDemo
//
//  Created by Matthew Schmulen on 7/29/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit

struct ContentView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var familyKitState: FamilyKitState
    
    @EnvironmentObject var choreService: CKPublicModelService<CKChoreModel>
    @EnvironmentObject var connectService: CKPublicModelService<CKConnectModel>
    @EnvironmentObject var funService: CKPublicModelService<CKFunModel>
    
    //@EnvironmentObject var kidService: CKPrivateModelService<CKKidModel>
    
    @State private var selectedTab: Int = 0
    
    @State var devMessage: String?
    
    var body: some View {
        Group {
            if devMessage != nil {
                Text("\(devMessage!)")
                    .foregroundColor(.red)
                    .onTapGesture {
                        self.devMessage = nil
                }
            }
            
            if familyKitState.currentPlayer.isNone {
                PlayerPickerView()
                    .environmentObject(familyKitState)
            } else {
                TabView(selection: $selectedTab) {
                    
                    CKUserView()
                        .environmentObject(familyKitState)
                        .environmentObject(choreService)
                        .environmentObject(funService)
                        .environmentObject(connectService)
                        .tabItem {
                            Image(systemName:"wind")
                            Text("CKUser")
                    }.tag(0)
                    
                    CKChoreView()
                        .environmentObject(familyKitState)
                        .environmentObject(choreService)
                        .environmentObject(funService)
                        .environmentObject(connectService)
                        .tabItem {
                            Image(systemName:"wind")
                            Text("CKChore")
                    }.tag(1)
                    
                    CKFunView()
                        .environmentObject(familyKitState)
                        .environmentObject(choreService)
                        .environmentObject(funService)
                        .environmentObject(connectService)
                        .tabItem {
                            Image(systemName:"wind")
                            Text("CKFunView")
                    }.tag(2)
                    
                    CKConnectView()
                        .environmentObject(familyKitState)
                        .environmentObject(choreService)
                        .environmentObject(funService)
                        .environmentObject(connectService)
                        .tabItem {
                            Image(systemName:"wind")
                            Text("CKConnectView")
                    }.tag(3)
                }//end TabView
            }
        }//end group
        .onAppear {
            //if self.familyKitState.isSimulator {
            self.devMessage = " isCloudKitAvailable:\(self.familyKitState.isCloudKitAvailable)"
            //}
        }
        .onReceive(NotificationCenter.default.publisher(for: CKChangedNotification)) { _ in
            print("Notification.Name(CloudKitModelService) recieved")
            self.devMessage = "silent Push! DB changed"
        }
    }//end body
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
