//
//  CKChoreDescriptionItemView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/2/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit

struct CKActivityActiveItemView: View {
    
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    var model: CKActivityModel
    
    @State var coverPhotoImage: Image?
    
    var body: some View {
        
        VStack(alignment: .leading) {
            ZStack {
                
                if coverPhotoImage != nil {
                    coverPhotoImage!
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .cornerRadius(5)
                } else {
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: 100, height: 100)
                        .cornerRadius(5)
                }
                VStack {
                    if model.kidReference != nil {
                        Text("\(familyKitAppState.findPlayerModelForRecord(recordReference: model.kidReference!)?.name ?? "~")")
                            .lineLimit(1)
                            .font(.system(size: 13, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .padding()
                    }
                    Text(model.title ?? "~")
                        .lineLimit(3)
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(.white)
                        .padding()
                }
            }
        }
        .padding(.leading, 15)
        .onAppear {
            self.loadCoverImage()
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
            self.coverPhotoImage =  Image(uiImage: emojiToImage(text: emoji, backgroundColor: UIColor.gray))
        }
        
    }
    
}//end CKActivityItemView

#if DEBUG
struct CKActivityActiveItemView_Previews: PreviewProvider {
    static var previews: some View {
        CKActivityActiveItemView( model: CKActivityModel.mock)
            .previewLayout(.fixed(width: 200, height: 200))
    }
}
#endif
