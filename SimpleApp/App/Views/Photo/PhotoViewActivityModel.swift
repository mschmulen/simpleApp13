//
//  PhotoViewActivityModelView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/4/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit

struct PhotoActivityModelView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var appState: AppState
    
    @EnvironmentObject var privateChoreService: CKPrivateModelService<CKActivityDescriptionModel>
    
    @Binding var model: CKActivityModel
    
    @State private var showingCameraView = false
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    
    @State private var image: Image?
    
    @State private var statusMessage: String?
    
    var imageView: some View {
        Group {
            if image != nil {
                image!
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    //.aspectRatio(contentMode: .fill)
                .frame(width: 200)//, height: 200)
                    // .frame(width: 50)
                .clipped()
            } else {
                Rectangle()
                .fill(Color.red)
                .frame(width: 200, height: 200)
            }
        }
        .frame(width: 280, height: 200)
            .onTapGesture {
                self.showingImagePicker.toggle()
        }

    }
    
    var body: some View {
        VStack {
            
            if statusMessage != nil {
                Text(statusMessage!)
            }
            
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("CANCEL")
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
                        Text("PICK IMAGE")
                    }
                }.sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                    ImagePicker(image: self.$inputImage)
                }
            }
            
            if inputImage == nil {
                Group {
                    Button(action: {
                        // TODO: Camera photo
                        self.showingCameraView.toggle()
                    }) {
                        HStack {
                            Image(systemName: "camera")
                            Text("Camera photo")
                        }
                    }
                }.sheet(isPresented: $showingCameraView, content: {
                    CameraView(isShown: self.$showingCameraView, image: self.$image)
                })
            }
            
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
        
        // TODO: Save image
//        if let inputImage = inputImage {
//            privateChoreService.updateCoverPhoto(model:model, image: inputImage) { result in
//                switch result {
//                case .failure( let error):
//                    DispatchQueue.main.async {
//                        self.statusMessage = "There was an error uploading \(error)"
//                    }
//                case .success(_):
//                    self.model.reload(service: self.privateChoreService)
//                    DispatchQueue.main.async {
//                        self.presentationMode.wrappedValue.dismiss()
//                    }
//                }
//            }
//        }
    }
}

