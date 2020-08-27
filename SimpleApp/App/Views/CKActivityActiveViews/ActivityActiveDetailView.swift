//
//  CKActivityActiveDetailView.swift
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
    
    @State var showActivityIndicator: Bool = false
    @State var activityIndicatorMessage: String = "Saving"
    
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
                            
                            //self.model.changeStatus(status: value)
                            self.model.status = value
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
                
            }
        }
    }
    
    var body: some View {
        VStack {
            ActivityIndicatorView(
                isDisplayed: $showActivityIndicator,
                indicatorMessage: $activityIndicatorMessage
            ) {
                VStack {
                    //DevMessageView(devMessage: $devMessage)
                    if self.model.moduleType == .photo {
                        self.infoView
                        self.activityStatusView
                        PhotoActivitySubView(
                            model: self.$model,
                            showActivityIndicator: self.$showActivityIndicator,
                            activityIndicatorMessage: self.$activityIndicatorMessage
                        )
                    } else if self.model.moduleType == .audio {
                        self.infoView
                        self.activityStatusView
                        AudioActivitySubView(
                            model: self.$model,
                            showActivityIndicator: self.$showActivityIndicator,
                            activityIndicatorMessage: self.$activityIndicatorMessage
                        )
                    } else if self.model.moduleType == .chat {
                        self.infoView
                        self.activityStatusView
                        // TODO: just show the abridged view then if the tap it show the full screen sheet
                        // TODO: Fix the global chat
                    } else if self.model.moduleType == .drawing {
                        self.infoView
                        self.activityStatusView
                        DrawPreviewView(
                            model: self.$model,
                            showActivityIndicator: self.$showActivityIndicator,
                            activityIndicatorMessage: self.$activityIndicatorMessage
                        )
                    }
                    else {
                        self.infoView
                        self.activityStatusView
                    }
                    Spacer()
                    
                    if self.chatSessionModel != nil {
                        ChatPeekView(chatSessionModel: self.chatSessionModel!)
                            //.frame(minWidth: 200, maxWidth: .infinity, minHeight: 0, maxHeight: 100)
                            .frame(height: 200)
                    } else {
                        Text("LOADING Chat Session ... ")
                    }
                }//end VStack
            }//end ActivityIndicator
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
        self.activityIndicatorMessage  = "Saving"
        self.showActivityIndicator = true
        activityService.pushUpdateCreate(model: model) { (result) in
            switch result {
            case .failure(let error):
                self.devMessage = "save error\(error.localizedDescription)"
                self.showActivityIndicator = false
            case .success(let newModel):
                self.model = newModel
                self.showActivityIndicator = false
            }
        }
    }
}//end CKActivityActiveDetailView

struct CKActivityActiveDetailView_Previews: PreviewProvider {
    
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

