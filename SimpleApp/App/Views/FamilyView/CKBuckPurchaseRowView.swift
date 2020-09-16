//
//  CKBuckPurchaseRowView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 9/15/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation
import SwiftUI
import FamilyKit

struct CKBuckPurchaseRowView: View {
    
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var storeItemDefinitionService: CKPrivateModelService<CKBuckRewardDefinitionModel>
    @EnvironmentObject var storeItemPurchaseService: CKPrivateModelService<CKBuckRewardModel>
    
    var categoryName: String
    var items: [CKBuckRewardModel]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(self.categoryName)
                .font(.headline)
                .padding(.leading, 15)
                .padding(.top, 5)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    ForEach(self.items) { model in
                        NavigationLink(
                            destination: RewardDetailView(
                                model: model
                            )
                        ) {
                            CKBuckPurchaseItemViewCard(model: model)
                        }
                    }
                }
            }
            .frame(height: 185)
        }
    }
}//end CKChoreRowView

#if DEBUG
struct CKBuckPurchaseRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CKBuckPurchaseRowView(
                categoryName: "CATEGORY",
                items: [
                    CKBuckRewardModel.mock,
                    CKBuckRewardModel.mock,
                    CKBuckRewardModel.mock
                ]
            )
                .previewLayout(.fixed(width: 400, height: 100))
        }
    }
}
#endif
