//
//  PublicActivityDescriptionDetailView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 9/23/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit
import SimpleGames
import CloudKit

struct PublicActivityDescriptionDetailView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var activityDescriptionService: CKPrivateModelService<CKActivityDescriptionModel>
    //@EnvironmentObject var activityService: CKPrivateModelService<CKActivityModel>
    @State var chatService: ChatService = ChatService( container: CKContainer(identifier: CKContainerIdentifier) )
    
    @State var devMessage: String?
    
    @State var model: CKPublicActivityDescription
    
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
    
    var body: some View {
        VStack {
            
            //DevMessageView(devMessage: $devMessage)
            
            ActivityIndicatorView(
                isDisplayed: $showActivityIndicator,
                indicatorMessage: $activityIndicatorMessage
            ) {
                VStack {
                    self.infoView
                    Button(action: {
                        self.onAdd()
                    }) {
                        LargeTextPillBox( "ADD THIS ACTIVITY" )
                    }
                    Spacer()
                }//end VStack
            }//end ActivityIndicator
        }//end VStack
            .navigationBarTitle("\(model.title ?? "~")")
            //.navigationBarItems(trailing: Text("\(model.name)"))
            .onAppear {
        }
    }
    
    func onAdd() {
        let newActivityModel = CKActivityDescriptionModel()
        newActivityModel.name = model.name
        newActivityModel.description = model.description
        newActivityModel.bucks = model.bucks
        newActivityModel.emoji = model.emoji
        
        self.activityIndicatorMessage = "Saving"
        self.showActivityIndicator = true
        
        activityDescriptionService.pushUpdateCreate(model: newActivityModel) { (result) in
            switch result {
            case .failure(let error):
                self.devMessage = "save error\(error.localizedDescription)"
                self.showActivityIndicator = false
            case .success(_):
                self.showActivityIndicator = false
                //self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}//end PublicActivityDescriptionDetailView

struct PublicActivityDescriptionDetailView_Previews: PreviewProvider {
    
    static let container = CKContainer(identifier: CKContainerIdentifier)
    
    static var previews: some View {
        PublicActivityDescriptionDetailView(
            model: CKPublicActivityDescription.mock
        )
            .environmentObject(AppState())
            .environmentObject((FamilyKitAppState(container: CloudKitContainer.MockContainer(container))))
            .environmentObject(CKPrivateModelService<CKActivityDescriptionModel>(container: CloudKitContainer.MockContainer(container)))
            .environmentObject(CKPrivateModelService<CKActivityDescriptionModel>(container: CloudKitContainer.MockContainer(container)))
        
    }
}
