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
import DrawingKit
import CloudKit

struct ActivityActionView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var privateActiveChoreService: CKPrivateModelService<CKActivityModel>
    @EnvironmentObject var chatService: ChatService
    
    @State var devMessage: String? = nil    
    
    @Binding var model: CKActivityModel
    
    var showSave:Bool = false
    // TODO: support isReadOnly
    var isReadOnly:Bool = false
    
    var body: some View {
        VStack {
            
            if showSave == true {
                Button(action:onSave) {
                    HStack {
                        Text("Save")
                            .foregroundColor(.blue)
                        Image(systemName: "square.and.arrow.up")
                    }.foregroundColor(.blue)
                }
            }
            
            VStack {
                if model.moduleType == .photo {
                    PhotoActivityView(model: $model)
                    //                NavigationLink(destination: PhotoActivityModelView(model: $model)) {
                    //                    Text("take a picture")
                    //                        .foregroundColor(.blue)
                    //                }
                }
                
                if model.moduleType == .audio {
                    ActivityAudioActionView(model: $model, enableRecording: !isReadOnly)
                }
                
                if model.moduleType == .drawing {
                    DrawView(model: $model, enableEdit: !isReadOnly)
                    //DrawingView(drawingState: nil)
                }
                
                if model.moduleType == .chat {
                    ChatSessionView()
                }
                EmptyView()
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

