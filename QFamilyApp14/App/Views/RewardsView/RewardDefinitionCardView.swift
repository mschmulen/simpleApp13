//
//  RewardDefinitionCardView.swift
//  QFamilyApp14
//
//  Created by Matthew Schmulen on 10/8/20.
//

import SwiftUI
import FamilyKit

struct RewardDefinitionCardView: View {
    
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    var model: CKBuckRewardDefinitionModel
    
    let cardHeight: CGFloat = 150
    
    var body: some View {
        
        VStack(alignment: .leading) {
            ZStack {
                Rectangle()
                    .fill(SemanticAppColor.random)
                    .frame(width: cardHeight, height: cardHeight)
                    .cornerRadius(5)
                VStack {
                    Text(model.title ?? "~")
                        .lineLimit(3)
                        .modifier(PrimarySmallRegularLabel(color: .white))
                        .frame(width: cardHeight, height: cardHeight)
                        .padding()
                }
            }
        }
        .cornerRadius(5)
        .shadow(radius: 10)
        .padding()
        .onAppear {
             
        }
    }
    
}//end RewardDefinitionCardView

#if DEBUG
struct RewardDefinitionCardView_Previews: PreviewProvider {
    static var previews: some View {
        RewardDefinitionCardView( model: CKBuckRewardDefinitionModel.mock)
            .previewLayout(.fixed(width: 200, height: 200))
    }
}
#endif
