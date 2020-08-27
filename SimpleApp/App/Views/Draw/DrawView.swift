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

struct DrawView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var activityService: CKPrivateModelService<CKActivityModel>
    
    @State var devMessage: String? = nil
    
    @Binding var model: CKActivityModel
    @State var drawingState:DrawingState = DrawingState.mock
    
    var body: some View {
        VStack {
            DevMessageView(devMessage: $devMessage)
            DrawingView(
                drawingState: $drawingState,
                 isReadOnly: !familyKitAppState.isCurrentPlayerOwnerOrEmpty(model: model),
                saveCallback: saveCallback
            )
        }.onAppear {
            self.loadDrawingState()
        }
    }
    
    func loadDrawingState() {
        if let activityAsset = model.activityAsset {
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
                    self.devMessage = "success in decodedDrawingState \(drawingState.layers.count) \(drawingState.scribbles.count)"
                } catch let error {
                    self.devMessage = "failed to decode \(error)"
                }
            }
        }
    }
    
    func saveCallback( updatedDrawingState:DrawingState, screenShot:UIImage?) {
        self.devMessage = "saving DrawingState"
        
        do {
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
            self.model.changeStatus(status: .completed)
            
            activityService.pushUpdateCreate(model: model) { (result) in
                switch result {
                case .success( let resultModel):
                    self.activityService.uploadFileAsset(
                        model: resultModel,
                        fileURL: localFileURL,
                        assetPropertyName: "activityAsset"
                    ) { (result) in
                        switch result {
                        case .failure(let error):
                            self.devMessage = "upload failure \(error)"
                        case .success(_):
                            self.devMessage = "upload success"
                        }
                    }
                case .failure(let error):
                    print( "error \(error)")
                }
            }
            
        } catch let error {
            self.devMessage = "error \(error)"
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
    static var previews: some View {
        DrawView(
            model: .constant(CKActivityModel.mock)
        )
    }
}
