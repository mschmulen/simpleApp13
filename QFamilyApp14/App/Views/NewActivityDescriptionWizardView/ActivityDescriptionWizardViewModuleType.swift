//
//  ActivityDescriptionWizardViewModuleType.swift
//  QFamilyApp14
//
//  Created by Matthew Schmulen on 10/7/20.
//

import SwiftUI
import Combine
import FamilyKit

struct ActivityDescriptionWizardViewModuleType: View {
    
    @Binding var model: CKActivityDescriptionModel
    
    var backgroundColor = SemanticAppColor.random
    
    var body: some View {
        ZStack {
            backgroundColor
            VStack {
                Text("Acvity Type")
                    .font(.system(size: 27, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding()
                Spacer()
                
                Text("What type of activity template do you want this activity to use?")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .padding()
                    .foregroundColor(.white)

                Picker(selection: self.$model.moduleType, label: Text("Type")) {
                    ForEach(ActivityModuleType.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                Spacer()
                
                Text("What catagory of activity is this?")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .padding()
                    .foregroundColor(.white)
                
                Picker(selection: self.$model.category, label: Text("Category")) {
                    ForEach(ActivityCategory.allCases.filter { $0 != .none }, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                Spacer()
            }
        }
    }
}

struct ActivityDescriptionWizardViewModuleType_Previews: PreviewProvider {
    static var previews: some View {
        ActivityDescriptionWizardViewModuleType(model: .constant(CKActivityDescriptionModel()))
    }
}
