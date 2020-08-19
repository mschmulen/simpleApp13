//
//  CKChoreDescriptionNoItemsView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/2/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct CKActivityDescriptionNoItemsView: View {
    
    let cardSize: CGFloat = 100
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                Rectangle()
                    .foregroundColor(.gray)
                    .frame(width: cardSize, height: cardSize)
                    .cornerRadius(5)
                VStack {
                    Text("No Activities")
                        .foregroundColor(.white)
                        .font(.body)
                    Text("ask an Adult")
                        .foregroundColor(.white)
                        .font(.body)
                    Text("to add some")
                        .foregroundColor(.white)
                        .font(.body)
                }
            }
        }
        .padding(.leading, 15)
    }
}//end CKActivityDescriptionNoItemsView

struct CKActivityDescriptionNoItemsView_Previews: PreviewProvider {
    static var previews: some View {
        CKActivityDescriptionNoItemsView()
    }
}
