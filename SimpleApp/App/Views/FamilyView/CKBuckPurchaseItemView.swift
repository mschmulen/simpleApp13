//
//  CKBuckPurchaseItemView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 9/15/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit

struct CKBuckPurchaseItemView: View {
    
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    var model: CKStoreItemPurchaseModel
    
    @State var coverPhotoImage: Image?
    
    let cardSize: CGFloat = 100
    
    var body: some View {
        
        VStack(alignment: .leading) {
            ZStack {
                
                Rectangle()
                    .fill(SemanticAppColor.random)
                    .frame(width: cardSize, height: cardSize)
                    .cornerRadius(5)

                VStack {
//                    if model.purchasingPlayerReference != nil {
//                        Text("\(familyKitAppState.findPlayerModelForRecord(recordReference: model.kidReference!)?.name ?? "~")")
//                            .lineLimit(1)
//                            .modifier(PrimarySmallBoldLabel(color: .white))
//                            .padding()
//                    }
                    Text(model.title ?? "~")
                        .lineLimit(3)
                        .modifier(PrimarySmallRegularLabel(color: .white))
                        .padding()
                }
                
//                VStack {
//                    HStack {
//                        Spacer()
//                        Text(model.moduleType.emoji)
//                    }
//                    Spacer()
//                }
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
        
//        if let resultAssetImage = self.model.resultAssetImage, let resultAssetImage_fileURL = resultAssetImage.fileURL {
//            do {
//                let imageData = try Data(contentsOf: resultAssetImage_fileURL)
//                if let loadedUIImage = UIImage(data: imageData) {
//                    self.coverPhotoImage = Image(uiImage: loadedUIImage)
//                    return
//                }
//            } catch {
//                print("Error loading image : \(error)")
//                return
//            }
//        }
//
//        if let coverPhotoAsset = self.model.coverPhoto, let coverPhotoAsset_fileURL = coverPhotoAsset.fileURL {
//            do {
//                let imageData = try Data(contentsOf: coverPhotoAsset_fileURL)
//                if let loadedUIImage = UIImage(data: imageData) {
//                    self.coverPhotoImage = Image(uiImage: loadedUIImage)
//                    return
//                }
//            } catch {
//                print("Error loading image : \(error)")
//                return
//            }
//        }
//
//        if let emoji = self.model.emoji {
//            self.coverPhotoImage =  Image(uiImage: emojiToImage(text: emoji, size:60))
//        }
        
    }
    
}//end CKActivityItemView

#if DEBUG
struct CKBuckPurchaseItemView_Previews: PreviewProvider {
    static var previews: some View {
        CKBuckPurchaseItemView( model: CKStoreItemPurchaseModel.mock)
            .previewLayout(.fixed(width: 200, height: 200))
    }
}
#endif
