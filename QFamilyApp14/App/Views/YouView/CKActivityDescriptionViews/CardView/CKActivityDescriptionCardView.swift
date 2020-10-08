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
    var cardHeight: CGFloat = 100
    
    @State var coverPhotoImage: Image?
    
    let showEmoji = false
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                Rectangle()
                    .fill(SemanticAppColor.random)
                    .cornerRadius(5)
                
                if coverPhotoImage != nil {
                    coverPhotoImage!
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFill()
                        .frame(height: cardHeight)
                        .cornerRadius(5)
                        .padding()
                }
                HStack {
                    Spacer()
                    Text(model.name ?? "~")
                        .lineLimit(3)
                        .modifier(PrimaryBoldLabel(color: .white))
                        .padding()
                    Spacer()
                }
                
                if showEmoji {
                    VStack {
                        HStack {
                            Spacer()
                            Text(model.moduleType.emoji)
                        }
                        Spacer()
                    }
                }
            }
        }
        .cornerRadius(5)
        .shadow(radius: 10)
        .padding()
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
