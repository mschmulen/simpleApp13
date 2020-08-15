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
    
    var activityStatusView: some View {
        HStack {
            if familyKitAppState.currentPlayer.isAdult {
                Picker(selection: $model.status, label: Text("Status")) {
                    ForEach(ActivityStatus.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }.pickerStyle(SegmentedPickerStyle())
            } else {
                if model.status == .active {
                    Button(action: onDone ) {
                        HStack {
                            Spacer()
                            Text("Done")
                                .foregroundColor(.blue)
                                .padding()
                        }
                        .foregroundColor(.blue)
                        .padding()
                    }
                }
                Text("Status: \(model.status.friendlyName)")
            }
            
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
                activityStatusView
                PhotoActivityView(
                    model: $model
                )
            } else if model.moduleType == .audio {
                infoView
                activityStatusView
                ActivityAudioActionView(
                    model: $model,
                    isReadOnly: false
                )
            } else if model.moduleType == .chat {
                infoView
                activityStatusView
                ChatSessionView()
            } else if model.moduleType == .drawing {
                infoView
                activityStatusView
                DrawView(
                    model: $model,
                    isReadOnly: false
                )
            }
            else {
                infoView
                activityStatusView
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
        model.status = ActivityStatus.completed
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

