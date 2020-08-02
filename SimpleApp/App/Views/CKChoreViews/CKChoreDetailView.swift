//
//  CKChoreDetailView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/2/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit

struct CKChoreDetailView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var privateChoreService: CKPrivateModelService<CKChoreModel>
    @EnvironmentObject var publicChoreService: CKPublicModelService<CKChoreModel>
    
    @State var devMessage: String?
    
    @State var model: CKChoreModel
    var isPrivate:Bool
    var enableEdit:Bool
    
    var readOnlyView: some View {
        Section(header: Text("Info")) {
            Text("name \(model.name ?? "~")")
            Text("emoji \(model.emoji ?? "~")")
            Text("description \(model.description ?? "~")")
            Text("bucks \(model.bucks ?? 0)")

            Text("who \(model.who ?? "~")")
            Text("frequency \(model.frequency ?? "~")")
            Text("timeofday \(model.timeofday ?? "~")")
            Text("image \(model.imageName ?? "~")")
        }
    }
    
    var editView: some View {
        Section(header: Text("Data")) {
            Text("title \(model.title ?? "~")")
            
            TextField("name", text: $model.name ?? "")
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("emoji", text: $model.emoji ?? "")
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("description", text: $model.description ?? "")
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("bucks", value: $model.bucks ?? 2, formatter: NumberFormatter())
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("who", text: $model.who ?? "")
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("frequency", text: $model.frequency ?? "")
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("timeofday", text: $model.timeofday ?? "")
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("imageName", text: $model.imageName ?? "")
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
    
    var body: some View {
        List{
            if devMessage != nil {
                Text("\(devMessage!)")
                    .foregroundColor(.red)
                    .onTapGesture {
                        self.devMessage = nil
                }
            }
            
            if enableEdit {
                Button(action:onSave) {
                    HStack {
                        Text("Save")
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
            
            if enableEdit {
                editView
            } else {
                readOnlyView
            }
        }//end List
    }
    
    func onSave() {
        if isPrivate {
            privateChoreService.pushUpdateCreate(model: model) { (result) in
                switch result {
                case .failure(let error):
                    self.devMessage = "save error\(error.localizedDescription)"
                case .success(let record):
                    print( "success \(record)")
                    DispatchQueue.main.async {
                        self.presentationMode.wrappedValue.dismiss()
                        self.publicChoreService.fetch { (result) in
                            print( "result")
                        }
                    }
                }
            }
        } else {
            publicChoreService.pushUpdateCreate(model: model) { (result) in
                switch result {
                case .failure(let error):
                    self.devMessage = "save error\(error.localizedDescription)"
                case .success(let record):
                    print( "success \(record)")
                    DispatchQueue.main.async {
                        self.presentationMode.wrappedValue.dismiss()
                        self.publicChoreService.fetch { (result) in
                            print( "result")
                        }
                    }
                }
            }
        }
    }
}//end CKChoreDetailView
