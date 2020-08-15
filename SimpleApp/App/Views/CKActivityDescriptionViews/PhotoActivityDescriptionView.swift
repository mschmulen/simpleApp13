//
//  PhotoActivityDescriptionView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/4/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit




struct PhotoActivityDescriptionView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var appState: AppState
    
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    @EnvironmentObject var privateChoreService: CKPrivateModelService<CKActivityDescriptionModel>
    @EnvironmentObject var chatService: ChatService
    
    var model: CKActivityDescriptionModel
    
    @State private var showingCameraView = false
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    
    @State private var image: Image?
    
    @State private var statusMessage: String?
    
    var imageView: some View {
        VStack {
            GeometryReader { geo in
                if self.image != nil {
                    self.image!
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geo.size.width)
                        .clipped()
                        .onTapGesture {
                            self.showingImagePicker.toggle()
                    }
                } else {
                    ZStack {
                        Rectangle()
                            .fill(Color.gray)
                            .frame(width: geo.size.width, height: geo.size.height)
                            .onTapGesture {
                                self.showingImagePicker.toggle()
                        }
                        Image(systemName: "camera")
                    }
                }
            }
        }
        .frame(width: 300, height: 200)
    }
    
    var body: some View {
        VStack {
            
            if statusMessage != nil {
                Text(statusMessage!)
            }
            
            imageView
            
            if inputImage != nil {
                Button(action: {
                    self.saveImage()
                }) {
                    Text("SAVE IMAGE")
                }
            }
                
            if inputImage == nil {
                Group {
                    Button(action: {
                        self.showingImagePicker.toggle()
                    }) {
                        HStack {
                            Text("PICK IMAGE")
                            Image(systemName: "camera")
                        }
                    }
                }.sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                    ImagePickerRepresentable(image: self.$inputImage)
                }
            }
            
            // TODO: Fix the camera live photo
//            if inputImage == nil {
//                Group {
//                    Button(action: {
//                        // TODO: Camera photo
//                        self.showingCameraView.toggle()
//                    }) {
//                        HStack {
//                            Image(systemName: "camera")
//                            Text("Camera photo")
//                        }
//                    }
//                }.sheet(isPresented: $showingCameraView, content: {
//                    CameraView(isShown: self.$showingCameraView, image: self.$image)
//                })
//            }
            
        }
    }//end body
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
    
    func saveImage() {
        DispatchQueue.main.async {
            self.statusMessage = "Updating ..."
        }
        
        if let inputImage = inputImage {
            privateChoreService.uploadPhotoAsset(
            model:model,
            image: inputImage,
            assetPropertyName: "coverPhoto"
            ) { result in
                switch result {
                case .failure( let error):
                    DispatchQueue.main.async {
                        self.statusMessage = "There was an error uploading \(error)"
                    }
                case .success(_):
                    self.privateChoreService.fetchSingle( model: self.model) { result in
                        DispatchQueue.main.async {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
        }
    }
}
