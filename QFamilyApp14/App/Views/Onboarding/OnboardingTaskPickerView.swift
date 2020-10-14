//
//  OnboardingTaskPickerView.swift
//  QFamilyApp14
//
//  Created by Matthew Schmulen on 10/14/20.
//

import SwiftUI
import FamilyKit

struct OnboardingTaskPickerView: View {
    
    var nextCallback: ()->Void
    
    var backgroundColor = SemanticAppColor.random
    
    @State var starterActivities:[CKPublicActivityDescription] = [CKPublicActivityDescription]()
    
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
        }//end Zstack
        .onAppear(perform: {
            print( "load up stuff")
            
            self.starterActivities.removeAll()
            self.starterActivities.append(CKPublicActivityDescription.mock)
            self.starterActivities.append(CKPublicActivityDescription.mock)
            self.starterActivities.append(CKPublicActivityDescription.mock)
        })
    }//end body
}

struct OnboardingTaskPickerView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingTaskPickerView(nextCallback: {
            print( "next")
        })
    }
}
