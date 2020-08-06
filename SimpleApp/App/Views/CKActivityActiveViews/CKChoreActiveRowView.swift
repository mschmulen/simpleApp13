//
//  CKChoreDescriptionRowView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/1/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit

struct CKChoreActiveRowView: View {
    
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    var categoryName: String
    var items: [CKActivityActiveModel]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(self.categoryName)
                .font(.headline)
                .padding(.leading, 15)
                .padding(.top, 5)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    
                    if self.items.count <= 0 {
                        CKChoreActiveNoItemsView()
                    }
                    ForEach(self.items) { model in
                        NavigationLink(
                            destination: CKChoreActiveDetailView(
                                model: model
                            )
                        ) {
                            CKChoreActiveItemView(model: model)
                        }
                    }
                }
            }
            .frame(height: 185)
        }
    }
}//end CKChoreRowView

#if DEBUG
struct CKChoreActiveRowView_Previews: PreviewProvider {
    static var previews: some View {
            
        Group {
            CKChoreActiveRowView(
                categoryName: "CATEGORY",
                items: [
                    CKActivityActiveModel.mock,
                    CKActivityActiveModel.mock,
                    CKActivityActiveModel.mock,
                    CKActivityActiveModel.mock
                ]
            )
                .previewLayout(.fixed(width: 400, height: 100))
            
            CKChoreActiveRowView(
                categoryName: "CATEGORY",
                items: [
                    CKActivityActiveModel.mock,
                    CKActivityActiveModel.mock,
                    CKActivityActiveModel.mock,
                    CKActivityActiveModel.mock ]                
            )
                .previewLayout(.fixed(width: 400, height: 100))
                .environment(\.colorScheme, .dark)
        }
    }
}
#endif
