//
//  OnboardingAllDoneView.swift
//  QFamilyApp14
//
//  Created by Matthew Schmulen on 10/14/20.
//

import SwiftUI


struct OnboardingAllDoneView: View {
    
    var closeCallback: ()->Void
    
    var backgroundColor = SemanticAppColor.random
    
    var body: some View {
        ZStack {
            backgroundColor
            VStack {
//                HStack {
//                    Spacer()
//                    Button(action: {
//                        self.closeCallback()
//                    }) {
//                        Text("CLOSE !")
//                    }.padding()
//                }
                
                Spacer()
                Text("Get Started").padding()
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        self.closeCallback()
                    }) {
                        Text("Lets get started")
                    }.padding()
                }
                Spacer()
            }.foregroundColor(.white)
        }
    }
}

struct OnboardingAllDoneView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingAllDoneView(closeCallback: {
            print("close")
        })
    }
}
