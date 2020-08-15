//
//  CKActivityDescriptionItemView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/2/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit

struct CKActivityDescriptionItemView: View {
    
    var model: CKActivityDescriptionModel
    
    // Image(systemName: "rosette")
    @State var coverPhotoImage:Image? = ImageStore.shared.image(name: "turtlerock")
    
    var body: some View {
        VStack(alignment: .leading) {
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
        
        self.model.loadCoverPhoto { (result) in
            switch result {
            case .failure(let error):
                print( "CKChoreDescriptionItemView failure \(error)")
            case .success(let image):
                self.coverPhotoImage = Image(uiImage:image )
            }
        }
    }
    
}//end CKChoreItemView

#if DEBUG
struct CKChoreItemView_Previews: PreviewProvider {
    static var previews: some View {
        CKActivityDescriptionItemView( model: CKActivityDescriptionModel.mock)
            .previewLayout(.fixed(width: 200, height: 200))
    }
}
#endif
