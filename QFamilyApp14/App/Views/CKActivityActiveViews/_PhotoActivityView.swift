//
//  PhotoActivityView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/4/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

/*
import SwiftUI
import FamilyKit
import AVFoundation

struct PhotoActivitySubView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var activityService: CKPrivateModelService<CKActivityModel>
    
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
                            if self.familyKitAppState.isCurrentPlayerOwnerOrEmpty(model: self.model) {
                                self.showingImagePicker.toggle()
                            }
                    }
                } else {
                    ZStack {
                        Rectangle()
                            .fill(SemanticAppColor.random)
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
            
            // automatically push to status .completed
            self.model.changeStatus(status: .completed)
            
            activityService.pushUpdateCreate(model: model) { (result) in
                switch result {
                case .success( let resultModel):
                    self.activityService.uploadPhotoAsset(
                        model:resultModel,
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
                case .failure(let error):
                    print( "PhotoActivityView.error: \(error)")
                    DispatchQueue.main.async {
                        self.devMessage = "There was an error updating \(error)"
                    }
                }
            }
        }
    }
}

struct PhotoActivityView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PhotoActivitySubView(
                model: .constant(CKActivityModel.mock)
            )
            PhotoActivitySubView(
                model: .constant(CKActivityModel.mock)
            )
        }
    }
}

*/

