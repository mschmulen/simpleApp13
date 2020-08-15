//
//  CKChoreDescriptionRowView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/1/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit

struct CKActivityActiveRowView: View {
    
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var privateActiveChoreService: CKPrivateModelService<CKActivityModel>
    
    var categoryName: String
    var items: [CKActivityModel]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(self.categoryName)
                .font(.headline)
                .padding(.leading, 15)
                .padding(.top, 5)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    
                    if self.items.count <= 0 {
                        CKActivityActiveNoItemsView()
                    }
                    ForEach(self.items) { model in
                        NavigationLink(
                            destination: CKActivityActiveDetailView(
                                model: model
                            )
                        ) {
                            CKActivityActiveItemView(model: model)
                        }.contextMenu {
                            Button(action: {
                                self.privateActiveChoreService.pushDelete(model: model) { (result) in
                                    print("delete result \(result)")
                                }
                            }) {
                                Text("Delete")
                                Image(systemName: "trash")
                            }
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
            CKActivityActiveRowView(
                categoryName: "CATEGORY",
                items: [
                    CKActivityModel.mock,
                    CKActivityModel.mock,
                    CKActivityModel.mock,
                    CKActivityModel.mock
                ]
            )
                .previewLayout(.fixed(width: 400, height: 100))
            
            CKActivityActiveRowView(
                categoryName: "CATEGORY",
                items: [
                    CKActivityModel.mock,
                    CKActivityModel.mock,
                    CKActivityModel.mock,
                    CKActivityModel.mock ]                
            )
                .previewLayout(.fixed(width: 400, height: 100))
                .environment(\.colorScheme, .dark)
        }
    }
}
#endif
