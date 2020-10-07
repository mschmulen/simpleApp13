//
//  ActivityDescriptionWizardViewStart.swift
//  QFamilyApp14
//
//  Created by Matthew Schmulen on 10/7/20.
//

import SwiftUI
import Combine
import FamilyKit

struct ActivityDescriptionWizardViewStart:View {
    
    @Binding var model: CKActivityDescriptionModel
    
    var backgroundColor = SemanticAppColor.random
    
    var body: some View {
        ZStack {
            backgroundColor
            VStack {
                Spacer()
                Text("New Activity Description")
                    .font(.system(size: 27, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding()
                Spacer()
                Text("Activiy Description Name:")
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

struct ActivityDescriptionWizardViewStart_Previews: PreviewProvider {
    static var previews: some View {
        ActivityDescriptionWizardViewStart(model: .constant(CKActivityDescriptionModel()))
    }
}
