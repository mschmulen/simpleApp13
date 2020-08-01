//
//  KidDetailView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/1/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation
import SwiftUI
import FamilyKit

struct KidDetailView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
//    @EnvironmentObject var choreService: CKPublicModelService<CKChoreModel>
//    @EnvironmentObject var connectService: CKPublicModelService<CKConnectModel>
//    @EnvironmentObject var funService: CKPublicModelService<CKFunModel>
        
    @State var devMessage: String?
    
    @State var model: CKKidModel
    
    @State private var stateBirthDate = Date()
    var starterDate: Date {
        if let dob = model.dateOfBirth {
            return dob
        } else {
            return Calendar.current.date(byAdding: .year, value: -15, to: Date()) ?? Date()
        }
    }
    
    var body: some View {
        List{
            Button(action:onSave) {
                HStack {
                    Text("Save")
                    Image(systemName: "square.and.arrow.up")
                }
            }
            Text("Kid name \(model.name ?? "~")")
            Section(header: Text("Data")) {
                TextField("name", text: $model.name ?? "")
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("bucks", value: $model.bucks ?? 2, formatter: NumberFormatter())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("emoji", text: $model.emoji ?? "😀")
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                VStack{
                    Text("birthday")
                    DatePicker(selection: $stateBirthDate, in: ...starterDate, displayedComponents: .date) {
                        Text("Select your birthday")
                    }
                    .labelsHidden()
                }
                .padding()
                .border(Color.gray)
            }
        }
    }//end body
    
    func onSave() {
        self.familyKitAppState.kidService.pushUpdateCreate(model: model) { (result) in
            switch result {
            case .failure(let error):
                self.devMessage = error.localizedDescription
            case .success(_):
                DispatchQueue.main.async {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
    
    func onTrailing() {
        print( "onTrailing")
    }
}
