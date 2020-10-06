//
//  NewActivityDescriptionWizardView.swift
//  QFamilyApp14
//
//  Created by Matthew Schmulen on 10/6/20.
//

import SwiftUI
import Combine
import FamilyKit
import SimpleGames

struct NewActivityDescriptionWizardView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var activityDescriptionService: CKPrivateModelService<CKActivityDescriptionModel>
    
    @State var devMessage: String?
    
    @State var model: CKActivityDescriptionModel
    @State private var coverPhotoImage: UIImage?
    
    @State var showActivityIndicator: Bool = false
    @State var activityIndicatorMessage: String = "Saving"
    
    @State var nameString: String = ""
    @State var descriptionString: String = ""
    @State var emojiString: String = ""
    
    var body: some View {
        TabView {
            ViewName(model: $model)
            ViewDescription(model: $model)
            ViewEmoji(model: $model)
            ViewModuleType(model: $model)
            ViewCoverPhoto(model: $model)
            ViewEnd(model: $model) {
                onSaveAndClose()
            }
        }
        .tabViewStyle(PageTabViewStyle())
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
    
    var bodyX: some View {
        VStack {
            DevMessageView(devMessage: self.$devMessage)
            
            ActivityIndicatorView(
                isDisplayed: $showActivityIndicator,
                indicatorMessage: $activityIndicatorMessage
            ) {
                VStack {
                    
                    HStack {
                        Spacer()
                        Button(action:self.onSaveAndClose) {
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
    
    func onSaveAndClose() {
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
    }//end onSaveAndClose
    
}

extension NewActivityDescriptionWizardView {
    
    struct ViewName: View {
        
        @Binding var model: CKActivityDescriptionModel
        
        var backgroundColor = SemanticAppColor.random
        
        var body: some View {
            ZStack {
                backgroundColor
                VStack {
                    Spacer()
                    Text("Name")
                        .padding()
                        .foregroundColor(.white)
                    Spacer()
                    Text("Name:")
                        .padding()
                        .foregroundColor(.white)

                    TextField("name", text: self.$model.name ?? "")
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    Spacer()
                }
            }
        }
    }
    
    struct ViewDescription: View {
        
        @Binding var model: CKActivityDescriptionModel
        
        var backgroundColor = SemanticAppColor.random
        
        var body: some View {
            ZStack {
                backgroundColor
                VStack {
                    Spacer()
                    Text("Description")
                        .padding()
                        .foregroundColor(.white)
                    Spacer()
                    
                    Text("Description:")
                        .padding()
                        .foregroundColor(.white)

                    TextField("description", text: self.$model.description ?? "")
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    //TextEditor(text: text: self.$model.description ?? "")
                    Spacer()
                }
            }
        }
    }
    
    struct ViewEmoji: View {
        
        @Binding var model: CKActivityDescriptionModel
        
        var backgroundColor = SemanticAppColor.random
        
        var body: some View {
            ZStack {
                backgroundColor
                VStack {
                    Text("ViewEmoji")
                        .padding()
                        .foregroundColor(.white)
                    Spacer()
                    
                    Text("Emoji:")
                        .padding()
                        .foregroundColor(.white)
                    TextField("emoji", text: self.$model.emoji ?? "")
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Spacer()
                }
            }
        }
    }
    
    struct ViewModuleType: View {
        
        @Binding var model: CKActivityDescriptionModel
        
        var backgroundColor = SemanticAppColor.random
        
        var body: some View {
            ZStack {
                backgroundColor
                VStack {
                    Text("ViewModuleType")
                        .padding()
                        .foregroundColor(.white)
                    Spacer()
                    
                    Text("Module Type:")
                        .padding()
                        .foregroundColor(.white)

                    Picker(selection: self.$model.moduleType, label: Text("Type")) {
                        ForEach(ActivityModuleType.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()

                    Spacer()
                    
                    Text("Cataegory:")
                        .padding()
                        .foregroundColor(.white)
                    
                    Picker(selection: self.$model.category, label: Text("Category")) {
                        ForEach(ActivityCategory.allCases.filter { $0 != .none }, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    Spacer()
                }
            }
        }
    }
    
    struct ViewCoverPhoto: View {

        @Binding var model: CKActivityDescriptionModel

        var backgroundColor = SemanticAppColor.random

        var body: some View {
            ZStack {
                backgroundColor
                VStack {
                    Text("ViewCoverPhoto")
                        .padding()
                        .foregroundColor(.white)
                    Spacer()
                    
                    NavigationLink(destination: PhotoActivityDescriptionView(model: self.model) ) {
                        Text("change coverPhoto")
                    }
                    Spacer()
                }
            }
        }
    }
    
    struct ViewEnd:View {
        
        @Binding var model: CKActivityDescriptionModel
        
        var closeCallback: ()->Void
        
        var backgroundColor = SemanticAppColor.random
        
        var body: some View {
            ZStack {
                backgroundColor
                VStack {
                    Text("ViewEnd")
                        .foregroundColor(.white)
                    Spacer()
                    Text("Bucks value:")
                        .padding()
                        .foregroundColor(.white)
                    TextField("bucks", value: self.$model.bucks, formatter: NumberFormatter())
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            self.closeCallback()
                        }) {
                            Text("DONE !")
                        }.padding()
                    }
                    Spacer()
                }
            }
        }//end body
    }// ViewEnd
    
}//end CKActivityDescriptionDetailEditView

