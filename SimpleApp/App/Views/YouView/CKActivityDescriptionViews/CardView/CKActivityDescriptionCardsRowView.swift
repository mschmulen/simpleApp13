//
//  CKActivityDescriptionCardsRowView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/1/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit

struct CKActivityDescriptionCardsRowView: View {
    
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var activityDescriptionService: CKPrivateModelService<CKActivityDescriptionModel>
    
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
                    
                    if showAdd {
                        NavigationLink(
                            destination: CKActivityDescriptionDetailEditView(
                                model: CKActivityDescriptionModel()
                            )
                        ) {
                            CKActivityDescriptionAddCardView()
                        }
                    } else {
                        if self.items.count <= 0 {
                            CKActivityDescriptionNoItemsView()
                        }
                    }
                    
                    ForEach(self.items) { model in
                        if (self.familyKitAppState.currentPlayerModel?.isAdult ?? false) {
                            NavigationLink(
                                destination: CKActivityDescriptionDetailEditView(
                                    model: model
                                )
                            ) {
                                CKActivityDescriptionCardView(model: model)
                            }.contextMenu {
                                Button(action: {
                                    self.activityDescriptionService.pushDelete(model: model) { (result) in
                                        print("delete result \(result)")
                                    }
                                }) {
                                    Text("Delete")
                                    Image(systemName: "trash")
                                }
                            }
                        } else {
                            NavigationLink(
                                destination: CKActivityDescriptionDetailView(
                                    model: model
                                )
                            ) {
                                CKActivityDescriptionCardView(model: model)
                            }
                        }
                    }
                }
            }
            .frame(height: 185)
        }
    }
}//end CKActivityDescriptionRowView

#if DEBUG
struct CKActivityDescriptionRowView_Previews: PreviewProvider {
    static var previews: some View {

        Group {
            CKActivityDescriptionCardsRowView(
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
            //                .environment(\.colorScheme, .dark)
        }
    }
}
#endif
