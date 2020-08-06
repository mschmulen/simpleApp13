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
    
    @EnvironmentObject var privateActiveChoreService: CKPrivateModelService<CKActivityActiveModel>
    
    @State var devMessage: String?
    
    @State var chatService: ChatService = ChatService()
    
    var descriptionModel: CKActivityDescriptionModel
    
    @State private var model: CKActivityActiveModel = CKActivityActiveModel()
    @State private var coverPhotoImage:UIImage?
    
    var infoView: some View {
        VStack {
            Text("moduleType: \(model.moduleType.rawValue)")
        }
    }
    
    var actionView: some View {
        VStack{
            Button(action:onSave) {
                HStack {
                    Text("Save")
                    Image(systemName: "square.and.arrow.up")
                }
            }
            
            if model.moduleType == .picture {
                NavigationLink(destination: PhotoView()) {
                    Text("take a picture")
                        .foregroundColor(.blue)
                }
            }
            
            if model.moduleType == .audio {
                NavigationLink(destination: AudioRecordView(audioRecorder: AudioRecorder())) {
                    Text("leave a voice message")
                        .foregroundColor(.blue)
                }
            }
            
            if model.moduleType == .drawing {
                NavigationLink(destination: DrawView()) {
                    Text("draw a picture")
                        .foregroundColor(.blue)
                }
            }
            
            if model.moduleType == .chat {
                NavigationLink(destination: ChatSessionView(chatService: self.$chatService)) {
                    Text("chat with?")
                        .foregroundColor(.blue)
                }
            }
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
            actionView
            infoView
        }
        .onAppear {
        }
    }
    
    func onSave() {
        
        guard let kidRecordReference = familyKitAppState.currentPlayer.recordReference else {
            return
        }
        
        guard let choreDescriptionRecordID = descriptionModel.recordID else {
            return
        }
        
        let choreDescriptionReference = CKRecord.Reference(recordID: choreDescriptionRecordID, action: .deleteSelf)
        
        self.model.ckChoreDescriptionReference = choreDescriptionReference
        self.model.kidReference = kidRecordReference
        self.model.moduleType = descriptionModel.moduleType
        
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
