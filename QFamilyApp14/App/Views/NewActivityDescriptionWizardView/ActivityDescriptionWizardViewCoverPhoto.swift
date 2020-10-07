//
//  ActivityDescriptionWizardViewCoverPhoto.swift
//  QFamilyApp14
//
//  Created by Matthew Schmulen on 10/7/20.
//

import SwiftUI
import Combine
import FamilyKit

struct ActivityDescriptionWizardViewCoverPhoto: View {
    
    @Binding var model: CKActivityDescriptionModel
    
    var backgroundColor = SemanticAppColor.random
    
    var body: some View {
        ZStack {
            backgroundColor
            VStack {
                Text("Custom Cover Photo")
                    .font(.system(size: 27, weight: .bold, design: .rounded))
                    .padding()
                    .foregroundColor(.white)
                Spacer()
                
                Text("Would you like to pick a custom cover photo to use instead of an emoji?")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding()
                Spacer()
                
                NavigationLink(destination: PhotoActivityDescriptionView(model: self.model) ) {
                    Text("change coverPhoto")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding()
                }
                Spacer()
            }
        }
    }
}

struct ActivityDescriptionWizardViewCoverPhoto_Previews: PreviewProvider {
    static var previews: some View {
        ActivityDescriptionWizardViewCoverPhoto(model: .constant(CKActivityDescriptionModel()))
    }
}
