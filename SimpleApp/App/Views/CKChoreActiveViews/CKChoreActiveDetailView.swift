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
    
    @EnvironmentObject var privateActiveChoreService: CKPrivateModelService<CKChoreActiveModel>
    
    @State var devMessage: String?
    
    @State var chatService: ChatService = ChatService()
    
    var moduleType: CKChoreDescriptionModel.ModuleType
    @State var model: CKChoreActiveModel
    @State private var coverPhotoImage:UIImage?
    
    var infoView: some View {
        Section(header: Text("Info")) {
            Button(action:onSave) {
                HStack {
                    Text("Save")
                    Image(systemName: "square.and.arrow.up")
                }
            }
            
            Text("name: \(model.name ?? "~")")
            Text("emoji: \(model.emoji ?? "~")")
            Text("description: \(model.description ?? "~")")
            Text("bucks: \(model.bucks ?? 0)")
        }
    }
    
    var pictureView: some View {
        VStack {
            Text("Show picture view")
        }
    }
    var audioView: some View {
        VStack {
            Text("Show audio view")
        }
    }
    var drawingView: some View {
        VStack {
            Text("Show drawing view")
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
    
    var body: some View {
        List{
            if devMessage != nil {
                Text("\(devMessage!)")
                    .foregroundColor(.red)
                    .onTapGesture {
                        self.devMessage = nil
                }
            }
            
            infoView
            
            Section(header:Text("Assets")) {
                coverPhotoView
            }
            
        }//end List
            .onAppear {
                // try and download the image
//                self.model.loadCoverPhoto { (result) in
//                    switch result {
//                    case .failure(_):
//                        break
//                    case .success(let image):
//                        self.coverPhotoImage = image
//                    }
//                }
        }
    }
    
    func onSave() {
        
        if let recordReference = familyKitAppState.currentPlayer.recordReference {
            self.model.kidReference = recordReference
            self.model.name = "yack"
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