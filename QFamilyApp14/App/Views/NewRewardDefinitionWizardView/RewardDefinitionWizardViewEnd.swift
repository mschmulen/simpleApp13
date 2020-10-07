//
//  RewardDefinitionWizardViewEnd.swift
//  QFamilyApp14
//
//  Created by Matthew Schmulen on 10/7/20.
//

import SwiftUI
import Combine
import FamilyKit

struct RewardDefinitionWizardViewEnd:View {
    
    @Binding var model: CKBuckRewardDefinitionModel
    
    var closeCallback: ()->Void
    
    var backgroundColor = SemanticAppColor.random
    
    var body: some View {
        ZStack {
            backgroundColor
            VStack {
                Text("Bucks price")
                    .font(.system(size: 27, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding()
                Spacer()
                Text("Set the Bucks price for this reward")
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


struct RewardDefinitionWizardViewEnd_Previews: PreviewProvider {
    static var previews: some View {
        RewardDefinitionWizardViewEnd(model: .constant(CKBuckRewardDefinitionModel()), closeCallback: {
            print("close callback")
        })
    }
}
