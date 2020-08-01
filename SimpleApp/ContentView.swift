//
//  ContentView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 7/19/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit

struct ContentView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var choreService: CKPublicModelService<CKChoreModel>
    @EnvironmentObject var connectService: CKPublicModelService<CKConnectModel>
    @EnvironmentObject var funService: CKPublicModelService<CKFunModel>
    
    @State var devMessage: String?
    @State var showNoiCloudConnection = false
    @State var showNoCurrentPlayer = false
    @State var networkStateViewModel:NetworkStateViewModel = NetworkStateViewModel()
    
    enum TopView {
        case mainView
        case pickPlayerView
        case purchaseView
    }
    
    @ViewBuilder
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
            
            Text("current player: \(familyKitAppState.currentPlayer.name)")
                .foregroundColor(.red)
            
            if familyKitAppState.currentPlayer.isNone {
                PlayerPickerView()
                    .environmentObject(familyKitAppState)
            } else {
                
                //if appState.topView == .mainView {
                    MainView()
                        .environment(\.window, window)
                        .environmentObject(appState)
                        .environmentObject(familyKitAppState)
                        .environmentObject(choreService)
                        .environmentObject(funService)
                        .environmentObject(connectService)
                
//                }
                
                // TODO: Clean up
//                if appState.topView == .pickPlayerView {
//                    PickPlayerView()
//                        .environmentObject(appState)
//                }
//
//                if appState.topView == .purchaseView {
//                    PurchaseView()
//                        .environmentObject(appState)
//                }
                // EmptyView()
            }
        }//end group
        .sheet(isPresented: $showNoiCloudConnection) {
                iCloudSheetView(showSheetView: self.$showNoiCloudConnection)
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

struct iCloudSheetView: View {
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

