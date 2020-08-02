//
//  CKChoreItemView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/2/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit

struct CKChoreItemView: View {
    var model: CKChoreModel
    
    var image: Image {
        if let emoji = model.emoji {
            return Image(uiImage: emojiToImage(text: emoji))
        } else {
            return ImageStore.shared.image(name: "turtlerock")
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            image
                .renderingMode(.original)
                .resizable()
                .frame(width: 155, height: 155)
                .cornerRadius(5)
            Text(model.name ?? "~")
                .foregroundColor(.primary)
                .font(.caption)
        }
        .padding(.leading, 15)
    }
}//end CKChoreItemView

struct CKChoreItemView_Previews: PreviewProvider {
    static var previews: some View {
        CKChoreItemView( model: CKChoreModel.mock)
    }
}
