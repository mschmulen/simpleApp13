//
//  RewardDefinitionWizardViewStart.swift
//  QFamilyApp14
//
//  Created by Matthew Schmulen on 10/7/20.
//

import SwiftUI
import Combine
import FamilyKit

struct RewardDefinitionWizardViewStart:View {
    
    @Binding var model: CKBuckRewardDefinitionModel
    
    var backgroundColor = SemanticAppColor.random
    
    var body: some View {
        ZStack {
            backgroundColor
            VStack {
                Spacer()
                Text("New Reward Definition")
                    .font(.system(size: 27, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding()
                Spacer()
                Text("Reward Name:")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding()

                TextField("name", text: self.$model.name ?? "")
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Spacer()
            }
        }
    }
}// ViewEnd

struct RewardDefinitionWizardViewStart_Previews: PreviewProvider {
    static var previews: some View {
        RewardDefinitionWizardViewStart(model: .constant(CKBuckRewardDefinitionModel()))
    }
}
