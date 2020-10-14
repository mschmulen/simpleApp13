//
//  OnboardingWelcomeView.swift
//  QFamilyApp14
//
//  Created by Matthew Schmulen on 10/14/20.
//

import SwiftUI

struct OnboardingWelcomeView: View {
    
    var nextCallback: ()->Void
    
    var backgroundColor = SemanticAppColor.random
    
    var body: some View {
        ZStack {
            backgroundColor
            VStack {
                Text("Welcome to Family App")
                    .font(.system(size: 27, weight: .medium, design: .rounded))
                    .padding()
                VStack(alignment: .leading) {
                    Text("● Private and secure chat with your family")
                    Text("● Offer challenges and tasks for your kids ")
                    Text("● Make rewards completing tasks and chores")
                    Text("● Share Photos with just your family")
                    Text("● Have fun !")
                }
                .font(.system(size: 16, weight: .medium, design: .rounded))
                
                Spacer()
                Text("Lets get started")
                    .font(.system(size: 27, weight: .medium, design: .rounded))
                    .padding()
                
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

struct OnboardingWelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingWelcomeView(nextCallback: {
            print( "next")
        })
    }
}
