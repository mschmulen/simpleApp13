//
//  AgentDetailView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 9/12/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import Combine
import FamilyKit

struct AgentDetailView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var activityDescriptionService: CKPrivateModelService<CKActivityDescriptionModel>
    
    @State var devMessage: String?
    
    @State var agent: Agent
    
    @State var showActivityIndicator: Bool = false
    @State var activityIndicatorMessage: String = "Saving"
    
    var body: some View {
        List {
            DevMessageView(devMessage: $devMessage)
            
            Text("Agent: \(agent.name)")
            Section(header: Text("Recommendations")) {
                ForEach( agent.reccomendations) { model in
                    
                    NavigationLink(destination:
                        CKActivityDescriptionDetailView (
                            model: CKActivityDescriptionModel()
                        )
                    ) {
                        VStack {
                            if model.emoji != nil {
                                Text("\(model.emoji!)")
                            }
                            
                            Text("\(model.name ?? "")")
                            Text("\(model.description ?? "")")
                            Text("\(model.category.rawValue)")
                            Text("\(model.moduleType.emoji) \(model.moduleType.rawValue)")
                        }
                    }
                }//end ForEach
            }
        }//end List
    }//end body
    
}//end AgentDetailView

struct AgentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AgentDetailView(agent: Agent.mock)
        }
    }
}
