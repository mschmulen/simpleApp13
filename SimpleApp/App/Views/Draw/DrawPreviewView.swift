//
//  DrawPreviewView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/27/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import DrawingKit
import FamilyKit

struct DrawPreviewView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    @EnvironmentObject var activityService: CKPrivateModelService<CKActivityModel>
    
    @State var devMessage: String? = nil
    
    @Binding var model: CKActivityModel
    @Binding var showActivityIndicator: Bool
    @Binding var activityIndicatorMessage: String
    
    @State var drawingState:DrawingState = DrawingState.mock
    
    @State var showDrawingView:Bool = false
    @State var drawingPreview:Image?
    
    var body: some View {
        VStack {
            DevMessageView(devMessage: $devMessage)
            
            ZStack {
                Rectangle()
                    .fill(SemanticAppColor.random)
                    .frame(width: 200, height: 200)
                    //.frame(width: geo.size.width, height: geo.size.height)
                    .onTapGesture {
                        self.showDrawingView.toggle()
                }
                VStack {
                    Text("DRAWING PREVIEW")
                        .foregroundColor(.white)
                    Text("TODO")
                        .foregroundColor(.white)
                    Image(systemName: "paintbrush")
                        .foregroundColor(.white)
                }
            }
        }.onAppear {
            self.loadPreview()
        }
        //.sheet(isPresented: $showDrawingView, onDismiss: loadDrawingState) {
        .sheet(isPresented: $showDrawingView) {
            DrawView(
                model: self.$model,
                showActivityIndicator: self.$showActivityIndicator,
                activityIndicatorMessage: self.$activityIndicatorMessage
            )
                .environmentObject(self.familyKitAppState)
                .environmentObject(self.activityService)
        }
    }
    
    func loadPreview() {
        if let activityAsset = model.activityAsset {
            if let activityAsset_FileURL = activityAsset.fileURL {
                showActivityIndicator = true
                activityIndicatorMessage = "loading drawing"
                // print( "activityAsset_FileURL \(activityAsset_FileURL)")
                guard let data = try? Data(contentsOf: activityAsset_FileURL) else {
                    self.devMessage = "Failed to load \(activityAsset_FileURL) "
                    showActivityIndicator = false
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
                    showActivityIndicator = false
                } catch let error {
                    self.devMessage = "failed to decode \(error)"
                    showActivityIndicator = false
                }
            }
        }
    }
    
//    func saveCallback( updatedDrawingState:DrawingState, screenShot:UIImage?) {
//        self.devMessage = "saving DrawingState"
//
//        showActivityIndicator = true
//        activityIndicatorMessage = "saving drawing"
//        do {
//            let encoder = JSONEncoder()
//            let data = try encoder.encode(updatedDrawingState)
//
//            // let string = String(data:data, encoding: .utf8)
//            // print( "saveCallback data string \(string)")
//
//            let fileNamePrefix = "updatedDrawingState"
//            let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//            var localFileURL = documentPath.appendingPathComponent(fileNamePrefix)
//            localFileURL.appendPathExtension("json")
//
//            // print( "localFile URL \(localFileURL)")
//            // let data = try JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted])
//            try data.write(to: localFileURL, options: [.atomicWrite])
//
//            // automatically push to status .completed
//            self.model.status = .completed
//
//            activityService.pushUpdateCreate(model: model) { (result) in
//                switch result {
//                case .success( let resultModel):
//                    self.activityService.uploadFileAsset(
//                        model: resultModel,
//                        fileURL: localFileURL,
//                        assetPropertyName: "activityAsset"
//                    ) { (result) in
//                        switch result {
//                        case .failure(let error):
//                            self.devMessage = "upload failure \(error)"
//                             self.showActivityIndicator = false
//                        case .success(_):
//                            self.devMessage = "upload success"
//                             self.showActivityIndicator = false
//                        }
//                    }
//                case .failure(let error):
//                    print( "error \(error)")
//                    self.showActivityIndicator = false
//                }
//            }
//
//        } catch let error {
//            self.devMessage = "error \(error)"
//            self.showActivityIndicator = false
//        }
//
//        if let screenShot = screenShot {
//            saveScreenShot(screenShot: screenShot)
//        }
//    }
    
//    func saveScreenShot(screenShot:UIImage) {
//
//        // TODO: Fix saveScreenShot so the cover image shows a thumbnail of the drawing
//
//        activityService.uploadPhotoAsset(
//            model:model,
//            image: screenShot,
//            assetPropertyName: "coverPhoto"
//        ) { result in
//            switch result {
//            case .failure( let error):
//                print( "uploadFileAsset error \(error)")
//                //                    DispatchQueue.main.async {
//                //                        self.statusMessage = "There was an error uploading \(error)"
//            //                    }
//            case .success(_):
//                print( "upload success")
//                //                    self.statusMessage = "Reloading ..."
//                //                    self.privateActiveChoreService.fetchSingle( model: self.model) { result in
//                //                        print( "result")
//                //                        DispatchQueue.main.async {
//                //                            self.presentationMode.wrappedValue.dismiss()
//                //                        }
//                //                    }
//            }
//        }
//    }
    
}

struct DrawPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        DrawPreviewView(
            model: .constant(CKActivityModel.mock),
            showActivityIndicator: .constant(false),
            activityIndicatorMessage: .constant("some update message")
        )
    }
}
