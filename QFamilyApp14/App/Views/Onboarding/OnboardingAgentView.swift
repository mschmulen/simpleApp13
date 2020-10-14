//
//  OnboardingAgentView.swift
//  QFamilyApp14
//
//  Created by Matthew Schmulen on 10/14/20.
//

import SwiftUI

struct OnboardingAgentView: View {
    
    var nextCallback: ()->Void
    
    var backgroundColor = SemanticAppColor.random
    
    //var starterTasks:[]
    var body: some View {
        ZStack {
            backgroundColor
            VStack {
                Text("Pick some starter tasks")
                    .font(.system(size: 27, weight: .medium, design: .rounded))
                    .padding()
                VStack(alignment: .leading) {
                    Text("TODO pick some starter tasks")
                }
                .font(.system(size: 16, weight: .medium, design: .rounded))
                
                Spacer()
                Button(action:{
                    nextCallback()
                }){
                    Text("➜").padding()
                        .font(.system(size: 27, weight: .medium, design: .rounded))
                        .padding()
                }
                
                Spacer()
            }
            .foregroundColor(.white)
            .padding()
        }
    }
}

struct OnboardingAgentView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingAgentView()
    }
}
