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
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    @EnvironmentObject var activityService: CKPrivateModelService<CKActivityModel>
    
    @State var devMessage: String? = nil
    
    @Binding var model: CKActivityModel
    @Binding var showActivityIndicator: Bool
    @Binding var activityIndicatorMessage: String
    
    @State var drawingState: DrawingState = DrawingState.mock
    
    @State var showDrawingView:Bool = false
    @State var drawingPreview:Image?
    @State var dataMessage:String = "no data"
    
    @State var coverPhotoImage: Image?
    let cardHeight: CGFloat = 200
    
    var body: some View {
        VStack {
            DevMessageView(devMessage: $devMessage)
            
            ZStack {
                if model.activityAsset == nil  {
                    Rectangle()
                        .fill(SemanticAppColor.random)
                        .frame(width: cardHeight, height: cardHeight)
                        //.frame(width: geo.size.width, height: geo.size.height)
                        .onTapGesture {
                            self.showDrawingView.toggle()
                        }
                } else {
                    Rectangle()
                        .fill(SemanticAppColor.random)
                        .frame(width: cardHeight, height: cardHeight)
                        //.frame(width: geo.size.width, height: geo.size.height)
                        .onTapGesture {
                            self.showDrawingView.toggle()
                        }
                }
                
                if coverPhotoImage != nil {
                    coverPhotoImage!
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFill()
                        //.frame(height: cardHeight)
                        .frame(width: cardHeight, height: cardHeight)
                        //.frame(minWidth: cardHeight, maxWidth: .infinity, minHeight: cardHeight, maxHeight: cardHeight)
                        //.cornerRadius(5)
                        .onTapGesture {
                            self.showDrawingView.toggle()
                        }
                }
                
                VStack {
                    Text("DRAWING PREVIEW")
                        .foregroundColor(.white)
                    Text("\(dataMessage)")
                        .foregroundColor(.white)
                    Image(systemName: "paintbrush")
                        .foregroundColor(.white)
                }
            }
        }.onAppear {
            self.loadPreview()
            self.loadCoverImage()
        }
            //.sheet(isPresented: $showDrawingView, onDismiss: loadDrawingState) {
            .sheet(isPresented: $showDrawingView) {
                DrawContainerView(
                    model: self.$model,
                    showActivityIndicator: self.$showActivityIndicator,
                    activityIndicatorMessage: self.$activityIndicatorMessage
                )
                    .environmentObject(self.appState)
                    .environmentObject(self.familyKitAppState)
                    .environmentObject(self.activityService)
        }
    }
    
    func loadPreview() {
        if let activityAsset = model.activityAsset {
            
            // TODO: Move this to the CKActivityModel maybe an extension for the loadDrawData
            if let activityAsset_FileURL = activityAsset.fileURL {
                showActivityIndicator = true
                activityIndicatorMessage = "Loading preview"
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
                    self.dataMessage = "loaded \(drawingState.layers.count) \(drawingState.scribbles.count)"
                    showActivityIndicator = false
                } catch let error {
                    print("failed to decode \(error)")
                    self.dataMessage = "load failed"
                    showActivityIndicator = false
                }
            }
        }
    }
    
    func loadCoverImage() {
        
        if let resultAssetImage = self.model.resultAssetImage, let resultAssetImage_fileURL = resultAssetImage.fileURL {
            do {
                let imageData = try Data(contentsOf: resultAssetImage_fileURL)
                if let loadedUIImage = UIImage(data: imageData) {
                    self.coverPhotoImage = Image(uiImage: loadedUIImage)
                    return
                }
            } catch {
                print("Error loading image : \(error)")
                return
            }
        }
        
        if let coverPhotoAsset = self.model.coverPhoto, let coverPhotoAsset_fileURL = coverPhotoAsset.fileURL {
            do {
                let imageData = try Data(contentsOf: coverPhotoAsset_fileURL)
                if let loadedUIImage = UIImage(data: imageData) {
                    self.coverPhotoImage = Image(uiImage: loadedUIImage)
                    return
                }
            } catch {
                print("Error loading image : \(error)")
                return
            }
        }
        
        if let emoji = self.model.emoji {
            self.coverPhotoImage =  Image(uiImage: emojiToImage(text: emoji, size:60))
        }
        
    }
    
}

struct DrawPreviewView_Previews: PreviewProvider {
    
    static let deviceNames: [String] = [
        "iPhone SE",
        "iPad Pro (11-inch)"
    ]
    
    static var previews: some View {
        Group {
            
            DrawPreviewView (
                model: .constant(CKActivityModel.mock),
                showActivityIndicator: .constant(false),
                activityIndicatorMessage: .constant("some update message")
            )
            
//            ForEach (deviceNames, id:\.self) { deviceName in
//                DrawPreviewView(
//                    model: .constant(CKActivityModel.mock),
//                    showActivityIndicator: .constant(false),
//                    activityIndicatorMessage: .constant("some update message")
//                )
//                    .previewDevice(PreviewDevice(rawValue: deviceName))
//                    .previewDisplayName("\(deviceName)")
//            }
        }
    }
    
}
