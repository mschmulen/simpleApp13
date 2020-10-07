//
//  RewardDefinitionWizardViewDescription.swift
//  QFamilyApp14
//
//  Created by Matthew Schmulen on 10/7/20.
//

import SwiftUI
import Combine
import FamilyKit

struct RewardDefinitionWizardViewInfo: View {
    
    @Binding var model: CKBuckRewardDefinitionModel
    
    var backgroundColor = SemanticAppColor.random
    
    var body: some View {
        ZStack {
            backgroundColor
            //ScrollView {
            //LazyVStack {
            VStack {
                Spacer()
                Text("Reward Info")
                    .font(.system(size: 27, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding()
                Spacer()
                
                Text("Give a description of this activity")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding()
                
                TextEditor(text: self.$model.info ?? "")
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

struct RewardDefinitionWizardViewInfo_Previews: PreviewProvider {
    static var previews: some View {
        RewardDefinitionWizardViewInfo(model: .constant(CKBuckRewardDefinitionModel()))
    }
}
