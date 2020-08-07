//
//  AdultDetailView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/1/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit

struct AdultDetailView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    // @EnvironmentObject var privateChoreService: CKPrivateModelService<CKChoreModel>
        
    @State var devMessage: String?
    
    @State var model: CKAdultModel
    
    @State private var stateBirthDate = Date()
    var starterDate: Date {
        if let dob = model.dateOfBirth {
            return dob
        } else {
            return Calendar.current.date(byAdding: .year, value: -35, to: Date()) ?? Date()
        }
    }
    
    var body: some View {
            List {
                Button(action:onSave) {
                    HStack {
                        Text("Save")
                        Image(systemName: "square.and.arrow.up")
                    }.foregroundColor(.blue)
                }
                Text("Adult name \(model.name ?? "~")")
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
//            .navigationBarTitle("Adult")
    }//end body
    
    func onSave() {
        self.familyKitAppState.adultService.pushUpdateCreate(model: model) { (result) in
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
}


