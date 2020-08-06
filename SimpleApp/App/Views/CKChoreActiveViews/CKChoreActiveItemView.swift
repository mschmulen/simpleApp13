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
    
    var model: CKChoreActiveModel
    
    // Image(systemName: "rosette")
    @State var coverPhotoImage = ImageStore.shared.image(name: "turtlerock")
    
//    {
//        if let emoji = model.emoji {
//            return Image(uiImage: emojiToImage(text: emoji))
//        } else {
//            return ImageStore.shared.image(name: "turtlerock")
//        }
//    }
    
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
                Text(model.name ?? "~")
                    .foregroundColor(.primary)
                    .font(.caption)
                Spacer()
            }
        }
        .padding(.leading, 15)
        .onAppear {
            
            if let emoji = self.model.emoji {
                self.coverPhotoImage =  Image(uiImage: emojiToImage(text: emoji))
            } else {
                self.coverPhotoImage =  ImageStore.shared.image(name: "turtlerock")
            }
            
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
        CKChoreActiveItemView( model: CKChoreActiveModel.mock)
            .previewLayout(.fixed(width: 300, height: 300))
    }
}
#endif
