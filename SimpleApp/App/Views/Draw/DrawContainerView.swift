//
//  DrawView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/4/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import DrawingKit
import FamilyKit

struct DrawContainerView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var activityService: CKPrivateModelService<CKActivityModel>
    
    @State var devMessage: String? = nil
    
    @Binding var model: CKActivityModel
    @Binding var showActivityIndicator: Bool
    @Binding var activityIndicatorMessage: String
    
    @State var drawingState:DrawingState = DrawingState.mock
    
    var body: some View {
        VStack {
            DevMessageView(devMessage: $devMessage)
            DrawingView(
                drawingState: $drawingState,
                isReadOnly: !familyKitAppState.isCurrentPlayerOwnerOrEmpty(model: model),
                saveCallback: saveCallback
            ).allowsHitTesting(familyKitAppState.isCurrentPlayerOwnerOrEmpty(model: model))
        }.onAppear {
            self.loadDrawingState()
        }
    }
    
    func loadDrawingState() {
        if let activityAsset = model.activityAsset {
            self.showActivityIndicator = true
            self.activityIndicatorMessage = "Loading"
            
            if let activityAsset_FileURL = activityAsset.fileURL {
                // print( "activityAsset_FileURL \(activityAsset_FileURL)")
                guard let data = try? Data(contentsOf: activityAsset_FileURL) else {
                    self.devMessage = "Failed to load \(activityAsset_FileURL) "
                    return
                }
                
                //let string = String(data:data, encoding: .utf8)
                //print( "loadDrawingState. data string \(string)")
                
                let decoder = JSONDecoder()
                // decoder.dateDecodingStrategy = dateDecodingStrategy
                // decoder.keyDecodingStrategy = keyDecodingStrategy
                
                do {
                    let decodedDrawingState = try decoder.decode(DrawingState.self, from: data)
                    drawingState = decodedDrawingState
                    //self.devMessage = "success in decodedDrawingState \(drawingState.layers.count) \(drawingState.scribbles.count)"
                } catch let error {
                    self.devMessage = "failed to decode \(error)"
                }
            }
            self.showActivityIndicator = false
        }
    }
    
    func saveCallback(
        updatedDrawingState: DrawingState,
        screenShot: UIImage?
    ) {
        
        do {
            
            // TODO: Move this to the Model code via extension
            let encoder = JSONEncoder()
            let data = try encoder.encode(updatedDrawingState)
            
            // let string = String(data:data, encoding: .utf8)
            // print( "saveCallback data string \(string)")
            
            let fileNamePrefix = "updatedDrawingState"
            let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            var localFileURL = documentPath.appendingPathComponent(fileNamePrefix)
            localFileURL.appendPathExtension("json")
            
            // print( "localFile URL \(localFileURL)")
            // let data = try JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted])
            try data.write(to: localFileURL, options: [.atomicWrite])
            
            // automatically push to status .completed
            self.model.status = .completed
            
            self.showActivityIndicator = true
            self.activityIndicatorMessage  = "Saving drawing"
            self.activityService.uploadFileAsset(
                model: self.model,
                fileURL: localFileURL,
                assetPropertyName: "activityAsset"
            ) { (result) in
                switch result {
                case .failure(let error):
                    self.devMessage = "upload failure \(error)"
                    self.showActivityIndicator = false
                case .success(let updatedModel):
                    DispatchQueue.main.async {
                        self.showActivityIndicator = false
                        if let activityAsset = updatedModel.activityAsset {
                            self.model.activityAsset = activityAsset
                        }
                        //self.presentationMode.wrappedValue.dismiss()
                        self.appState.goToScreen(deepLink: .tabFamily)
                    }
                }
            }
        } catch let error {
            self.devMessage = "error \(error)"
            self.showActivityIndicator = false
        }
        
        if let screenShot = screenShot {
            saveScreenShot(screenShot: screenShot)
        }
    }
    
    func saveScreenShot(screenShot:UIImage) {
        
        // TODO: Fix saveScreenShot so the cover image shows a thumbnail of the drawing
        
        activityService.uploadPhotoAsset(
            model:model,
            image: screenShot,
            assetPropertyName: "coverPhoto"
        ) { result in
            switch result {
            case .failure( let error):
                print( "uploadFileAsset error \(error)")
                //                    DispatchQueue.main.async {
                //                        self.statusMessage = "There was an error uploading \(error)"
            //                    }
            case .success(_):
                print( "upload success")
                //                    self.statusMessage = "Reloading ..."
                //                    self.privateActiveChoreService.fetchSingle( model: self.model) { result in
                //                        print( "result")
                //                        DispatchQueue.main.async {
                //                            self.presentationMode.wrappedValue.dismiss()
                //                        }
                //                    }
            }
        }
        
    }
    
}

struct DrawView_Previews: PreviewProvider {
    
    static let deviceNames: [String] = [
        "iPhone SE",
        "iPad Pro (11-inch)"
    ]
    
    static var previews: some View {
        Group {
            
            //            ForEach (deviceNames, id:\.self) { deviceName in
            //                DrawContainerView(
            //                    model: .constant(CKActivityModel.mock),
            //                    showActivityIndicator: .constant(false),
            //                    activityIndicatorMessage: .constant("some update message")
            //                )
            //                    .previewDevice(PreviewDevice(rawValue: deviceName))
            //                    .previewDisplayName("\(deviceName)")
            //            }
            
            DrawContainerView(
                model: .constant(CKActivityModel.mock),
                showActivityIndicator: .constant(false),
                activityIndicatorMessage: .constant("some update message")
            )
        }
    }
    
}
