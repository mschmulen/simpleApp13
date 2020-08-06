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
    
    @EnvironmentObject var privateActiveChoreService: CKPrivateModelService<CKActivityModel>
    
    @State var devMessage: String?
    
    @State var chatService: ChatService = ChatService()
    
    @State var model: CKActivityModel
    @State private var coverPhotoImage:UIImage?
    
    var infoView: some View {
        VStack {
            Text("\(model.title ?? "~")")
            Text("\(model.description ?? "~")")
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
            ActivityActionView(model: $model)
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



