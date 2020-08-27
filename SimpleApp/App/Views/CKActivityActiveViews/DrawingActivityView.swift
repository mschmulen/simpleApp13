//
//  DrawingActivityView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/14/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit
import SimpleGames
import DrawingKit
import CloudKit

struct DrawingActivityView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var activityService: CKPrivateModelService<CKActivityModel>
    
    @State var devMessage: String? = nil
    
    @Binding var model: CKActivityModel
    
    var isReadOnly:Bool = false
    
    @State var isChatFocus = false
    
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
                        model: $model
                    )
                }
                
                if model.moduleType == .audio {
                    ActivityAudioActionView(
                        model: $model
                    )
                }
                
                if model.moduleType == .drawing {
                    DrawView(
                        model: $model
                    )
                }
                
//                if model.moduleType == .chat {
//                    ChatSessionView() // model: $model
//                }
                
//                if isChatFocus == true {
//                    ChatEmbeddedScrollView(
//                        model:$model,
//                        isChatFocus: $isChatFocus
//                    )
//                    .frame(height: 500)
//                    Spacer()
//                } else {
//                    Spacer()
//                    ChatEmbeddedScrollView(
//                        model:$model,
//                        isChatFocus: $isChatFocus
//                    )
//                        .frame(height: 200)
//                }
                
                
                // TODO: Fix the global chat
//                NavigationLink(destination: ChatSessionView()) {
//                    Text("Show Chat")
//                        .foregroundColor(.blue)
//                }
                
            }
        }
    }
    
    func onDone() {
        // guard let playerRecordReference = familyKitAppState.currentPlayer.recordReference else {
        guard let playerRecordReference = familyKitAppState.currentPlayerModel?.recordReference else {
            self.devMessage = "invalid playerRecordReference"
            return
        }
        
        self.model.kidReference = playerRecordReference
        
        model.status = .completed
        activityService.pushUpdateCreate(model: model) { (result) in
            switch result {
            case .failure(let error):
                self.devMessage = "save error\(error.localizedDescription)"
            case .success(let record):
                print( "success \(record)")
                self.devMessage = "success"
                DispatchQueue.main.async {
                    //self.presentationMode.wrappedValue.dismiss()
                    self.activityService.fetch(
                        sortDescriptor: .none, searchPredicate: .predicateTrue
                    ) { (result) in
                        print( "result")
                    }
                }
            }
        }
    }
}

struct DrawingActivityView_Previews: PreviewProvider {
    static var previews: some View {
        DrawingActivityView(
            model: .constant(CKActivityModel.mockDrawing)
        )
    }
}
