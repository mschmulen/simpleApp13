//
//  FamilyActivityCardView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/13/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation
import SwiftUI
import FamilyKit

struct FamilyActivityCardView: View {
    
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
                    .cornerRadius(5)
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
        }
    }
    
}//end CKChoreItemView

#if DEBUG
struct FamilyActivityCardView_Previews: PreviewProvider {
    static var previews: some View {
        FamilyActivityCardView( model: CKActivityModel.mock)
            .previewLayout(.fixed(width: 200, height: 200))
    }
}
#endif
