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

struct CKChoreDescriptionDetailView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var privateChoreService: CKPrivateModelService<CKChoreDescriptionModel>
    
    @State var devMessage: String?
    
    @State var chatService: ChatService = ChatService()
    
    @State var model: CKChoreDescriptionModel
    @State private var coverPhotoImage:UIImage?
    
    var enableEdit:Bool
    
    var readOnlyView: some View {
        Section(header: Text("Info")) {
            Text("name: \(model.name ?? "~")")
            Text("emoji: \(model.emoji ?? "~")")
            Text("description: \(model.description ?? "~")")
            Text("bucks: \(model.bucks ?? 0)")
            
            Text("frequency: \(model.frequency.rawValue)")
            Text("who: \(model.who ?? "~")")
            Text("timeofday: \(model.timeofday ?? "~")")
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
    
    var editView: some View {
        Section(header: Text("Data")) {
            Text("title \(model.title ?? "~")")
            
            TextField("name", text: $model.name ?? "")
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("emoji", text: $model.emoji ?? "")
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("description", text: $model.description ?? "")
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("bucks", value: $model.bucks ?? 2, formatter: NumberFormatter())
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("who", text: $model.who ?? "")
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Picker(selection: $model.frequency, label: Text("Frequency")) {
                ForEach(CKChoreDescriptionModel.Frequency.allCases, id: \.self) {
                    Text($0.rawValue)
                }
            }.pickerStyle(SegmentedPickerStyle())
            
            TextField("timeofday", text: $model.timeofday ?? "")
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            NavigationLink(destination: CoverPhotoUploadView(model: model) ) {
                Text("change coverPhoto")
            }
            
            Button(action: ({
                self.privateChoreService.removeCoverPhoto(model:self.model) { result in
                    switch result {
                    case .failure( let error):
                        print( "there was an error \(error)")
                    case .success(_):
                        print( "success")
                        self.model.reload(service: self.privateChoreService)
                        // self.presentationMode.wrappedValue.dismiss()
                    }
                }
            })) {
                Text("remove coverPhoto")
            }
        }
    }
    
    var actionView: some View {
        Section(header: Text("Completion Actions")) {
            
            NavigationLink(destination: CKChoreActiveDetailView(
                model: CKChoreActiveModel(),
                enableEdit: true
            )) {
                VStack {
                    Text("START")
                    Image(systemName: "plus")
                }
            }

            NavigationLink(destination: AudioRecordView(audioRecorder: AudioRecorder())) {
                Text("leave a voice message")
                    .foregroundColor(.blue)
            }
            
            NavigationLink(destination: ChatSessionView(chatService: self.$chatService)) {
                Text("chat with?")
                    .foregroundColor(.blue)
            }
            
            NavigationLink(destination: PhotoView()) {
                Text("take a picture")
                    .foregroundColor(.blue)
            }
            
            NavigationLink(destination: DrawView()) {
                Text("draw a picture")
                    .foregroundColor(.blue)
            }
            
            NavigationLink(destination: SimpleGameView()) {
                Text("play this game")
                    .foregroundColor(.blue)
            }
            
            Button(action: {
                print("do action")
            }) {
                Text("check box")
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
            
            if enableEdit {
                Button(action:onSave) {
                    HStack {
                        Text("Save")
                        Image(systemName: "square.and.arrow.up")
                    }
                }
                editView
                actionView
            } else {
                readOnlyView
                actionView
            }
            
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
}//end CKChoreDetailView

struct CKChoreDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CKChoreDescriptionDetailView(model: CKChoreDescriptionModel.mock, enableEdit: false)
            
            CKChoreDescriptionDetailView(model: CKChoreDescriptionModel.mock, enableEdit: true)
        }
    }
}
