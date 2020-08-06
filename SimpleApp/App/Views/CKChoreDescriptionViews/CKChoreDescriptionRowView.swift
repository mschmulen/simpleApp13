//
//  CKChoreView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/1/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit

struct CKChoreRowView: View {
    
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    var categoryName: String
    var items: [CKChoreDescriptionModel]
    var isPrivate: Bool
    var showAdd: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(self.categoryName)
                .font(.headline)
                .padding(.leading, 15)
                .padding(.top, 5)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    
                    if self.items.count <= 0 {
                        CKChoreNoItemsView()
                    }
                    
                    if showAdd {
                        NavigationLink(
                            destination: CKChoreDetailView(
                                model: CKChoreDescriptionModel(), enableEdit: true
                            )
                        ) {
                            CKChoreAddItemView()
                        }
                    }
                    
                    ForEach(self.items) { model in
                        NavigationLink(
                            destination: CKChoreDetailView(
                                model: model,
                                enableEdit: self.familyKitAppState.currentPlayer.isAdult
                            )
                        ) {
                            CKChoreItemView(model: model)
                        }
                    }
                }
            }
            .frame(height: 185)
        }
    }
}//end CKChoreRowView

#if DEBUG
struct CKChoreRowView_Previews: PreviewProvider {
    static var previews: some View {
            
        Group {
            CKChoreRowView(
                categoryName: "CATEGORY",
                items: [
                    CKChoreDescriptionModel.mock,
                    CKChoreDescriptionModel.mock,
                    CKChoreDescriptionModel.mock,
                    CKChoreDescriptionModel.mock
                ],
                isPrivate: true,
                showAdd: true
            )
                .previewLayout(.fixed(width: 400, height: 100))
            
            CKChoreRowView(
                categoryName: "CATEGORY",
                items: [
                    CKChoreDescriptionModel.mock,
                    CKChoreDescriptionModel.mock,
                    CKChoreDescriptionModel.mock,
                    CKChoreDescriptionModel.mock ],
                isPrivate: true,
                showAdd: true
            )
                .previewLayout(.fixed(width: 400, height: 100))
                .environment(\.colorScheme, .dark)
        }
    }
}
#endif
