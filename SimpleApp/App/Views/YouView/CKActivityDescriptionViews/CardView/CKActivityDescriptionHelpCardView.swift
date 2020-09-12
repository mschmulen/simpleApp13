//
//  CKActivityDescriptionAgentHelpCardView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 9/12/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit

struct CKActivityDescriptionAgentHelpCardView: View {
    
    let cardSize: CGFloat = 100
    
    var name: String
    
    var body: some View {
        
        VStack(alignment: .leading) {
            ZStack {
                Rectangle()
                    .fill(SemanticAppColor.random)
                    .frame(width: cardSize, height: cardSize)
                    .cornerRadius(5)
                
                VStack {
                    Text("Agent")
                        .foregroundColor(.white)
                        .font(.body)
                    Text("\(name)")
                        .foregroundColor(.white)
                        .font(.body)
                }
                
                VStack {
                    HStack {
                        Spacer()
                        Text("+")
                            .foregroundColor(.black)
                    }
                    Spacer()
                }
            }
        }
        .cornerRadius(5)
        .shadow(radius: 10)
        .padding()
    }
    
}//end CKActivityDescriptionAgentHelpCardView

#if DEBUG
struct CKActivityDescriptionHelpCardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            
            CKActivityDescriptionAgentHelpCardView(name: "yack")
                .previewLayout(.fixed(width: 300, height: 300))
                .previewDisplayName("300x300 view")
            
        }
    }
}
#endif

