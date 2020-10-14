//
//  OnboardingChildInfoView.swift
//  QFamilyApp14
//
//  Created by Matthew Schmulen on 10/14/20.
//

import SwiftUI

struct OnboardingChildInfoView: View {
    
    var nextCallback: ()->Void
    
    var backgroundColor = SemanticAppColor.random
    
    @State var childName: String = ""
    
    var body: some View {
        ZStack {
            backgroundColor
            VStack {
                Text("Adult Info")
                    .font(.system(size: 27, weight: .medium, design: .rounded))
                    .padding()
                
                VStack(alignment: .leading) {
                    Text("Family App needs an adult to create tasks and rewards and also manage invites to other family members")
                }
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .padding()
                
                Text("Please enter a child name and birthday ")

                TextField("child name", text: $childName)
                    .foregroundColor(.black)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    //.padding(.all, 20)
                    .padding()
                Spacer()
                
                if !childName.isEmpty {
                    Button(action:{
                        nextCallback()
                    }){
                        Text("➜").padding()
                            .font(.system(size: 27, weight: .medium, design: .rounded))
                            .padding()
                    }
                    Spacer()
                }
                
            }//end VStack
            .foregroundColor(.white)
        }//end ZStack
    }//end body
}

struct OnboardingChildInfoView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingChildInfoView(nextCallback: {
            print( "next")
        })
    }
}
