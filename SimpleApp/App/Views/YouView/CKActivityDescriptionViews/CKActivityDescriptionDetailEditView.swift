//
//  CKActivityDescriptionDetailEditView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/19/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import Combine
import FamilyKit
import SimpleGames

struct CKActivityDescriptionDetailEditView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var privateChoreService: CKPrivateModelService<CKActivityDescriptionModel>
    @EnvironmentObject var chatService: ChatService
    
    @State var devMessage: String?
    
    @State var model: CKActivityDescriptionModel
    @State private var coverPhotoImage:UIImage?
    
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
            
            Picker(selection: $model.moduleType, label: Text("Type")) {
                ForEach(ActivityModuleType.allCases, id: \.self) {
                    Text($0.rawValue)
                }
            }.pickerStyle(SegmentedPickerStyle())
            
            Picker(selection: $model.category, label: Text("Category")) {
                ForEach(ActivityCategory.allCases.filter { $0 != .none }, id: \.self) {
                    Text($0.rawValue)
                }
            }.pickerStyle(SegmentedPickerStyle())
            
//            Picker(selection: $model.frequency, label: Text("Frequency")) {
//                ForEach(CKActivityDescriptionModel.Frequency.allCases, id: \.self) {
//                    Text($0.rawValue)
//                }
//            }.pickerStyle(SegmentedPickerStyle())
            
            //            TextField("who", text: $model.who ?? "")
            //                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            //            TextField("timeofday", text: $model.timeofday ?? "")
            //                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            NavigationLink(destination: PhotoActivityDescriptionView(model: model) ) {
                Text("change coverPhoto")
            }
            
            Button(action: ({
                self.privateChoreService.removeAsset(model:self.model, assetPropertyName: "coverPhoto") { result in
                    switch result {
                    case .failure( let error):
                        print( "there was an error \(error)")
                    case .success(_):
                        print( "success")
                        self.privateChoreService.fetchSingle( model: self.model) { result in
                            print( "result")
                            //                            DispatchQueue.main.async {
                            //                                self.presentationMode.wrappedValue.dismiss()
                            //                            }
                        }
                    }
                }
            })) {
                Text("remove coverPhoto")
            }
        }
    }
    
    var body: some View {
        List{
            DevMessageView(devMessage: $devMessage)
            
            Button(action:onSave) {
                HStack {
                    Text("Save")
                    Image(systemName: "square.and.arrow.up")
                }.foregroundColor(.blue)
            }
            editView
            
            Section(header:Text("Assets")) {
                coverPhotoView
            }
            
        }//end List
            .onAppear {
                // try and download the image
                if self.model.coverPhoto != nil {
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

struct CKActivityDescriptionDetailEditView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CKActivityDescriptionDetailEditView(model: CKActivityDescriptionModel.mock)
        }
    }
}
