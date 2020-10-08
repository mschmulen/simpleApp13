//
//  CKChoreDescriptionNoItemsView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/2/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct CKActivityDescriptionNoItemsView: View {
    
    let cardHeight: CGFloat = 200
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                Rectangle()
                    .foregroundColor(SemanticAppColor.random)
                    .frame(width: cardHeight, height: cardHeight)
                    .cornerRadius(5)
                VStack {
                    Text("No Activities")
                        .foregroundColor(.white)
                        .font(.caption)
                    Text("ask an Adult")
                        .foregroundColor(.white)
                        .font(.caption)
                    Text("to add some")
                        .foregroundColor(.white)
                        .font(.caption)
                }
            }
        }
        .shadow(radius: 10)
        .padding()
    }
}//end CKActivityDescriptionNoItemsView

struct CKActivityDescriptionNoItemsView_Previews: PreviewProvider {
    static var previews: some View {
        CKActivityDescriptionNoItemsView()
    }
}
