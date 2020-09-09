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
    let showStatusButtons:Bool
    
    @State var showActivityIndicator: Bool = false
    @State var activityIndicatorMessage: String = "Loading"
    
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
                
//                if self.model.status == .completed {
//                    verifyButton
//                }
                
            }// end if is adult
            else {
                // TODO: only show the complete button if current user is owner of card
                if self.model.status == .active {
                    completeButton
                } else if self.model.status == .unknown {
                    activeButton
                }
            }
        }
    }
    
    var verifyButton: some View {
        Button(action: {
            self.model.status = .verified
            self.onSave()
        }) {
            LargeTextPillBox( "Verify" )
        }
    }
    
    var activeButton: some View {
        Button(action: {
            self.model.status = .active
            self.onSave()
        }) {
            LargeTextPillBox( "Activate" )
        }
    }
    
    var completeButton: some View {
        Button(action: {
            self.model.status = .completed
            self.onSave()
        }) {
            LargeTextPillBox("Complete")
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
                    self.infoView
                    if self.showStatusButtons == true {
                        self.activityStatusView
                    }
                    if self.model.moduleType == .photo {
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
                        if self.chatSessionModel != nil {
                            ChatPeekView(chatSessionModel: self.chatSessionModel!)
                        }
                        // Spacer()
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
        self.activityIndicatorMessage = "Saving"
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
            localActivityStatus: ActivityStatus.active,
            showStatusButtons: true
        )
            .environmentObject(AppState())
            .environmentObject((FamilyKitAppState(container: CloudKitContainer.MockContainer(container))))
            .environmentObject(CKPrivateModelService<CKActivityDescriptionModel>(container: CloudKitContainer.MockContainer(container)))
            .environmentObject(CKPrivateModelService<CKActivityDescriptionModel>(container: CloudKitContainer.MockContainer(container)))
        
    }
}

