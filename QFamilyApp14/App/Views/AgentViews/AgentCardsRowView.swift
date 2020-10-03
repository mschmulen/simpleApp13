//
//  AgentCardsRowView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 9/12/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

//import SwiftUI
//import FamilyKit
//
//struct AgentCardsRowView: View {
//    
//    @EnvironmentObject var familyKitAppState: FamilyKitAppState
//    
//    @EnvironmentObject var activityDescriptionService: CKPrivateModelService<CKActivityDescriptionModel>
//    
//    var categoryName: String
//    
//    var body: some View {
//        VStack(alignment: .leading) {
//            
//            Text(self.categoryName)
//                .font(.headline)
//                .padding(.leading, 15)
//                .padding(.top, 5)
//            
//            ScrollView(.horizontal, showsIndicators: false) {
//                HStack(alignment: .top, spacing: 0) {
//                    
//                    NavigationLink(
//                        destination: AgentDetailView(
//                            agentConfig: familyKitAppState.agentConfig
//                        )
//                    ) {
//                        AgentCardView(name: familyKitAppState.agentConfig.name)
//                    }
//                    
////                    NavigationLink(
////                        destination: AgentDetailView(
////                            agentConfig: .mock
////                        )
////                    ) {
////                        AgentCardView(name: AgentConfig.mock.name)
////                    }
//                }
//            }
//            .frame(height: 185)
//        }
//    }
//}//end CKActivityDescriptionRowView
//
//#if DEBUG
//struct AgentCardsRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        
//        Group {
//            AgentCardsRowView(
//                categoryName: "agent"
//            )
//                .previewLayout(.fixed(width: 400, height: 100))
//            //                .environment(\.colorScheme, .dark)
//        }
//    }
//}
//#endif
