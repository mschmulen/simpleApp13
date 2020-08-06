//
//  ActivityActionView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/6/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit
import SimpleGames

struct ActivityActionView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var privateActiveChoreService: CKPrivateModelService<CKActivityModel>
    
    @State var devMessage: String? = nil
    
    @State var chatService: ChatService = ChatService()
    
    @Binding var model: CKActivityModel
    var showSave:Bool = true
    
    @State var audioRecorder = AudioRecorder()
    
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
            
            if model.moduleType == .photo {
                NavigationLink(destination: PhotoActivityModelView(model: $model)) {
                    Text("take a picture")
                        .foregroundColor(.blue)
                }
            }
            
            if model.moduleType == .audio {
                VStack {
                    Text("RECORD SOMETHING")
                    AudioRecordingsList(audioRecorder: audioRecorder)
                    if audioRecorder.recording == false {
                        Button(action: {
                            self.audioRecorder.startRecording()
                        }) {
                            Image(systemName: "circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .clipped()
                                .foregroundColor(.red)
                                .padding(.bottom, 40)
                        }
                    } else {
                        Button(action: {
                            self.audioRecorder.stopRecording()
                        }) {
                            Image(systemName: "stop.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .clipped()
                                .foregroundColor(.red)
                                .padding(.bottom, 40)
                        }
                    }
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
        guard let playerRecordReference = familyKitAppState.currentPlayer.recordReference else {
            self.devMessage = "invalid playerRecordReference"
            return
        }
        
        self.model.kidReference = playerRecordReference
        
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
