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
    
    let cardSize: CGFloat = 100
    
    var body: some View {
        
        VStack(alignment: .leading) {
            ZStack {
                
                Rectangle()
                    .fill(SemanticAppColor.random)
                    .frame(width: cardSize, height: cardSize)
                    .cornerRadius(5)
                    
                if coverPhotoImage != nil {
                    coverPhotoImage!
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFill()
                        .frame(width: cardSize, height: cardSize)
                        .cornerRadius(5)
                } else {
                    Rectangle()
                        .fill(SemanticAppColor.random)
                        .frame(width: cardSize, height: cardSize)
                        .cornerRadius(5)
                }
                VStack {
                    if model.kidReference != nil {
                        Text("\(familyKitAppState.findPlayerModelForRecord(recordReference: model.kidReference!)?.name ?? "~")")
                            .lineLimit(1)
                            .modifier(PrimarySmallBoldLabel(color: .white))
                            .padding()
                    }
                    Text(model.title ?? "~")
                        .lineLimit(3)
                        .modifier(PrimarySmallRegularLabel(color: .white))
                        .padding()
                }
                
                VStack {
                    HStack {
                        Spacer()
                        Text(model.moduleType.emoji)
                    }
                    Spacer()
                }
            }
        }
        .cornerRadius(5)
        .shadow(radius: 10)
        .padding()
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
            self.coverPhotoImage =  Image(uiImage: emojiToImage(text: emoji, size:60))
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
