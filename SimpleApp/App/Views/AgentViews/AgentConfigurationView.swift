//
//  AgentConfigurationView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 9/12/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import Combine
import FamilyKit

struct AgentConfigurationView: View {
    
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
            Text("Agent Configuration View")
            Text("Name: \(agent.name)")
        }//end List
    }//end body
    
}//end AgentConfigurationView

struct AgentConfigurationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AgentConfigurationView(agent: Agent.mock)
        }
    }
}
