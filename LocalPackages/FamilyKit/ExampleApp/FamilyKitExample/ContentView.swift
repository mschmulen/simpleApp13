//
//  ContentView.swift
//  FamilyKitExample
//
//  Created by Matthew Schmulen on 7/31/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit

struct ContentView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var choreService: CKPublicModelService<CKChoreModel>
    @EnvironmentObject var connectService: CKPublicModelService<CKConnectModel>
    @EnvironmentObject var funService: CKPublicModelService<CKFunModel>
    
    @State private var selectedTab: Int = 0
    
    @State var devMessage: String?
    
    @State var showNoiCloudConnection = false
    @State var showNoCurrentPlayer = false
    
    @State var networkStateViewModel:NetworkStateViewModel = NetworkStateViewModel()
    
    var body: some View {
        Group {
            if devMessage != nil {
                Text("\(devMessage!)")
                    .foregroundColor(.red)
                    .onTapGesture {
                        self.devMessage = nil
                }
            }
            
            if networkStateViewModel.pathStatus != .satisfied {
                Text("network state: \(networkStateViewModel.pathStatus.friendlyString) \(networkStateViewModel.isExpensive ? "true" : "false")")
                    .foregroundColor(.red)
            }
            
            if familyKitAppState.currentPlayer.isNone {
                PlayerOnboardingView()
                    .environmentObject(familyKitAppState)
            } else {
                TabView(selection: $selectedTab) {
                    
                    CKUserView()
                        .environmentObject(familyKitAppState)
                        .environmentObject(choreService)
                        .environmentObject(funService)
                        .environmentObject(connectService)
                        .tabItem {
                            Image(systemName:"wind")
                            Text("CKUser")
                    }.tag(0)
                    
                    CKChoreView()
                        .environmentObject(familyKitAppState)
                        .environmentObject(choreService)
                        .environmentObject(funService)
                        .environmentObject(connectService)
                        .tabItem {
                            Image(systemName:"wind")
                            Text("CKChore")
                    }.tag(1)
                    
//                    CKFunView()
//                        .environmentObject(familyKitAppState)
//                        .environmentObject(choreService)
//                        .environmentObject(funService)
//                        .environmentObject(connectService)
//                        .tabItem {
//                            Image(systemName:"wind")
//                            Text("CKFunView")
//                    }.tag(2)
                    
                    CKConnectView()
                        .environmentObject(familyKitAppState)
                        .environmentObject(choreService)
                        .environmentObject(funService)
                        .environmentObject(connectService)
                        .tabItem {
                            Image(systemName:"wind")
                            Text("CKConnectView")
                    }.tag(3)
                    
                    ChatView()
//                        .environmentObject(familyKitAppState)
//                        .environmentObject(choreService)
//                        .environmentObject(funService)
//                        .environmentObject(connectService)
                        .tabItem {
                            Image(systemName:"message")
                            Text("Chat")
                    }.tag(4)
                    
                    DrawView()
                        //                        .environmentObject(familyKitAppState)
                        //                        .environmentObject(choreService)
                        //                        .environmentObject(funService)
                        //                        .environmentObject(connectService)
                        .tabItem {
                            Image(systemName:"paintbrush")
                            Text("Draw")
                    }.tag(5)
                    
                }//end TabView
            }
        }//end group
            .sheet(isPresented: $showNoiCloudConnection) {
                SheetView(showSheetView: self.$showNoiCloudConnection)
        }
        .onAppear {
            
            // get the state of cloudKit and the network too
            
            if self.familyKitAppState.isCloudKitAvailable == false {
                self.showNoiCloudConnection.toggle()
            }
            //if self.familyKitAppState.isSimulator {
            //self.devMessage = " isCloudKitAvailable:\(self.familyKitAppState.isCloudKitAvailable)"
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

struct SheetView: View {
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var showSheetView: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                
                Text("Please login to your iCloud account")
                
                Button(action: {
                    guard let generalSettingsURL = URL(string:"App-Prefs:root=General") else {
                        return
                    }
                    
                    guard let appSettingsURL = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    
                    if UIApplication.shared.canOpenURL(appSettingsURL) {
                        UIApplication.shared.open(generalSettingsURL, completionHandler: { (success) in
                            print("Settings opened: \(success)") // Prints true
                        })
                    }
                }) {
                    VStack {
                        Text("Open Settings")
                        Text("and log in to your iCloud account")
                    }
                }
            }
            .navigationBarTitle(Text("iCloud"), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                print("Dismissing sheet view...")
                self.showSheetView = false
            }) {
                Text("Done").bold()
            })
        }
    }
}
