//
//  ContentView.swift
//  QFamilyApp14
//
//  Created by Matthew Schmulen on 10/2/20.
//

import SwiftUI
import FamilyKit

enum TopView {
    case mainView
    case onboardingView
    case purchaseView
    case modalView
}

enum TabViewIndex: Int {
    case you = 0
    case family = 1
    case rewards = 2
    case familyChat = 3
}

struct ContentView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var activityDescriptionService: CKPrivateModelService<CKActivityDescriptionModel>
    @EnvironmentObject var activityService: CKPrivateModelService<CKActivityModel>
    @EnvironmentObject var chatService: ChatService
    
    @EnvironmentObject var storeItemDefinitionService: CKPrivateModelService<CKBuckRewardDefinitionModel>
    @EnvironmentObject var storeItemPurchaseService: CKPrivateModelService<CKBuckRewardModel>
    
    @State var devMessage: String?
    @State var showNoiCloudConnection = false
    
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

            // top level app state
            if appState.topView == .onboardingView {
                OnboardingView()
                    .environment(\.window, window)
                    .environmentObject(appState)
                    .environmentObject(familyKitAppState)
                    .environmentObject(activityDescriptionService)
                    .environmentObject(activityService)
            }//end if .onboardingView
            else if appState.topView == .purchaseView {
                PurchaseView()
                    .environmentObject(appState)
            }//end if .purchaseView
            else if appState.topView == .modalView {
                ModalView()
                    .environment(\.window, window)
                    .environmentObject(appState)
                    .environmentObject(familyKitAppState)
                    .environmentObject(activityDescriptionService)
                    .environmentObject(activityService)
            }//end .modalView
            else if appState.topView == .mainView {

                if familyKitAppState.currentPlayerModel == nil {
                    VStack {
                        PlayerSelectView()
                            .environmentObject(familyKitAppState)
                        Text("version \(AppModel().appShortVersion)(\(AppModel().appBuildVersion))")
                            .font(.caption)
                    }
                } else {
                    // we have a valid player
                    TabView(selection: $appState.selectedTab) {
                        MainYouView()
                            .environment(\.window, window)
                            .environmentObject(appState)
                            .environmentObject(familyKitAppState)
                            .environmentObject(activityDescriptionService)
                            .environmentObject(activityService)
                            .tabItem {
                                Image(systemName: "person.circle")
                                Text("\(familyKitAppState.currentPlayerModel?.name ?? "none")")
                        }.tag(TabViewIndex.you.rawValue)

                        MainFamilyView()
                            .environment(\.window, window)
                            .environmentObject(appState)
                            .environmentObject(familyKitAppState)
                            .environmentObject(activityDescriptionService)
                            .environmentObject(activityService)
                            .tabItem {
                                Image(systemName: "house")
                                Text("Family")
                        }.tag(TabViewIndex.family.rawValue)

                        MainRewardsView()
                            .environment(\.window, window)
                            .environmentObject(appState)
                            .environmentObject(familyKitAppState)
                            .environmentObject(activityDescriptionService)
                            .environmentObject(activityService)
                            .environmentObject(storeItemDefinitionService)
                            .environmentObject(storeItemPurchaseService)
                            .tabItem {
                                Image(systemName: "dollarsign.circle")
                                // .font(.system(size: 28, weight: .light))
                                Text("Rewards")
                        }.tag(TabViewIndex.rewards.rawValue)

                        FamilyChatView()
                            .environment(\.window, window)
                            .environmentObject(appState)
                            .environmentObject(familyKitAppState)
                            .environmentObject(activityDescriptionService)
                            .environmentObject(activityService)
                            .tabItem {
                                Image(systemName: "person.3")
                                Text("Chat")
                        }.tag(TabViewIndex.familyChat.rawValue)
                    } //end TabView

                } // end else .currentPlayerModel == nil
            }//end .mainView
            //EmptyView()
        }//end group
            .sheet(isPresented: $showNoiCloudConnection) {
                iCloudSheetView(showSheetView: self.$showNoiCloudConnection)
        }
        .onAppear {
            if self.familyKitAppState.isCloudKitAvailable == false {
                self.showNoiCloudConnection.toggle()
            }
            print( "ContentView.onAppear")
        }
        .onReceive(NotificationCenter.default.publisher(for: FamilyKitNotifications.CKRemoteModelChangedNotification)) { _ in
            print("Notification.Name(CloudKitModelService) recieved")
            //self.devMessage = "silent Push! DB changed"
        }
    }//end body
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


// TODO: move to own file
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
