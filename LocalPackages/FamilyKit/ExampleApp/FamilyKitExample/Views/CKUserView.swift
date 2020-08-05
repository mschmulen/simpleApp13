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
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var choreService: CKPublicModelService<CKChoreModel>
    @EnvironmentObject var connectService: CKPublicModelService<CKConnectModel>
    @EnvironmentObject var funService: CKPublicModelService<CKFunModel>
    
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
                
                Section(header: Text("Current Player")) {
                    Text("current Player \(familyKitAppState.currentPlayer.name)")
                    
//                    if familyKitAppState.currentPlayer != nil {
//                        NavigationLink(destination: CKKidDetailView(model: familyKitAppState.currentPlayer!)) {
//                            Text("current Player \(familyKitAppState.currentPlayer!.name ?? "~")")
//                        }
//                    }
                    
                    NavigationLink(destination: PlayerOnboardingView()) {
                        Text("Change Current Player")
                    }
//                    Button(action: {
//                        print( "yack")
//                    }) {
//                        Text("Change Player")
//                    }
                }
                
                Section(header: Text("Kids: \(self.familyKitAppState.kidService.models.count)")) {
                    NavigationLink(destination: CKKidDetailView(model: CKKidModel())) {
                        Text("NEW KID" )
                    }
                    
                    //ForEach( kidService.models) { model in
                    ForEach( self.familyKitAppState.kidService.models ) { model in
                        NavigationLink(destination: CKKidDetailView(model: model)) {
                            Text(model.name ?? "~" )
                        }
                    }//end ForEach
                    .onDelete(perform: delete)
                }//end section kids
                
                Section(header: Text("Adults: \(self.familyKitAppState.adultService.models.count)")) {
                    NavigationLink(destination: CKAdultDetailView(model: CKAdultModel())) {
                        Text("NEW Adult" )
                    }
                    
                    //ForEach( kidService.models) { model in
                    ForEach( self.familyKitAppState.adultService.models ) { model in
                        NavigationLink(destination: CKAdultDetailView(model: model)) {
                            Text(model.name ?? "~" )
                        }
                    }//end ForEach
                    .onDelete(perform: delete)
                }//end section adults
                
                Section(header: Text("Dev Stuff")) {
                    // Dev stuff
                    if self.familyKitAppState.userService.ckAccountStatus == .available {
                        Text("CloudKit is available")
//                        if self.appState.userService.currentUser != nil {
//                            Text("\(self.appState.userService.currentUser?.recordID?.recordName ?? "~")")
//                        }
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
                    
                    if familyKitAppState.isSimulator == false {
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
                
                if self.familyKitAppState.userService.isUserAuthenticated {
                    Section(header: Text("user info")) {
                        Text("localeLanguageCode \(self.familyKitAppState.userService.currentUser?.localeCurrentLanguageCode ?? "~")")
                        Text("localeRegionCode \(self.familyKitAppState.userService.currentUser?.localeCurrentRegionCode ?? "~")")
                        Text("emoji: \(self.familyKitAppState.userService.currentUser?.emoji ?? "~")")
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
                self.familyKitAppState.kidService.fetch { (result) in
                    print("result")
                    self.familyKitAppState.onUpdate()
                }
            })
                .navigationBarItems(trailing: trailingButton)
                .navigationBarTitle("CKUser")
        }
    }
    
    func delete(at offsets: IndexSet) {
        for deleteIndex in offsets {
            let deleteModel = self.familyKitAppState.kidService.models[deleteIndex]
            self.familyKitAppState.kidService.pushDelete(model: deleteModel) { (result) in
                switch result {
                case .failure(let error):
                    print("delete.error \(error)")
                case .success(let recordID):
                    print("delete.success \(recordID)")
                }
            }
        }
    }
    
    private var trailingButton: some View {
        HStack {
            Text("\(familyKitAppState.currentPlayer.emoji) \(familyKitAppState.currentPlayer.name)")
            Button(action:onTrailing) { Image(systemName: "person.circle.fill") }
        }
    }
    
    //
    //        private var leadingButton: some View {
    //            NavigationLink(destination: CKChoreDetailView(model: CKChoreModel(), containerConfig: .privateCloudDatabase)) {
    //                Image(systemName: "plus")
    //            }
    //            // Button(action:onAdd) { Image(systemName: "plus") }
    //        }
    
    //        func onAdd() {
    //            self.publicChoreService.pushNewPublic(model: CKChoreModel.mock) { (result) in
    //                print("\(result)")
    //            }
    //        }
    
    func onTrailing() {
        print( "onTrailing")
    }
    
}
