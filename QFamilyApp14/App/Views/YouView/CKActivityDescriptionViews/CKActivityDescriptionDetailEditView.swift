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

struct XCKActivityDescriptionDetailEditView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var activityDescriptionService: CKPrivateModelService<CKActivityDescriptionModel>
    
    @State var devMessage: String?
    
    @State var model: CKActivityDescriptionModel
    @State private var coverPhotoImage: UIImage?
    
    @State var showActivityIndicator: Bool = false
    @State var activityIndicatorMessage: String = "Saving"
    
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
        VStack {
            DevMessageView(devMessage: self.$devMessage)
            
            ActivityIndicatorView(
                isDisplayed: $showActivityIndicator,
                indicatorMessage: $activityIndicatorMessage
            ) {
                VStack {
                    
                    HStack {
                        Spacer()
                        Button(action:self.onSave) {
                            HStack {
                                Text("Save")
                                Image(systemName: "square.and.arrow.up")
                            }.foregroundColor(.blue)
                        }.padding()
                    }
                    
                    List{
                        Section(header: Text("Data")) {
                            TextField("name", text: self.$model.name ?? "")
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            TextField("emoji", text: self.$model.emoji ?? "")
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            TextField("description", text: self.$model.description ?? "")
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            TextField("bucks", value: self.$model.bucks, formatter: NumberFormatter())
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            Picker(selection: self.$model.moduleType, label: Text("Type")) {
                                ForEach(ActivityModuleType.allCases, id: \.self) {
                                    Text($0.rawValue)
                                }
                            }.pickerStyle(SegmentedPickerStyle())
                            
                            Picker(selection: self.$model.category, label: Text("Category")) {
                                ForEach(ActivityCategory.allCases.filter { $0 != .none }, id: \.self) {
                                    Text($0.rawValue)
                                }
                            }.pickerStyle(SegmentedPickerStyle())
                            
                            NavigationLink(destination: PhotoActivityDescriptionView(model: self.model) ) {
                                Text("change coverPhoto")
                            }
                            
                            Button(action: ({
                                self.showActivityIndicator = true
                                self.activityDescriptionService.removeAsset(model:self.model, assetPropertyName: "coverPhoto") { result in
                                    switch result {
                                    case .failure( let error):
                                        self.showActivityIndicator = false
                                        self.devMessage = "save error\(error.localizedDescription)"
                                    case .success(_):
                                        print( "success")
                                        self.activityDescriptionService.fetchSingle( model: self.model) { result in
                                            self.showActivityIndicator = false
                                        }
                                    }
                                }
                            })) {
                                Text("remove coverPhoto")
                            }
                        }
                        
                        Section(header:Text("Assets")) {
                            self.coverPhotoView
                        }
                    }//end List
                }//end VStack
                //.navigationBarTitle("Activity")
                // .navigationBarItems(trailing: self.trailingButton)
            }//end ActivityIndicatorView
            Spacer()
        }//end VStack
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
        }//end onAppear
    }
    
//    private var trailingButton: some View {
//        Button(action:self.onSave) {
//            HStack {
//                Text("XSave")
//                Image(systemName: "square.and.arrow.up")
//            }
//            .foregroundColor(.blue)
//        }
//        .padding()
//    }
    
    func onSave() {
        self.showActivityIndicator = true
        activityDescriptionService.pushUpdateCreate(model: model) { (result) in
            switch result {
            case .failure(let error):
                self.devMessage = "save error\(error.localizedDescription)"
                self.showActivityIndicator = false
            case .success(_):
                self.showActivityIndicator = false
                DispatchQueue.main.async {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }//end onSave
    
}//end CKActivityDescriptionDetailEditView

//struct CKActivityDescriptionDetailEditView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            XCKActivityDescriptionDetailEditView(model: CKActivityDescriptionModel.mock)
//        }
//    }
//}
