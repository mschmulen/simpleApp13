//
//  CKChoreNewActiveDetailView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/6/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit
import SimpleGames
import CloudKit

struct CKChoreNewActiveDetailView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var privateActiveChoreService: CKPrivateModelService<CKActivityModel>
    @EnvironmentObject var chatService: ChatService
    
    @State var devMessage: String?
    
    var descriptionModel: CKActivityDescriptionModel
    
    @State private var model: CKActivityModel = CKActivityModel()
    @State private var coverPhotoImage:UIImage?
    
    var infoView: some View {
        VStack {
            Text("\(model.title ?? "~")")
            Text("\(model.description ?? "~")")
            Text("moduleType: \(model.moduleType.rawValue)")
        }
    }
    
    var body: some View {
        VStack {
            DevMessageView(devMessage: $devMessage)
            //infoView
            ActivityActionView(model: $model)
        }
        .onAppear {
            
            guard let kidRecordReference = self.familyKitAppState.currentPlayer.recordReference else {
                return
            }
            
            guard let choreDescriptionRecordID = self.descriptionModel.recordID else {
                return
            }
            
            let choreDescriptionReference = CKRecord.Reference(recordID: choreDescriptionRecordID, action: .deleteSelf)
            
            self.model.name = self.descriptionModel.name
            self.model.description = self.descriptionModel.description
            self.model.bucks = self.descriptionModel.bucks
            
            self.model.ckChoreDescriptionReference = choreDescriptionReference
            self.model.kidReference = kidRecordReference
            self.model.moduleType = self.descriptionModel.moduleType
            
            self.model.emoji = self.descriptionModel.emoji
            
            self.model.category = self.descriptionModel.category
            self.model.status = ActivityStatus.active
            
            // create a new Chat Session
//            let newChatSession = CKChatSessionModel()
//            newChatSession.name = "activityChat"
//            self.model.chatSession = newChatSession
            
            self.privateActiveChoreService.pushUpdateCreate(model: self.model) { (result) in
                switch result {
                case .failure(let error):
                    self.devMessage = "save error\(error.localizedDescription)"
                case .success(let model):
                    self.devMessage = "success"
                    self.model = model
                    DispatchQueue.main.async {
                        //self.presentationMode.wrappedValue.dismiss()
                        self.privateActiveChoreService.fetch { (result) in
                            print( "result")
                        }
                    }
                }
            }
            
        }
    }
    
    func onSave() {
        
        guard let kidRecordReference = familyKitAppState.currentPlayer.recordReference else {
            return
        }
        
        guard let choreDescriptionRecordID = descriptionModel.recordID else {
            return
        }
        
        guard let kidReference = model.kidReference else {
            return
        }
        
        guard let ckChoreDescriptionReference = model.ckChoreDescriptionReference else {
            return
        }
        
//        let choreDescriptionReference = CKRecord.Reference(recordID: choreDescriptionRecordID, action: .deleteSelf)
//
//        self.model.name = descriptionModel.name
//        self.model.description = descriptionModel.description
//        self.model.bucks = descriptionModel.bucks
//
//        self.model.ckChoreDescriptionReference = choreDescriptionReference
//        self.model.kidReference = kidRecordReference
//        self.model.moduleType = descriptionModel.moduleType
        
        privateActiveChoreService.pushUpdateCreate(model: model) { (result) in
            switch result {
            case .failure(let error):
                self.devMessage = "save error\(error.localizedDescription)"
            case .success(let record):
                print( "success \(record)")
                self.devMessage = "success"
                DispatchQueue.main.async {
                    //self.presentationMode.wrappedValue.dismiss()
                    self.privateActiveChoreService.fetch { (result) in
                        print( "result")
                    }
                }
            }
        }
    }
    
}//end CKChoreActiveDetailView

struct CKChoreNewActiveDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CKChoreNewActiveDetailView(
                descriptionModel: CKActivityDescriptionModel.mock
            )
            .environmentObject(AppState())
            .environmentObject((FamilyKitAppState(container: CKContainer(identifier: CKContainerIdentifier))))
            .environmentObject(CKPrivateModelService<CKActivityDescriptionModel>(container: CKContainer(identifier: CKContainerIdentifier)))
            .environmentObject(CKPublicModelService<CKActivityDescriptionModel>(container: CKContainer(identifier: CKContainerIdentifier)))
            .environmentObject(CKPublicModelService<CKFunModel>(container: CKContainer(identifier: CKContainerIdentifier)))
            .environmentObject(CKPublicModelService<CKConnectModel>(container: CKContainer(identifier: CKContainerIdentifier)))
        }
    }
}
