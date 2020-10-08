//
//  RewardCardView.swift
//  QFamilyApp14
//
//  Created by Matthew Schmulen on 10/8/20.
//

import SwiftUI
import FamilyKit

struct RewardCardView: View {
    
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    var model: CKBuckRewardModel
    
    @State var coverPhotoImage: Image?
    
    let cardHeight: CGFloat = 150
    
    var body: some View {
        
        VStack(alignment: .leading) {
            ZStack {
                
                Rectangle()
                    .fill(SemanticAppColor.random)
                    .frame(width: cardHeight, height: cardHeight)
                    .cornerRadius(5)
                    .padding()

                VStack {
                    if model.purchasingPlayerReference != nil {
                        Text("\(familyKitAppState.findPlayerModelForRecord(recordReference: model.purchasingPlayerReference!)?.name ?? "~")")
                            .lineLimit(1)
                            .modifier(PrimarySmallBoldLabel(color: .white))
                            .padding()
                    }
                    
                    Text(model.title ?? "~")
                        .lineLimit(3)
                        .modifier(PrimarySmallRegularLabel(color: .white))
                        .padding()
                }
            }
        }
        .cornerRadius(5)
        .shadow(radius: 10)
        .padding()
    }
    
}//end FamilyRewardItemViewCard

#if DEBUG
struct RewardCardView_Previews: PreviewProvider {
    static var previews: some View {
        RewardCardView( model: CKBuckRewardModel.mock)
            .previewLayout(.fixed(width: 200, height: 200))
    }
}
#endif
