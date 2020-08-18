//
//  CKChoreDescriptionDetailView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/2/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit
import SimpleGames
import CloudKit

struct CKActivityActiveDetailView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var privateActiveChoreService: CKPrivateModelService<CKActivityModel>
    @EnvironmentObject var chatService: ChatService
    
    @State var devMessage: String?
    
    @State var model: CKActivityModel
    @State var localActivityStatus: ActivityStatus = ActivityStatus.active
    
    @State var showChatSession: Bool = false
    
    var infoView: some View {
        VStack {
            Text("\(model.description ?? "~")")
                .font(.system(size: 20, weight: .medium, design: .rounded))
                .padding()
        }
    }
    
    var activityStatusView: some View {
        VStack {
            if familyKitAppState.currentPlayer.isAdult {
                Picker(selection: $localActivityStatus, label: Text("Status")) {
                    ForEach(ActivityStatus.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }.pickerStyle(SegmentedPickerStyle())
                    .padding()
                    .onReceive([localActivityStatus].publisher.first()) { value in
                        if value != self.model.status {
                            print( "save the change \(self.localActivityStatus.friendlyName)")
                            self.model.changeStatus(status: value)
                            //self.model.status = value
                            self.onSave()
                            
                            // give them points
                            if let playerReference = self.model.kidReference {
                                if value == .verified {
                                    if let player = self.familyKitAppState.findUserForRecord(recordReference: playerReference) {
                                        self.familyKitAppState.addBucks( player: player, bucks: self.model.bucks ?? 0)
                                    }
                                }
                            }
                            
                        }
                }
                
                
                //                Picker(selection: $model.status, label: Text("Status")) {
                //                    ForEach(ActivityStatus.allCases, id: \.self) {
                //                        Text($0.rawValue)
                //                    }
                //                }.pickerStyle(SegmentedPickerStyle())
                //                .onReceive([model.status].publisher.first()) { value in
                //                    print( "save the change \(self.model.status.friendlyName)")
                //                    // self.doSomethingWith(value: value)
                //                    self.onSave()
                //                }
            } else {
                //                if model.status == .active {
                //                    Button(action: onDone ) {
                //                        HStack {
                //                            Spacer()
                //                            Text("Done")
                //                                .foregroundColor(.blue)
                //                                .padding()
                //                        }
                //                        .foregroundColor(.blue)
                //                        .padding()
                //                    }
                //                }
            }
        }
    }
    
    var body: some View {
        //ScrollView(.vertical, showsIndicators: false) {
        VStack {
            //DevMessageView(devMessage: $devMessage)
            if model.moduleType == .photo {
                infoView
                activityStatusView
                PhotoActivityView(
                    model: $model
                )
            } else if model.moduleType == .audio {
                infoView
                activityStatusView
                ActivityAudioActionView(
                    model: $model
                )
            } else if model.moduleType == .chat {
                infoView
                activityStatusView
                
                // TODO: just show the abridged view then if the tap it show the full screen sheet
                ChatSessionView()
            } else if model.moduleType == .drawing {
                infoView
                activityStatusView
                
                // TODO: just show the image ... then if the tap it show a full screen sheet view of it
                DrawView(
                    model: $model
                )
            }
            else {
                infoView
                activityStatusView
            }
            Spacer()
            
            // Chat Session View
            VStack {
                GeometryReader { geo in
                    ZStack {
                        Rectangle()
                            .fill(Color.gray)
                            .frame(width: geo.size.width, height: geo.size.height)
                            .border(Color.gray)
                            .onTapGesture {
                                // TODO Show the full Chat
                                self.showChatSession.toggle()
                        }
                        Text("CHAT PEEK VIEW (TODO)")
                    }
                }
            }
            .frame(height: 100)
            .sheet(isPresented: $showChatSession) { // }, onDismiss: loadImage) {
                ChatSessionView()
                    .environmentObject(self.familyKitAppState)
                    .environmentObject(self.chatService)
            }
            
            
            // TODO: Show the specific chat session associated with this view
            
            
            //            if model.kidReference != nil {
            //                if model.kidReference == familyKitAppState.currentPlayer.recordReference {
            //                    ActivityActionView(model: $model)
            //                } else {
            //                    // TODO fetch the user information
            //                    Text("this is not your activity")
            //                    Text("\(familyKitAppState.findUserForRecord(recordReference: model.kidReference!)?.name ?? "~")")
            //                    ActivityActionView(model: $model)
            //                }
            //            }
            //            else {
            //                ActivityActionView(model: $model)
            //            }
        }//end VStack
            .navigationBarTitle("\(model.title ?? "~")")
            .navigationBarItems(trailing: Text("\(model.status.friendlyName)"))
            .onAppear {
                if self.model.recordID == nil {
                    self.onSave()
                }
                self.localActivityStatus = self.model.status
        }
    }
    
    //    private var trailingButton: some View {
    //        Group {
    //            if familyKitAppState.currentPlayer.isAdult {
    //                NavigationLink(destination:
    //                    AdultUserView()
    //                        .environment(\.window, window)
    //                        .environmentObject(appState)
    //                        .environmentObject(familyKitAppState)
    //                ){
    //                    HStack {
    //                        Text("\(familyKitAppState.currentPlayer.name)")
    //                        Text("\(familyKitAppState.currentPlayer.emoji)")
    //                        Text("(\(familyKitAppState.currentPlayer.bucks))")
    //                    }
    //                }
    //            } else {
    //                NavigationLink(destination:
    //                    KidUserView()
    //                        .environment(\.window, window)
    //                        .environmentObject(appState)
    //                        .environmentObject(familyKitAppState)
    //                ){
    //                    HStack {
    //                        Text("\(familyKitAppState.currentPlayer.name)")
    //                        Text("\(familyKitAppState.currentPlayer.emoji)")
    //                        Text("(\(familyKitAppState.currentPlayer.bucks))")
    //                    }
    //                }
    //            }
    //        }
    //    }
    //
    //    private var leadingButton: some View {
    //        NavigationLink(destination:
    //            PlayerOnboardingView()
    //                .environment(\.window, window)
    //                .environmentObject(familyKitAppState)
    //        ){
    //            HStack {
    //                Text("change player")
    //            }
    //        }
    //    }
    //
    
    func onDone() {
        guard let playerRecordReference = familyKitAppState.currentPlayer.recordReference else {
            self.devMessage = "invalid playerRecordReference"
            return
        }
        model.status = ActivityStatus.completed
        privateActiveChoreService.pushUpdateCreate(model: model) { (result) in
            switch result {
            case .failure(let error):
                self.devMessage = "save error\(error.localizedDescription)"
            case .success(let record):
                print( "success \(record)")
                self.devMessage = "success"
                self.model = record
            }
        }
    }
    
    func onSave() {
        privateActiveChoreService.pushUpdateCreate(model: model) { (result) in
            switch result {
            case .failure(let error):
                self.devMessage = "save error\(error.localizedDescription)"
            case .success(let record):
                print( "success \(record)")
                self.devMessage = "success"
                print( "record \(record.status.friendlyName)")
                print( "model \(self.model.status.friendlyName)")
                self.model = record
                //                self.localActivityStatus = record.status
            }
        }
    }
}//end CKChoreActiveDetailView

struct CKChoreActiveDetailView_Previews: PreviewProvider {
    
    static let container = CKContainer(identifier: CKContainerIdentifier)
    
    static var previews: some View {
        CKActivityActiveDetailView(
            model: CKActivityModel.mock
        )
            .environmentObject(AppState())
            .environmentObject((FamilyKitAppState(container: container)))
            .environmentObject(CKPrivateModelService<CKActivityDescriptionModel>(container: container))
            .environmentObject(CKPrivateModelService<CKActivityDescriptionModel>(container: container))
        
    }
}

