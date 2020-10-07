//
//  ActivityDescriptionWizardViewEnd.swift
//  QFamilyApp14
//
//  Created by Matthew Schmulen on 10/7/20.
//

import SwiftUI
import Combine
import FamilyKit

struct ActivityDescriptionWizardViewEnd:View {
    
    @Binding var model: CKActivityDescriptionModel
    
    var closeCallback: ()->Void
    
    var backgroundColor = SemanticAppColor.random
    
    var body: some View {
        ZStack {
            backgroundColor
            VStack {
                Text("Bucks Reward")
                    .font(.system(size: 27, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding()
                Spacer()
                Text("Set the Bucks reward for completing this activity")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding()
                TextField("bucks", value: self.$model.bucks, formatter: NumberFormatter())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Spacer()
                    Spacer()
                    Button(action: {
                        self.closeCallback()
                    }) {
                        Text("SAVE")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }.padding()
                Spacer()
            }
        }
    }//end body
}// ViewEnd


struct ActivityDescriptionWizardViewEnd_Previews: PreviewProvider {
    static var previews: some View {
        ActivityDescriptionWizardViewEnd(model: .constant(CKActivityDescriptionModel()), closeCallback: {
            print("close callback")
        })
    }
}
