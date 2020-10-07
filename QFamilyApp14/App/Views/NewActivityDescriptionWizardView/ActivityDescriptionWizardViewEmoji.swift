//
//  ActivityDescriptionWizardViewEmoji.swift
//  QFamilyApp14
//
//  Created by Matthew Schmulen on 10/7/20.
//

import SwiftUI
import Combine
import FamilyKit

struct ActivityDescriptionWizardViewEmoji: View {
    
    @Binding var model: CKActivityDescriptionModel
    
    var backgroundColor = SemanticAppColor.random
    
    var body: some View {
        ZStack {
            backgroundColor
            VStack {
                Text("Pick an Emoji")
                    .font(.system(size: 27, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding()
                Spacer()
                
                Text("pick an emoji for you Activity so its easily recognized")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding()
                
                TextField("emoji", text: self.$model.emoji ?? "")
                    .frame(minWidth: 60, maxWidth: 100)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Spacer()
            }
        }
    }
}

struct ActivityDescriptionWizardViewEmoji_Previews: PreviewProvider {
    static var previews: some View {
        ActivityDescriptionWizardViewEmoji(model: .constant(CKActivityDescriptionModel()))
    }
}
