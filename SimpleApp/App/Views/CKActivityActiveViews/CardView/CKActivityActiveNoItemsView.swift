//
//  CKActivityDescriptionNoItemsView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/2/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct CKActivityActiveNoItemsView: View {

    let cardSize: CGFloat = 100
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                Rectangle()
                    .foregroundColor(SemanticAppColor.random)
                    .frame(width: cardSize, height: cardSize)
                    .cornerRadius(5)
                VStack {
                    Text("No Activities")
                        .foregroundColor(.white)
                        .font(.body)
                    Text("get busy")
                        .foregroundColor(.white)
                        .font(.body)
                }
            }
        }
        .padding()
    }
}//end CKChoreNoItemsView

struct CKChoreActiveNoItemsView_Previews: PreviewProvider {
    static var previews: some View {
        CKActivityActiveNoItemsView()
        .previewLayout(.fixed(width: 200, height: 200))
    }
}
