//
//  KidUserView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/6/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit
import CloudKit
import SimpleGames

struct KidUserView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var activityDescriptionService: CKPrivateModelService<CKActivityDescriptionModel>
    @EnvironmentObject var activityService: CKPrivateModelService<CKActivityModel>
    var chatService: ChatService = ChatService( container: CKContainer(identifier: CKContainerIdentifier) )
    
    @State var devMessage: String?
    
    @State var showChatSession:Bool = false
    @State var chatSessionModel: CKChatSessionModel?
    
    var body: some View {
        List{
            DevMessageView(devMessage: $devMessage)
            
            Section(header: Text("Current Player")) {
                Text("\(familyKitAppState.currentPlayerModel?.name ?? "none")")
                
                NavigationLink(destination: PlayerOnboardingView()) {
                    Text("Change Current Player")
                        .foregroundColor(.blue)
                }
            }
                        
            if self.chatSessionModel != nil {
                Button(action: {
                    self.showChatSession.toggle()
                }){
                    Text("Family Chat")
                        .foregroundColor(.blue)
                }
            }
        }
        .sheet(isPresented: $showChatSession) {
            if self.chatSessionModel != nil {
                ChatSessionView(chatSession: self.chatSessionModel!)
                    .environmentObject(self.familyKitAppState)
            } else {
                Text("NO CHAT SESSION")
            }
        }//end sheet
        .onAppear(perform: {
            
            self.configureChatSession()
            self.familyKitAppState.onRefetchFromServer()
        })
        .navigationBarTitle("\(familyKitAppState.currentPlayerModel?.name ?? "none")")
    }
    
    func configureChatSession() {
        chatService.findOrMakeFamilySession { (result) in
            switch result {
            case .success(let sessionModel):
                self.chatSessionModel = sessionModel
            case .failure(let error):
                self.devMessage = "error! \(error)"
            }
        }
    }
    
}


struct KidUserView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            KidUserView()
                //.environment(\.window, window)
                .environmentObject(AppState())
                .environmentObject(FamilyKitAppState(container: CKContainer(identifier: CKContainerIdentifier)))
                .previewDevice(PreviewDevice(rawValue: "iPad Air 2"))
            
            KidUserView()
                //.environment(\.window, window)
                .environmentObject(AppState())
                .environmentObject(FamilyKitAppState(container: CKContainer(identifier: CKContainerIdentifier)))
            .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
            .previewDisplayName("iPhone SE")
            
            KidUserView()
                //.environment(\.window, window)
                .environmentObject(AppState())
                .environmentObject(FamilyKitAppState(container: CKContainer(identifier: CKContainerIdentifier)))
            .previewDevice(PreviewDevice(rawValue: "iPhone XS Max"))
            .previewDisplayName("iPhone XS Max")

        }
    }
}

