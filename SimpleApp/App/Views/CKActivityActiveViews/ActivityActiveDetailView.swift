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
    
    @EnvironmentObject var activityService: CKPrivateModelService<CKActivityModel>
    @State var chatService: ChatService = ChatService( container: CKContainer(identifier: CKContainerIdentifier) )
    
    @State var devMessage: String?
    
    @State var model: CKActivityModel
    @State var localActivityStatus: ActivityStatus
    
    @State var chatSessionModel: CKChatSessionModel?
    
    var infoView: some View {
        VStack {
            Text("\(model.description ?? "~")")
                .font(.system(size: 20, weight: .medium, design: .rounded))
                .padding()
        }
    }
    
    var activityStatusView: some View {
        VStack {
            if (self.familyKitAppState.currentPlayerModel?.isAdult ?? false) {
                Picker(selection: $localActivityStatus, label: Text("Status")) {
                    ForEach(ActivityStatus.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }.pickerStyle(SegmentedPickerStyle())
                    .padding()
                    .onReceive([localActivityStatus].publisher.first()) { value in
                        if value != self.model.status {
                            
                            self.model.changeStatus(status: value)
                            self.onSave()
                            
                            // give them points
                            if let playerReference = self.model.kidReference {
                                if value == .verified {
                                    if let playerModel = self.familyKitAppState.findPlayerModelForRecord(recordReference: playerReference) {
                                        self.familyKitAppState.addBucks(playerModel: playerModel, bucks: self.model.bucks)
                                    }
                                }
                            }
                        }
                }
            }// end if is adult
            else {
                //                if familyKitAppState.currentPlayer.isOwner(model: model) {
                //                    if model.status == .active {
                //                        Button(action: {
                //                            self.model.changeStatus(status: .completed)
                //                            self.onSave()
                //                        }) {
                //                            Text("Complete")
                //                        }
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
                // TODO: Fix the global chat
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
            
            if chatSessionModel != nil {
                ChatPeekView(chatSessionModel: chatSessionModel!)
                    //.frame(minWidth: 200, maxWidth: .infinity, minHeight: 0, maxHeight: 100)
                    .frame(height: 200)
            } else {
                Text("NO CHAT Session Model :( ")
            }
        }//end VStack
            .navigationBarTitle("\(model.title ?? "~")")
            .navigationBarItems(trailing: Text("\(model.status.friendlyName)"))
            .onAppear {
                if self.model.recordID == nil {
                    self.onSave()
                }
                self.configureChatSession()
        }
    }
    
    func configureChatSession() {
        chatService.findOrMakeSession(model:model) { result in
            switch result {
            case .success(let sessionModel):
                self.chatSessionModel = sessionModel
            case .failure(let error):
                self.devMessage = "error! \(error)"
            }
        }
    }
    
    func onSave() {
        activityService.pushUpdateCreate(model: model) { (result) in
            switch result {
            case .failure(let error):
                self.devMessage = "save error\(error.localizedDescription)"
            case .success(let record):
                print( "success \(record)")
                self.devMessage = "success"
                print( "record \(record.status.friendlyName)")
                print( "model \(self.model.status.friendlyName)")
                self.model = record
            }
        }
    }
    
    //    func onDone() {
    //        guard let playerRecordReference = familyKitAppState.currentPlayer.recordReference else {
    //            self.devMessage = "invalid playerRecordReference"
    //            return
    //        }
    //        model.status = ActivityStatus.completed
    //        privateActiveChoreService.pushUpdateCreate(model: model) { (result) in
    //            switch result {
    //            case .failure(let error):
    //                self.devMessage = "save error\(error.localizedDescription)"
    //            case .success(let record):
    //                print( "success \(record)")
    //                self.devMessage = "success"
    //                self.model = record
    //            }
    //        }
    //    }
    
}//end CKChoreActiveDetailView

struct CKChoreActiveDetailView_Previews: PreviewProvider {
    
    static let container = CKContainer(identifier: CKContainerIdentifier)
    
    static var previews: some View {
        CKActivityActiveDetailView(
            model: CKActivityModel.mock,
            localActivityStatus: ActivityStatus.active
        )
            .environmentObject(AppState())
            .environmentObject((FamilyKitAppState(container: container)))
            .environmentObject(CKPrivateModelService<CKActivityDescriptionModel>(container: container))
            .environmentObject(CKPrivateModelService<CKActivityDescriptionModel>(container: container))
        
    }
}

