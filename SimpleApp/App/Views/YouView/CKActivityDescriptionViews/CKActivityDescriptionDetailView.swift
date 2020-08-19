//
//  CKActivityDescriptionDetailView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/2/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import Combine
import FamilyKit
import SimpleGames

class ActivityDescriptionViewModel: ObservableObject {
    
    // Input
    @Published var name = ""
    
    // Output
    @Published var isValid = false
    
}

struct CKActivityDescriptionDetailView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var privateChoreService: CKPrivateModelService<CKActivityDescriptionModel>
    @EnvironmentObject var chatService: ChatService
    
    @State var devMessage: String?
    
    @State var model: CKActivityDescriptionModel
    @State private var coverPhotoImage:UIImage?
    
    var readOnlyView: some View {
        Section(header: Text("Info")) {
            Text("name: \(model.name ?? "~")")
            Text("emoji: \(model.emoji ?? "~")")
            Text("description: \(model.description ?? "~")")
            Text("bucks: \(model.bucks ?? 0)")
            
            Text("frequency: \(model.frequency.rawValue)")
            Text("who: \(model.who ?? "~")")
            Text("timeofday: \(model.timeofday ?? "~")")
            
            Text("moduleType: \(model.moduleType.rawValue)")
            
            
            // TODO: handle the imageAsset
            //Text("imageAsset: \(model.imageName ?? "~")")
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
            DevMessageView(devMessage: $devMessage)
            
            
            if familyKitAppState.currentPlayer.recordReference != nil {
                NavigationLink(destination: CKActivityActiveDetailView(
                    model: CKActivityModel(
                        descriptionModel: model,
                        playerRecordReference: familyKitAppState.currentPlayer.recordReference!),
                    localActivityStatus: ActivityStatus.active
                )) {
                    HStack {
                        Text("START THIS ACTIVITY")
                        Image(systemName: "plus")
                    }.foregroundColor(.blue)
                }
            }
            
            readOnlyView
            
            
            Section(header:Text("Assets")) {
                coverPhotoView
            }
            
        }//end List
            .onAppear {
                
                // try and download the image
                self.model.loadCoverPhoto { (result) in
                    switch result {
                    case .failure(_):
                        break
                    case .success(let image):
                        self.coverPhotoImage = image
                    }
                }
        }
    }
    
    func onSave() {
        privateChoreService.pushUpdateCreate(model: model) { (result) in
            switch result {
            case .failure(let error):
                self.devMessage = "save error\(error.localizedDescription)"
            case .success(let record):
                print( "success \(record)")
                DispatchQueue.main.async {
                    self.presentationMode.wrappedValue.dismiss()
                    self.privateChoreService.fetch { (result) in
                        print( "result")
                    }
                }
            }
        }
    }
    
}//end CKActivityDetailView

struct CKChoreDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CKActivityDescriptionDetailView(model: CKActivityDescriptionModel.mock)
            CKActivityDescriptionDetailView(model: CKActivityDescriptionModel.mock)
        }
    }
}
