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
    
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    var model: CKActivityDescriptionModel
    
    @State var coverPhotoImage: Image?
    
    let cardSize: CGFloat = 100
    let showEmoji = false
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
                HStack {
                    Spacer()
                    Text(model.name ?? "~")
                        .lineLimit(3)
                        .modifier(PrimarySmallRegularLabel(color: .white))
                        .padding()
                    Spacer()
                }
                
                if showEmoji {
                    VStack {
                        HStack {
                            Spacer()
                            Text(model.moduleType.emoji)
                            //.padding()
                        }
                        Spacer()
                    }
                    
                }
            }
        }
        //.background(SemanticAppColor.random)
        .cornerRadius(5)
        .shadow(radius: 10)
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
            self.coverPhotoImage =  Image(uiImage: emojiToImage(text: emoji, size:60))
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
    
}//end struct

#if DEBUG
struct CKActivityDescriptionCardView_Previews: PreviewProvider {
    static var previews: some View {
        CKActivityDescriptionCardView( model: CKActivityDescriptionModel.mock)
            .previewLayout(.fixed(width: 200, height: 200))
    }
}
#endif
