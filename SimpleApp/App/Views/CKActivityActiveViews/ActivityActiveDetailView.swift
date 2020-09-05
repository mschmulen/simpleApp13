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
            
            //DevMessageView(devMessage: $devMessage)
            
            ActivityIndicatorView(
                isDisplayed: $showActivityIndicator,
                indicatorMessage: $activityIndicatorMessage
            ) {
                VStack {
                    if self.model.moduleType == .photo {
                        self.infoView
                        self.activityStatusView
                        PhotoActivitySubView(
                            model: self.$model,
                            showActivityIndicator: self.$showActivityIndicator,
                            activityIndicatorMessage: self.$activityIndicatorMessage
                        )
                        
                        if self.chatSessionModel != nil {
                            ChatPeekView(chatSessionModel: self.chatSessionModel!)
                            .frame(height: 200)
                        }
                        
                    } else if self.model.moduleType == .audio {
                        self.infoView
                        self.activityStatusView
                        AudioActivitySubView(
                            model: self.$model,
                            showActivityIndicator: self.$showActivityIndicator,
                            activityIndicatorMessage: self.$activityIndicatorMessage
                        )
                        
                        if self.chatSessionModel != nil {
                            ChatPeekView(chatSessionModel: self.chatSessionModel!)
                                .frame(height: 200)
                        }
                    } else if self.model.moduleType == .drawing {
                        self.infoView
                        self.activityStatusView
                        DrawPreviewView(
                            model: self.$model,
                            showActivityIndicator: self.$showActivityIndicator,
                            activityIndicatorMessage: self.$activityIndicatorMessage
                        )
                        
                        if self.chatSessionModel != nil {
                            ChatPeekView(chatSessionModel: self.chatSessionModel!)
                                //.frame(height: 200)
                        }
                        
                    } else if self.model.moduleType == .chat {
                        self.infoView
                        self.activityStatusView
                        
                        if self.chatSessionModel != nil {
                            ChatPeekView(chatSessionModel: self.chatSessionModel!)
                        }
                        // Spacer()
                    }
                    else {
                        self.infoView
                        self.activityStatusView
                    }
                }//end VStack
            }//end ActivityIndicator
        }//end VStack
            .navigationBarTitle("\(model.title ?? "~")")
            .navigationBarItems(trailing: Text("\(model.status.friendlyName)"))
            .onAppear {
                if self.model.recordID == nil {
                    self.onSave()
                } else {
                    self.configureChatSession()
                }
        }
    }
    
    func configureChatSession() {
        self.showActivityIndicator = true
        chatService.findOrMakeSession(model:model) { result in
            switch result {
            case .success(let sessionModel):
                self.chatSessionModel = sessionModel
                self.showActivityIndicator = false
            case .failure(let error):
                self.devMessage = "error! \(error)"
                self.showActivityIndicator = false
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
                self.configureChatSession()
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
            .environmentObject((FamilyKitAppState(container: CloudKitContainer.MockContainer(container))))
            .environmentObject(CKPrivateModelService<CKActivityDescriptionModel>(container: CloudKitContainer.MockContainer(container)))
            .environmentObject(CKPrivateModelService<CKActivityDescriptionModel>(container: CloudKitContainer.MockContainer(container)))
        
    }
}

