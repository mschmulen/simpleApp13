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
import CloudKit

struct CKActivityActiveDetailView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var privateActiveChoreService: CKPrivateModelService<CKActivityModel>
    @EnvironmentObject var chatService: ChatService
    
    @State var devMessage: String?
    
    @State var model: CKActivityModel
    @State private var coverPhotoImage:UIImage?
    
    var infoView: some View {
        VStack {
            Text("\(model.title ?? "~")")
            Text("\(model.description ?? "~")")
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
    
    var statusView: some View {
        HStack {
//            Button(action:onChangeStatus(XXX)) {
//                HStack {
//                    Spacer()
//                    Text("active")
//                        .foregroundColor(.blue)
//                        .padding()
//                }
//                .foregroundColor(.blue)
//                .padding()
//            }
            
            Spacer()
            Button(action:onDone) {
                HStack {
                    Spacer()
                    Text("Done")
                        .foregroundColor(.blue)
                        .padding()
                }
                .foregroundColor(.blue)
                .padding()
            }
            Spacer()
            Button(action:onVerify) {
                HStack {
                    Spacer()
                    Text("Verify")
                        .foregroundColor(.blue)
                        .padding()
                }
                .foregroundColor(.blue)
                .padding()
            }
            Spacer()
            
            //            Button(action: {
            //                print("Delete")
            //                self.privateActiveChoreService.pushDelete(model: self.model) { (result) in
            //                    switch result {
            //                    case .failure(let error):
            //                        self.devMessage = "error deleting the model"
            //                    default:
            //                        self.presentationMode.wrappedValue.dismiss()
            //                    }
            //                }
            //            }) {
            //                Text("Delete")
            //            }
            
        }
    }
    
    var body: some View {
        VStack {
            DevMessageView(devMessage: $devMessage)
            if model.moduleType == .photo {
                infoView
                statusView
                PhotoActivityView(
                    model: $model
                )
            } else if model.moduleType == .audio {
                infoView
                statusView
                ActivityAudioActionView(
                    model: $model,
                    isReadOnly: false
                )
            } else if model.moduleType == .chat {
                infoView
                statusView
                ChatSessionView()
            } else if model.moduleType == .drawing {
                infoView
                statusView
                DrawView(
                    model: $model,
                    isReadOnly: false
                )
            }
            else {
                infoView
                statusView
            }
            
            //            if model.kidReference != nil {
            //                if model.kidReference == familyKitAppState.currentPlayer.recordReference {
            //                    ActivityActionView(model: $model)
            //                } else {
            //                    // TODO fetch the user information
            //                    Text("this is not your activity")
            //                    Text("\(familyKitAppState.findUserForRecord(recordReference: model.kidReference!)?.name ?? "~")")
            //                    ActivityActionView(model: $model)
            //                }
            //            }
            //            else {
            //                ActivityActionView(model: $model)
            //            }
        }
        .onAppear {
            if self.model.recordID == nil {
                self.onSave()
            }
        }
    }
    
    
    
    func onVerify() {
        guard let playerRecordReference = familyKitAppState.currentPlayer.recordReference else {
            self.devMessage = "invalid playerRecordReference"
            return
        }
        
        self.model.kidReference = playerRecordReference
        
        model.status = .verified
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
                self.model = record
            }
        }
    }
    
    func onSave() {
        privateActiveChoreService.pushUpdateCreate(model: model) { (result) in
            switch result {
            case .failure(let error):
                self.devMessage = "save error\(error.localizedDescription)"
            case .success(let record):
                print( "success \(record)")
                self.devMessage = "success"
                self.model = record
            }
        }
    }
}//end CKChoreActiveDetailView

struct CKChoreActiveDetailView_Previews: PreviewProvider {
    
    static let container = CKContainer(identifier: CKContainerIdentifier)
    
    static var previews: some View {
        CKActivityActiveDetailView(
            model: CKActivityModel.mock
        )
            .environmentObject(AppState())
            .environmentObject((FamilyKitAppState(container: container)))
            .environmentObject(CKPrivateModelService<CKActivityDescriptionModel>(container: container))
            .environmentObject(CKPrivateModelService<CKActivityDescriptionModel>(container: container))
        
    }
}

