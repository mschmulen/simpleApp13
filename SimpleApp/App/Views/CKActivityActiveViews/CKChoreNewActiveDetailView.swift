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
    
    @State var devMessage: String?
    
    @State var chatService: ChatService = ChatService(container: CKContainer(identifier: CKContainerIdentifier))
    
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
            if devMessage != nil {
                Text("\(devMessage!)")
                    .foregroundColor(.red)
                    .onTapGesture {
                        self.devMessage = nil
                }
            }
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

//struct CKChoreActiveDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            CKChoreActiveDetailView(model: CKChoreActiveModel.mock, enableEdit: false, moduleType: "picture")
//
//            CKChoreActiveDetailView(model: CKChoreActiveModel.mock, enableEdit: true, moduleType: "picture")
//        }
//    }
//}
