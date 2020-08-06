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

struct UserView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var privateChoreService: CKPrivateModelService<CKChoreDescriptionModel>
    @EnvironmentObject var privateActiveChoreService: CKPrivateModelService<CKChoreActiveModel>
    
    @EnvironmentObject var connectService: CKPublicModelService<CKConnectModel>
    @EnvironmentObject var funService: CKPublicModelService<CKFunModel>
    
    @State var devMessage: String?
    
    @State var chatService = ChatService()
    
    var body: some View {
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
                
                NavigationLink(destination: PlayerOnboardingView()) {
                    Text("Change Current Player")
                }
                
//                NavigationLink(destination: CKKidDetailView(model: familyKitAppState.currentPlayer!)) {
//                    Text("current Player \(familyKitAppState.currentPlayer!.name ?? "~")")
//                }
            }
            
            Section(header: Text("Kids: \(self.familyKitAppState.kidService.models.count)")) {
                NavigationLink(destination: KidDetailView(model: CKKidModel())) {
                    Text("Add a new Kid to this account")
                        .foregroundColor(.blue)
                }
                
                ForEach( self.familyKitAppState.kidService.models ) { model in
                    NavigationLink(destination: KidDetailView(model: model)) {
                        Text(model.name ?? "~" )
                    }
                }//end ForEach
                    .onDelete(perform: delete)
            }//end section kids
            
            Section(header: Text("Adults: \(self.familyKitAppState.adultService.models.count)")) {
                NavigationLink(destination: AdultDetailView(model: CKAdultModel())) {
                    Text("Add a new Adult to this account")
                        .foregroundColor(.blue)
                }
                
                ForEach( self.familyKitAppState.adultService.models ) { model in
                    NavigationLink(destination: AdultDetailView(model: model)) {
                        Text(model.name ?? "~" )
                    }
                }//end ForEach
                    .onDelete(perform: delete)
            }//end section adults
            
            Section(header: Text("Dev Stuff")) {
                NavigationLink(destination: CKChoreListView()) {
                    Text("Show Chores")
                        .foregroundColor(.blue)
                }
                
                NavigationLink(destination: ChatsView(chatService: $chatService)) {
                    Text("Show Chats View")
                        .foregroundColor(.blue)
                }
                
                NavigationLink(destination: AudioRecordView(audioRecorder: AudioRecorder())) {
                    Text("Show AudioRecordView")
                        .foregroundColor(.blue)
                }
                
                NavigationLink(destination: DrawView()) {
                    Text("Show SimpleDrawingView")
                        .foregroundColor(.blue)
                }
                
                NavigationLink(destination: SimpleGameView()) {
                    Text("Show SimpleGameView")
                        .foregroundColor(.blue)
                }
                
                
            }
            
            Section(header: Text("Dev Stuff")) {
                
                NavigationLink(destination: PurchaseView()) {
                    Text("PurchaseView")
                        .foregroundColor(.blue)
                }
                
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
                Section(header: Text("CKUser")) {
                    
                    Text("name \(self.familyKitAppState.userService.currentUser?.name ?? "~")")
                    Text("emoji: \(self.familyKitAppState.userService.currentUser?.emoji ?? "~")")
                    Text("birthDate: \(self.familyKitAppState.userService.currentUser?.birthDate?.description ?? "~")")
                    
                    Text("localeLanguageCode \(self.familyKitAppState.userService.currentUser?.localeCurrentLanguageCode ?? "~")")
                    Text("localeRegionCode \(self.familyKitAppState.userService.currentUser?.localeCurrentRegionCode ?? "~")")
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
        //.navigationBarItems(trailing: trailingButton)
        //                    .navigationBarTitle("CKUser")
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
}


struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            UserView()
                //.environment(\.window, window)
                .environmentObject(AppState())
                .environmentObject(FamilyKitAppState(container: CKContainer(identifier: CKContainerIdentifier)))
                .previewDevice(PreviewDevice(rawValue: "iPad Air 2"))
            
            UserView()
                //.environment(\.window, window)
                .environmentObject(AppState())
                .environmentObject(FamilyKitAppState(container: CKContainer(identifier: CKContainerIdentifier)))
            .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
            .previewDisplayName("iPhone SE")
            UserView()
                //.environment(\.window, window)
                .environmentObject(AppState())
                .environmentObject(FamilyKitAppState(container: CKContainer(identifier: CKContainerIdentifier)))
            .previewDevice(PreviewDevice(rawValue: "iPhone XS Max"))
            .previewDisplayName("iPhone XS Max")

        }
    }
}
