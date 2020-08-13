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

struct CKChoreActiveDetailView: View {
    
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
    
    var deleteView: some View {
        Button(action: {
            print("delete")
            self.privateActiveChoreService.pushDelete(model: self.model) { (result) in
                switch result {
                case .failure(let error):
                    self.devMessage = "error deleting the model"
                default:
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }) {
            Text("Delete")
        }
    }
    
    var body: some View {
        VStack {
            DevMessageView(devMessage: $devMessage)
            
            infoView
            
            if familyKitAppState.currentPlayer.isAdult {
                deleteView
            }
            
            if model.kidReference != nil {
                if model.kidReference == familyKitAppState.currentPlayer.recordReference {
                    deleteView
                    ActivityActionView(model: $model)
                } else {
                    // TODO fetch the user information
                    Text("this is not your activity")
                    Text("\(familyKitAppState.findUserForRecord(recordReference: model.kidReference!)?.name ?? "~")")
                    ActivityActionView(model: $model)
                }
            }
            else {
                ActivityActionView(model: $model)
            }
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

struct CKChoreActiveDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CKChoreActiveDetailView(
            model: CKActivityModel.mock
        )
        .environmentObject(AppState())
        .environmentObject((FamilyKitAppState(container: CKContainer(identifier: CKContainerIdentifier))))
        .environmentObject(CKPrivateModelService<CKActivityDescriptionModel>(container: CKContainer(identifier: CKContainerIdentifier)))
        .environmentObject(CKPublicModelService<CKActivityDescriptionModel>(container: CKContainer(identifier: CKContainerIdentifier)))
        .environmentObject(CKPublicModelService<CKFunModel>(container: CKContainer(identifier: CKContainerIdentifier)))
        .environmentObject(CKPublicModelService<CKConnectModel>(container: CKContainer(identifier: CKContainerIdentifier)))
    }
}



