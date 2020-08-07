//
//  PhotoActivityView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/4/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit

struct PhotoActivityView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var appState: AppState
    
    @EnvironmentObject var privateActiveChoreService: CKPrivateModelService<CKActivityModel>
    
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
                    //.frame(width: 200)//, height: 200)
                    // .frame(width: 50)
                    .clipped()
            } else {
                Rectangle()
                    .fill(Color.red)
                    //.frame(width: 200, height: 200)
            }
        }
        .frame(width: 300)
        .onTapGesture {
            self.showingImagePicker.toggle()
        }
    }
    
    var body: some View {
        VStack {
            if statusMessage != nil {
                Text(statusMessage!)
            }
            
            if image != nil {
                imageView
            }
            
            Spacer()
            
            if inputImage != nil {
                Button(action: {
                    self.saveImage()
                }) {
                    Text("SAVE IMAGE")
                }
            }
            Spacer()

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
            
            Spacer()

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
        }.onAppear {
            print("onAppear")
            
            // TODO Load the image in the
            self.loadImage()
            
        }
    }//end body
    
    func loadImage() {
        if image == nil {
            if let resultAssetImage = model.resultAssetImage {
                if let resultAssetImage_fileURL = resultAssetImage.fileURL {
                    do {
                        let imageData = try Data(contentsOf: resultAssetImage_fileURL)
                        if let loadedUIImage = UIImage(data: imageData) {
                            image = Image(uiImage: loadedUIImage)
                            return
                        }
                    } catch {
                        print("Error loading image : \(error)")
                    }
                }
            }
        }
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
    
    func saveImage() {
        DispatchQueue.main.async {
            self.statusMessage = "Updating ..."
        }
        
        if let inputImage = inputImage {
            privateActiveChoreService.uploadPhotoAsset(
                model:model,
                image: inputImage,
                assetPropertyName: "resultAssetImage"
            ) { result in
                switch result {
                case .failure( let error):
                    DispatchQueue.main.async {
                        self.statusMessage = "There was an error uploading \(error)"
                    }
                case .success(_):
                    self.model.reload(service: self.privateActiveChoreService)
                    DispatchQueue.main.async {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

