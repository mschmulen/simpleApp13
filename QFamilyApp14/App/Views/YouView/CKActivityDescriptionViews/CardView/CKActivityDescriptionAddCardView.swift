//
//  CKChoreDescriptionAddItemView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/2/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit

struct CKActivityDescriptionAddCardView: View {
    
    let cardSize: CGFloat = 100
    
    var body: some View {
        
        VStack(alignment: .leading) {
            ZStack {
                Rectangle()
                    .fill(SemanticAppColor.random)
                    .frame(width: cardSize, height: cardSize)
                    .cornerRadius(5)
                
                VStack {
                    Text("New")
                        .foregroundColor(.white)
                        .font(.body)
                    Text("Activity")
                        .foregroundColor(.white)
                        .font(.body)
                }
                
//                VStack {
//                    HStack {
//                        Spacer()
//                        Text("+")
//                            .foregroundColor(.black)
//                    }
//                    Spacer()
//                }
            }
        }
        .cornerRadius(5)
        .shadow(radius: 10)
        .padding()
    }
    
    
}//end CKChoreAddItemView

#if DEBUG
struct CKChoreAddItemView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            
            CKActivityDescriptionAddCardView()
                .previewLayout(.fixed(width: 300, height: 300))
            .previewDisplayName("300x300 view")
            
            CKActivityDescriptionAddCardView()
                .previewLayout(.fixed(width: 300, height: 300))
                .environment(\.colorScheme, .dark)
                .previewDisplayName("dark mode")
        }
    }
}
#endif
