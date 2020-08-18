//
//  PhotoActivityView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/4/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit
import AVFoundation



extension Player {
    
    public func isOwnerOrEmpty(model: CKActivityModel) ->Bool {
        guard let myReference = self.recordReference else {
            return false
        }
        guard let modelReference = model.kidReference else {
            return true
        }
        
        if modelReference == myReference {
            return true
        } else {
            return false
        }
    }
        
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
    
    @State var devMessage: String?
    
    var imageView: some View {
        VStack {
            GeometryReader { geo in
                if self.image != nil {
                    self.image!
                        .resizable()
                        .scaledToFit()
//                        .aspectRatio(contentMode: .fit)
                        .frame(width: geo.size.width, height:geo.size.width)
                        .clipped()
                        .onTapGesture {
                            if self.familyKitAppState.currentPlayer.isOwnerOrEmpty(model: self.model) {
                                self.showingImagePicker.toggle()
                            }
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
        .frame(width: 300, height: 300)
        
        // .frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.height * 0.2)

    }
    
    var body: some View {
        VStack {
            DevMessageView(devMessage: $devMessage)
            imageView
        }.onAppear {
            print("onAppear")
            self.loadImage()
        }.sheet(isPresented: $showingImagePicker, onDismiss: dismissFromImagePicker) {
            #if targetEnvironment(simulator)
            ImagePickerRepresentable(image: self.$inputImage, imageSourceType: .photoLibrary)
            #else
            ImagePickerRepresentable(image: self.$inputImage, imageSourceType: .camera)
            #endif
        }
    }//end body
    
    func dismissFromImagePicker() {
        loadImage()
        DispatchQueue.main.async {
            self.saveImage()
        }
    }
    
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
        guard let inputImage = inputImage else {
            return
        }
        image = Image(uiImage: inputImage)
    }
    
    func saveImage() {
        DispatchQueue.main.async {
            self.devMessage = "Updating ..."
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
                        self.devMessage = "There was an error uploading \(error)"
                    }
                case .success(let updatedModel):
                    DispatchQueue.main.async {
                        if let resultAssetImage = updatedModel.resultAssetImage {
                            self.model.changeResultAssetImage(asset: resultAssetImage)
                        }
                        self.presentationMode.wrappedValue.dismiss()
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

