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

struct CKChoreActiveDetailView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var privateActiveChoreService: CKPrivateModelService<CKActivityActiveModel>
    
    @State var devMessage: String?
    
    @State var chatService: ChatService = ChatService()
    
    @State var model: CKActivityActiveModel
    @State private var coverPhotoImage:UIImage?
    
    var infoView: some View {
        VStack {
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
            //actionView
            ActivityActionView(model: $model)
            infoView
        }
        .onAppear {
        }
    }
    
    var coverPhotoView: some View {
        Group {
            if coverPhotoImage == nil {
                Text("NO IMAGE")
            } else {
                VStack {
                    Image(uiImage: coverPhotoImage!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 200)
                        .clipped()
                }
            }
        }
    }
    
    func onSave() {
        
        if let recordReference = familyKitAppState.currentPlayer.recordReference {
            self.model.kidReference = recordReference
            //self.model.ckChoreDescriptionReference = descriptionModel
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


struct ActivityActionView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var privateActiveChoreService: CKPrivateModelService<CKActivityActiveModel>
    
    @State var devMessage: String? = nil
    
    @State var chatService: ChatService = ChatService()
    
    @Binding var model: CKActivityActiveModel
    
    var body: some View {
        VStack{
            Button(action:onSave) {
                HStack {
                    Text("Save")
                    Image(systemName: "square.and.arrow.up")
                }
            }
            
            Spacer()
            
            if model.moduleType == .none {
                Text("moduleType.none")
                    .foregroundColor(.red)
            }
            
            if model.moduleType == .picture {
                NavigationLink(destination: PhotoView(model: model)) {
                    Text("take a picture")
                        .foregroundColor(.blue)
                }
            }
            
            if model.moduleType == .audio {
                NavigationLink(destination: AudioRecordView(audioRecorder: AudioRecorder())) {
                    Text("voice message")
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
    
    func onSave() {
        if let recordReference = familyKitAppState.currentPlayer.recordReference {
            self.model.kidReference = recordReference
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
    }
    
}
