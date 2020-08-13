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
    
    var isReadOnly:Bool = false
    
    var doneView: some View {
        Button(action:onDone) {
            HStack {
                Spacer()
                Text("Done")
                    .foregroundColor(.blue)
                    .padding()
                Image(systemName: "square.and.arrow.up")
                    .padding()
            }
            .foregroundColor(.blue)
            .padding()
        }
    }
    
    var body: some View {
        VStack {
            if isReadOnly == false {
                doneView
            }
            
            VStack {
            //ScrollView(.vertical, showsIndicators: false) {
                if model.moduleType == .photo {
                    PhotoActivityView(
                        model: $model,
                        isReadOnly: isReadOnly
                    )
                }
                
                if model.moduleType == .audio {
                    ActivityAudioActionView(
                        model: $model,
                        isReadOnly: isReadOnly
                    )
                }
                
                if model.moduleType == .drawing {
                    DrawView(
                        model: $model,
                        isReadOnly: isReadOnly
                    )
                }
                
                if model.moduleType == .chat {
                    ChatSessionView() // model: $model
                }
                
                // show the ChatSessionView
                //if model.chatSession != nil {
//                    ChatSessionView()
                //} else {
                
                NavigationLink(destination: ChatSessionView()) {
                    Text("Show Chat")
                        .foregroundColor(.blue)
                }
                
                 //EmptyView()
                //}
            }
        }
    }
    
    func onDone() {
        guard let playerRecordReference = familyKitAppState.currentPlayer.recordReference else {
            self.devMessage = "invalid playerRecordReference"
            return
        }
        
        self.model.kidReference = playerRecordReference
        
        model.status = .completed
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


struct ActivityActionView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityActionView(
            model: .constant(CKActivityModel.mock)
        )
    }
}
