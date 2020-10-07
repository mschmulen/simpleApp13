//
//  ActivityDescriptionWizardViewDescription.swift
//  QFamilyApp14
//
//  Created by Matthew Schmulen on 10/7/20.
//

import SwiftUI
import Combine
import FamilyKit

struct ActivityDescriptionWizardViewDescription: View {
    
    @Binding var model: CKActivityDescriptionModel
    
    var backgroundColor = SemanticAppColor.random
    
    var body: some View {
        ZStack {
            backgroundColor
            //ScrollView {
            //LazyVStack {
            VStack {
                Spacer()
                Text("Activity Description")
                    .font(.system(size: 27, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding()
                Spacer()
                
                Text("Give a description of this activity")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding()
                
                //                TextField("description", text: self.$model.description ?? "")
                //                    .textFieldStyle(RoundedBorderTextFieldStyle())
                //                    .padding()
                
                TextEditor(text: self.$model.description ?? "")
                    .foregroundColor(.black)
                    .frame(minHeight: CGFloat(100), maxHeight: CGFloat(100))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(1)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.white, lineWidth: 2)
                    )
                    .padding()
                
                Spacer()
            }//end VStack
        }//end ZStack
        .onTapGesture {
            self.endEditing()
        }
    }//end body
    
    private func endEditing() {
        UIApplication.shared.endEditing()
    }
    
}//end View

struct ActivityDescriptionWizardViewDescription_Previews: PreviewProvider {
    static var previews: some View {
        ActivityDescriptionWizardViewDescription(model: .constant(CKActivityDescriptionModel()))
    }
}
