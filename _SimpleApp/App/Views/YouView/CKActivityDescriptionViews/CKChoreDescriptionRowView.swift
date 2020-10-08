//
//  CKChoreDescriptionRowView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/1/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit

struct CKActivityDescriptionRowView: View {
    
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var privateChoreService: CKPrivateModelService<CKActivityDescriptionModel>
    
    var categoryName: String
    var items: [CKActivityDescriptionModel]
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
                        CKActivityDescriptionNoItemsView()
                    }
                    
                    if showAdd {
                        NavigationLink(
                            destination: CKActivityDescriptionDetailView(
                                model: CKActivityDescriptionModel(), enableEdit: true
                            )
                        ) {
                            CKActivityDescriptionAddItemView()
                        }
                    }
                    
                    ForEach(self.items) { model in
                        NavigationLink(
                            destination: CKActivityDescriptionDetailView(
                                model: model,
                                enableEdit: self.familyKitAppState.currentPlayer.isAdult
                            )
                        ) {
                            CKActivityDescriptionItemView(model: model)
                        }.contextMenu {
                            Button(action: {
                                self.privateChoreService.pushDelete(model: model) { (result) in
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
struct CKChoreRowView_Previews: PreviewProvider {
    static var previews: some View {
            
        Group {
            CKActivityDescriptionRowView(
                categoryName: "CATEGORY",
                items: [
                    CKActivityDescriptionModel.mock,
                    CKActivityDescriptionModel.mock,
                    CKActivityDescriptionModel.mock,
                    CKActivityDescriptionModel.mock
                ],
                isPrivate: true,
                showAdd: true
            )
                .previewLayout(.fixed(width: 400, height: 100))
            
//            CKChoreDescriptionRowView(
//                categoryName: "CATEGORY",
//                items: [
//                    CKActivityDescriptionModel.mock,
//                    CKActivityDescriptionModel.mock,
//                    CKActivityDescriptionModel.mock,
//                    CKActivityDescriptionModel.mock ],
//                isPrivate: true,
//                showAdd: true
//            )
//                .previewLayout(.fixed(width: 400, height: 100))
//                .environment(\.colorScheme, .dark)
        }
    }
}
#endif
