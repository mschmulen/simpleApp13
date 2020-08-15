//
//  ContentView.swift
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
    
    @EnvironmentObject var privateChoreService: CKPrivateModelService<CKActivityDescriptionModel>
    @EnvironmentObject var privateActiveChoreService: CKPrivateModelService<CKActivityModel>
    @EnvironmentObject var chatService: ChatService
    
    @State var devMessage: String?
    @State var showNoiCloudConnection = false
    
    enum TopView {
        case mainView
        case purchaseView
    }
    
    @State private var selectedTab: Int = TabViewIndex.family.rawValue
    
    public enum TabViewIndex: Int {
        case you = 0
        case family = 1
        case bucksStore = 2
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
            
            if familyKitAppState.currentPlayer.isNone {
                PlayerOnboardingView()
                    .environmentObject(familyKitAppState)
            } else {
                TabView(selection: $selectedTab) {
                    if appState.topView == .mainView {
                        if familyKitAppState.currentPlayer.isAdult {
                            AdultYouView()
                                .environment(\.window, window)
                                .environmentObject(appState)
                                .environmentObject(familyKitAppState)
                                .environmentObject(privateChoreService)
                                .environmentObject(privateActiveChoreService)
                                .environmentObject(chatService)
                                .tabItem {
                                    Image(systemName: "person.circle")
                                    Text("You")
                            }.tag(TabViewIndex.you.rawValue)
                        } else {
                            KidYouView()
                                .environment(\.window, window)
                                .environmentObject(appState)
                                .environmentObject(familyKitAppState)
                                .environmentObject(privateChoreService)
                                .environmentObject(privateActiveChoreService)
                                .environmentObject(chatService)
                                .tabItem {
                                    Image(systemName: "person.circle")
                                    Text("\(familyKitAppState.currentPlayer.name)")
                            }.tag(TabViewIndex.you.rawValue)
                        }//end first tab
                        
                        MainFamilyView()
                            .environment(\.window, window)
                            .environmentObject(appState)
                            .environmentObject(familyKitAppState)
                            .environmentObject(privateChoreService)
                            .environmentObject(privateActiveChoreService)
                            .environmentObject(chatService)
                            .tabItem {
                                Image(systemName: "house")
                                Text("Family")
                        }.tag(TabViewIndex.family.rawValue)
                        
                        MainBucksStoreView()
                            .environment(\.window, window)
                            .environmentObject(appState)
                            .environmentObject(familyKitAppState)
                            .environmentObject(privateChoreService)
                            .environmentObject(privateActiveChoreService)
                            .environmentObject(chatService)
                            .tabItem {
                                Image(systemName: "dollarsign.circle")
                                // .font(.system(size: 28, weight: .light))
                                Text("Bucks")
                        }.tag(TabViewIndex.bucksStore.rawValue)
                    }
                }
                
                if appState.topView == .purchaseView {
                    PurchaseView()
                        .environmentObject(appState)
                }
                // EmptyView()
            }
        }//end group
            .sheet(isPresented: $showNoiCloudConnection) {
                iCloudSheetView(showSheetView: self.$showNoiCloudConnection)
        }
        .onAppear {
            if self.familyKitAppState.isCloudKitAvailable == false {
                self.showNoiCloudConnection.toggle()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: FamilyKitNotifications.CKRemoteModelChangedNotification)) { _ in
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

