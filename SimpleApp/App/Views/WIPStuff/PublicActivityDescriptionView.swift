//
//  PublicActivityDescriptionView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 9/22/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit
import CloudKit

struct PublicActivityDescriptionView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @State var devMessage: String?
    
    var body: some View {
        List{
            DevMessageView(devMessage: $devMessage)
            Text("DEV PublicActivityDescriptionView")
            
            Button(action: {
                let newModel = CKPublicActivityDescription()
                newModel.description = "yack \(Date())"
                newModel.name = "yack \(Date())"
                newModel.bucks = 2
                newModel.emoji = "🧵"
                newModel.category = .chore
                newModel.coverPhoto = nil
                newModel.moduleType = .photo
                
                self.familyKitAppState.agentService.pushNew(model: newModel)
                
//                self.familyKitAppState.agentService.publicActivityDescriptionService.pushUpdateCreate(model: newModel) { (result) in
//                    switch result {
//                    case .failure(let error) :
//                        print( "error \(error)")
//                    case .success(let model):
//                        print( "success \(model)")
//                    }
//                }
                
            }) {
                Text("ADD NEW")
            }
            
            Section(header: Text("public activity descriptions \(self.familyKitAppState.agentService.models.count)" )) {
                
                Text("yack \(self.familyKitAppState.agentService.models.count)")
                
                //                ForEach( self.familyKitAppState.playerService.models ) { model in
                //                    if model.ckRecord != nil {
                //                        NavigationLink(destination: ShareInviteView(share: CKShare(rootRecord: model.ckRecord!), rootRecord: model.ckRecord!)) {
                //                            Text("\(model.name ?? "?"): share record ")
                //                                .foregroundColor(.blue)
                //                        }
                //                    } else {
                //                        Text("nil record")
                //                    }
            }
            
        }.onAppear(perform: {
            self.familyKitAppState.onRefetchFromServer()
            self.familyKitAppState.agentService.upateRecommendations(agentInput: AgentService.AgentInput())
        })
        //.navigationBarItems(trailing: trailingButton)
        //                    .navigationBarTitle("CKUser")
    }
    
}

struct PublicActivityDescriptionView_Previews: PreviewProvider {
    
    static let container = CKContainer(identifier: CKContainerIdentifier)
    
    static var previews: some View {
        PublicActivityDescriptionView()
            .environmentObject(AppState())
            .environmentObject((FamilyKitAppState(container: CloudKitContainer.CloudContainer(container))))
            .environmentObject(CKPrivateModelService<CKActivityDescriptionModel>(container: CloudKitContainer.CloudContainer(container)))
            .environmentObject(CKPrivateModelService<CKActivityModel>(container: CloudKitContainer.CloudContainer(container)))
    }
}


