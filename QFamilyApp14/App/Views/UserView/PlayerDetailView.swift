//
//  PlayerDetailView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/1/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation
import SwiftUI
import FamilyKit

struct PlayerDetailView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @State var devMessage: String?
    @State var model: CKPlayerModel
    @State private var stateBirthDate = Date()
    
    var starterDate: Date {
        if let dob = model.dateOfBirth {
            return dob
        } else {
            return Calendar.current.date(byAdding: .year, value: -15, to: Date()) ?? Date()
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: onDelete) {
                    HStack {
                        Text("Delete")
                        Image(systemName: "trash")
                    }.foregroundColor(.blue)
                }.padding()
                
                Spacer()
                
                Button(action: onSave) {
                    HStack {
                        Text("Save")
                        Image(systemName: "square.and.arrow.up")
                    }.foregroundColor(.blue)
                }.padding()
            }
            
            List {
                Text("name \(model.name ?? "~")")
                Section(header: Text("Data")) {
                    TextField("name", text: $model.name ?? "")
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("bucks", value: $model.bucks ?? 2, formatter: NumberFormatter())
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("emoji", text: $model.emoji ?? "😀")
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Picker(selection: $model.playerType, label: Text("playerType")) {
                        ForEach(CKPlayerModel.PlayerType.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                        .padding()
                    
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
        }
    }//end body
    
    func onSave() {
        self.familyKitAppState.playerService.pushUpdateCreate(model: model) { (result) in
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
    
    func onDelete() {
        self.familyKitAppState.playerService.pushDelete(model: model) { (result) in
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

struct PlayerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PlayerDetailView(model: CKPlayerModel.mockKid)
            PlayerDetailView(model: CKPlayerModel.mock)
        }
    }
}
