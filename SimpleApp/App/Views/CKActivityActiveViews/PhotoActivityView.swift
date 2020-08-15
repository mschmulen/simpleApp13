//
//  PhotoActivityView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/4/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit
import CameraView
import AVFoundation

extension Player {
    
    public func isOwner(model: CKActivityModel) ->Bool {
        guard let myReference = self.recordReference else {
            return false
        }
        guard let modelReference = model.kidReference else {
            return false
        }
        
        if modelReference == myReference {
            return true
        } else {
            return false
        }
    }
}

struct PhotoActivityView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var privateActiveChoreService: CKPrivateModelService<CKActivityModel>
    
    @Binding var model: CKActivityModel
    
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
                            .border(Color.gray)
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
            
            Spacer()
            
            if inputImage != nil && model.recordID != nil && familyKitAppState.currentPlayer.isOwner(model: model) {
                Button(action: {
                    self.saveImage()
                }) {
                    Text("SAVE IMAGE")
                }
            }
            
            Spacer()
            
            if inputImage == nil && familyKitAppState.currentPlayer.isOwner(model: model) {
                Group {
                    Button(action: {
                        self.showingImagePicker.toggle()
                    }) {
                        HStack {
                            Text("PICK IMAGE")
                            //Image(systemName: "camera")
                        }
                    }
                }.sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                    ImagePickerRepresentable(image: self.$inputImage)
                }
            }
            
            Spacer()
            
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
                    self.statusMessage = "Reloading ..."
                    self.privateActiveChoreService.fetchSingle( model: self.model) { result in
                        print( "result")
                        DispatchQueue.main.async {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
        }
    }
}

struct PhotoActivityView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PhotoActivityView(
                model: .constant(CKActivityModel.mock)
            )
            PhotoActivityView(
                model: .constant(CKActivityModel.mock)
            )
        }
    }
}

