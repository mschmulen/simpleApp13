//
//  OnboardingiCloudView.swift
//  QFamilyApp14
//
//  Created by Matthew Schmulen on 10/14/20.
//

import SwiftUI
import FamilyKit

struct OnboardingiCloudView: View {
    
    var nextCallback: ()->Void
    
    var backgroundColor = SemanticAppColor.random
    
    var body: some View {
        ZStack {
            backgroundColor
            VStack {
                Text("Family App uses your iCloud account")
                    .font(.system(size: 27, weight: .medium, design: .rounded))
                    .padding()
                VStack(alignment: .leading) {
                    Text("● to provide security for your family")
                    Text("● you control who sees your family info")
                    Text("● family privacy")
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

struct OnboardingiCloudView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingiCloudView(nextCallback: {
            print("next")
        })
    }
}
