//
//  CKActivityDescriptionCardView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/2/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit

struct CKActivityDescriptionCardView: View {
    
    var model: CKActivityDescriptionModel
    
    // Image(systemName: "rosette")
    @State var coverPhotoImage:Image? = ImageStore.shared.image(name: "turtlerock")
    
    let cardSize: CGFloat = 100
    
    var body: some View {
        VStack(alignment: .leading) {
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
                //.border(Color.blue, width: 2)
                .cornerRadius(5)
            }
            HStack {
                Spacer()
                Text(model.name ?? "~")
                    .foregroundColor(.primary)
                    .font(.caption)
                Spacer()
            }
        }
        .padding()
        
//            .overlay(
//            RoundedRectangle(cornerRadius: 25)
//                .stroke(Color.white, lineWidth: 2)
        .onAppear {
            
            self.loadCoverPhoto()
        }
    }
    
    func loadCoverPhoto() {
        if let emoji = self.model.emoji {
            self.coverPhotoImage =  Image(uiImage: emojiToImage(text: emoji))
        } else {
            self.coverPhotoImage =  ImageStore.shared.image(name: "turtlerock")
        }
        
        if self.model.coverPhoto != nil {
            self.model.loadCoverPhoto { (result) in
                switch result {
                case .failure(let error):
                    print( "CKActivityDescriptionCardView.loadCoverPhoto failure \(error)")
                case .success(let image):
                    self.coverPhotoImage = Image(uiImage:image )
                }
            }
        }
    }
    
}//end CKChoreItemView

#if DEBUG
struct CKChoreItemView_Previews: PreviewProvider {
    static var previews: some View {
        CKActivityDescriptionCardView( model: CKActivityDescriptionModel.mock)
            .previewLayout(.fixed(width: 200, height: 200))
    }
}
#endif
