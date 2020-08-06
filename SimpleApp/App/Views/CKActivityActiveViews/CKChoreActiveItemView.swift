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
    
    var model: CKActivityModel
    
    @State var coverPhotoImage = ImageStore.shared.image(name: "turtlerock")
    
    var body: some View {
        VStack(alignment: .leading) {
            coverPhotoImage
                .renderingMode(.original)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .cornerRadius(5)
            HStack {
                Spacer()
                Text(model.title ?? "~")
                    .foregroundColor(.primary)
                    .font(.caption)
                Spacer()
            }
        }
        .padding(.leading, 15)
        .onAppear {
            
            if let resultAssetImage = self.model.resultAssetImage {
                if let resultAssetImage_fileURL = resultAssetImage.fileURL {
                    do {
                        let imageData = try Data(contentsOf: resultAssetImage_fileURL)
                        if let loadedUIImage = UIImage(data: imageData) {
                            self.coverPhotoImage = Image(uiImage: loadedUIImage)
                            return
                        }
                    } catch {
                        print("Error loading image : \(error)")
                    }
                }
            }
            
            self.coverPhotoImage =  ImageStore.shared.image(name: "turtlerock")
            
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
            .previewLayout(.fixed(width: 300, height: 300))
    }
}
#endif
