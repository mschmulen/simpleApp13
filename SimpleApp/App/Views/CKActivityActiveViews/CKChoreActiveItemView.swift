//
//  CKChoreDescriptionItemView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/2/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit

struct CKChoreActiveItemView: View {
    
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    var model: CKActivityModel
    
    @State var coverPhotoImage = ImageStore.shared.image(name: "turtlerock")
    
    var body: some View {
        
        VStack(alignment: .leading) {
            ZStack {
                coverPhotoImage
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .cornerRadius(5)
                // TODO: make a fancy ztack for this cover photo thing
//                if model.kidReference != nil {
//                    Text("\(familyKitAppState.findUserForRecord(recordReference: model.kidReference!)?.name ?? "~")")
//                }
            }
            HStack {
                Spacer()
                VStack {
                    if model.kidReference != nil {
                        Text("\(familyKitAppState.findUserForRecord(recordReference: model.kidReference!)?.name ?? "~")")
                    }
                    Text(model.title ?? "~")
                        .foregroundColor(.primary)
                        .font(.caption)
                }
                Spacer()
            }
            
        }
        .padding(.leading, 15)
        .onAppear {
            
            if let resultAssetImage = self.model.resultAssetImage, let resultAssetImage_fileURL = resultAssetImage.fileURL {
                do {
                    let imageData = try Data(contentsOf: resultAssetImage_fileURL)
                    if let loadedUIImage = UIImage(data: imageData) {
                        self.coverPhotoImage = Image(uiImage: loadedUIImage)
                        return
                    }
                } catch {
                    print("Error loading image : \(error)")
                }
            } else {
                
                if let coverPhotoAsset = self.model.coverPhoto, let coverPhotoAsset_fileURL = coverPhotoAsset.fileURL {
                    do {
                        let imageData = try Data(contentsOf: coverPhotoAsset_fileURL)
                        if let loadedUIImage = UIImage(data: imageData) {
                            self.coverPhotoImage = Image(uiImage: loadedUIImage)
                            return
                        }
                    } catch {
                        print("Error loading image : \(error)")
                    }
                } else {
                    if let emoji = self.model.emoji {
                        self.coverPhotoImage =  Image(uiImage: emojiToImage(text: emoji))
                    } else {
                        self.coverPhotoImage =  ImageStore.shared.image(name: "turtlerock")
                    }
                }
            }
            
            
            //            if let emoji = self.model.emoji {
            //                self.coverPhotoImage =  Image(uiImage: emojiToImage(text: emoji))
            //            } else {
            //                self.coverPhotoImage =  ImageStore.shared.image(name: "turtlerock")
            //            }
                        
            //            if let coverPhotoAsset = self.model.coverPhoto, let coverPhotoAsset_fileURL = coverPhotoAsset.fileURL {
            //                do {
            //                    let imageData = try Data(contentsOf: coverPhotoAsset_fileURL)
            //                    if let loadedUIImage = UIImage(data: imageData) {
            //                        self.coverPhotoImage = Image(uiImage: loadedUIImage)
            //                        return
            //                    }
            //                } catch {
            //                    print("Error loading image : \(error)")
            //                }
            //            } else
            //            {
            //                if let resultAssetImage = self.model.resultAssetImage, let resultAssetImage_fileURL = resultAssetImage.fileURL {
            //                    do {
            //                        let imageData = try Data(contentsOf: resultAssetImage_fileURL)
            //                        if let loadedUIImage = UIImage(data: imageData) {
            //                            self.coverPhotoImage = Image(uiImage: loadedUIImage)
            //                            return
            //                        }
            //                    } catch {
            //                        print("Error loading image : \(error)")
            //                    }
            //                }
            //            }
            
            
            // TODO: Load the reference stuff
//            if let emoji = self.model.emoji {
//                self.coverPhotoImage =  Image(uiImage: emojiToImage(text: emoji))
//            } else {
//            }
            
            // TODO: CKChoreActiveModel load cover photo
//            self.model.loadCoverPhoto { (result) in
//                switch result {
//                case .failure(let error):
//                    print( "failure \(error)")
//                case .success(let image):
//                    self.coverPhotoImage = Image(uiImage:image )
//                }
//            }
        }
    }
    
}//end CKChoreItemView

#if DEBUG
struct CKChoreActiveItemView_Previews: PreviewProvider {
    static var previews: some View {
        CKChoreActiveItemView( model: CKActivityModel.mock)
            .previewLayout(.fixed(width: 200, height: 200))
    }
}
#endif
