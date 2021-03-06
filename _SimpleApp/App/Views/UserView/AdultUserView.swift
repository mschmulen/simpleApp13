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
    
    @EnvironmentObject var activityDescriptionService: CKPrivateModelService<CKActivityDescriptionModel>
    @EnvironmentObject var activityService: CKPrivateModelService<CKActivityModel>
    
    @State var devMessage: String?
    
    var body: some View {
        List{
            DevMessageView(devMessage: $devMessage)
            
            HStack {
                Text("\(familyKitAppState.currentPlayerModel?.emoji ?? "🌞" )")
                Text("\(familyKitAppState.currentPlayerModel?.name ?? "none" )")
            }
            
            Text("Bucks: \(familyKitAppState.currentPlayerModel?.bucks ?? 0 )")
            
            NavigationLink(destination: PlayerSelectView()) {
                Text("Change Current Player")
                    .foregroundColor(.blue)
            }
            
            Section(header: Text("Family")) {
                NavigationLink(destination: PlayersListView()) {
                    Text("Show Family")
                        .foregroundColor(.blue)
                }
            }
            
            Section(header: Text("Dev Stuff")) {
                NavigationLink(destination: ShareView()) {
                    Text("ShareView")
                        .foregroundColor(.blue)
                }
                
                NavigationLink(destination: AgentConfigurationView(agentConfig: familyKitAppState.agentService)) {
                    Text("Agent Configuration")
                        .foregroundColor(.blue)
                }
                
                NavigationLink(destination: PublicActivityDescriptionView()) {
                    Text("PublicActivityDescriptionView")
                        .foregroundColor(.blue)
                }

                NavigationLink(destination: MultipleChoiceView(viewModel:MultipleChoiceViewModel.mock)) {
                    Text("MultipleChoiceView")
                        .foregroundColor(.blue)
                }
                
                Button(action: {
                    self.appState.topView = TopView.onboardingView
                }) {
                    Text("SHOW ONBOARDING")
                        .foregroundColor(.blue)
                }
                
                Button(action: {
                    self.appState.topView = TopView.purchaseView
                }) {
                    Text("SHOW PURCHASE VIEW")
                        .foregroundColor(.blue)
                }
                
                NavigationLink(destination: PurchaseView()) {
                    Text("PurchaseView detail")
                        .foregroundColor(.blue)
                }
                
            }//end Section
            
            Section(header: Text("Dev Stuff")) {
                
                NavigationLink(destination: CKActivityDescriptionListView()) {
                    Text("Show Activity Descriptions")
                        .foregroundColor(.blue)
                }
                
                NavigationLink(destination: CKActivityActiveListView()) {
                    Text("Show Active Activities")
                        .foregroundColor(.blue)
                }
                
                NavigationLink(destination: CKUserView()) {
                    Text("CKUserView")
                        .foregroundColor(.blue)
                }
                
                NavigationLink(destination: NotificationDevView()) {
                    Text("NotificationDevView")
                        .foregroundColor(.blue)
                }
                
                if self.familyKitAppState.userService.ckAccountStatus == .available {
                    Text("CloudKit is available")
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
                
                Button(action: {
                    self.familyKitAppState.resetAllFamilyBucks()
                }) {
                    Text("Reset All FamilyBucks")
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
        }
        .onAppear(perform: {
            self.familyKitAppState.onRefetchFromServer()
        })
            .navigationBarTitle("\(familyKitAppState.currentPlayerModel?.name ?? "none")")
    }
    
}





//struct AdultUserView_Previews: PreviewProvider {
//    
//    static let ckContainer = CKContainer(identifier: CKContainerIdentifier)
//    static var previews: some View {
//        Group {
//            
//            AdultUserView()
//                //.environment(\.window, window)
//                .environmentObject(AppState(container: CloudKitContainer.MockContainer(cKContainer)))
//                .environmentObject(FamilyKitAppState(container: CloudKitContainer.MockContainer(ckContainer)))
//                .previewDevice(PreviewDevice(rawValue: "iPad Air 2"))
//            
//            
//            AdultUserView()
//                //.environment(\.window, window)
//                .environmentObject(AppState(container: CloudKitContainer.MockContainer(cKContainer)))
//                .environmentObject(FamilyKitAppState(container: CloudKitContainer.MockContainer(ckContainer)))
//            .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
//            .previewDisplayName("iPhone SE")
//            
//            
//            AdultUserView()
//                //.environment(\.window, window)
//                .environmentObject(AppState(container: CloudKitContainer.MockContainer(cKContainer)))
//                .environmentObject(FamilyKitAppState(container: CloudKitContainer.MockContainer(ckContainer)))
//            .previewDevice(PreviewDevice(rawValue: "iPhone XS Max"))
//            .previewDisplayName("iPhone XS Max")
//
//        }
//    }
//}
