//
//  CKChoreDetailView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/2/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit
import SimpleGames

struct CKChoreDetailView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var privateChoreService: CKPrivateModelService<CKChoreModel>
    @EnvironmentObject var publicChoreService: CKPublicModelService<CKChoreModel>
    
    @State var devMessage: String?
    
    @State var chatService: ChatService = ChatService()
    
    @State var model: CKChoreModel
    var isPrivate:Bool
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
            Text("image: \(model.imageName ?? "~")")
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
                ForEach(CKChoreModel.Frequency.allCases, id: \.self) {
                    Text($0.rawValue)
                }
            }.pickerStyle(SegmentedPickerStyle())
            
            TextField("timeofday", text: $model.timeofday ?? "")
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("imageName", text: $model.imageName ?? "")
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
    
    var actionView: some View {
        Section(header: Text("Completion Actions")) {
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
        }//end List
    }
    
    func onSave() {
        if isPrivate {
            privateChoreService.pushUpdateCreate(model: model) { (result) in
                switch result {
                case .failure(let error):
                    self.devMessage = "save error\(error.localizedDescription)"
                case .success(let record):
                    print( "success \(record)")
                    DispatchQueue.main.async {
                        self.presentationMode.wrappedValue.dismiss()
                        self.publicChoreService.fetch { (result) in
                            print( "result")
                        }
                    }
                }
            }
        } else {
            publicChoreService.pushUpdateCreate(model: model) { (result) in
                switch result {
                case .failure(let error):
                    self.devMessage = "save error\(error.localizedDescription)"
                case .success(let record):
                    print( "success \(record)")
                    DispatchQueue.main.async {
                        self.presentationMode.wrappedValue.dismiss()
                        self.publicChoreService.fetch { (result) in
                            print( "result")
                        }
                    }
                }
            }
        }
    }
}//end CKChoreDetailView

struct CKChoreDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CKChoreDetailView(model: CKChoreModel.mock, isPrivate: true, enableEdit: false)
            
            CKChoreDetailView(model: CKChoreModel.mock, isPrivate: true, enableEdit: true)
        }
    }
}
