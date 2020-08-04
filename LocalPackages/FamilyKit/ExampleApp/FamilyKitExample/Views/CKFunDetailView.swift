//
//  CKFunDetailView.swift
//  FamilyKitDemo
//
//  Created by Matthew Schmulen on 7/29/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation
import SwiftUI
import FamilyKit

struct CKFunDetailView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var choreService: CKPublicModelService<CKChoreModel>
    @EnvironmentObject var connectService: CKPublicModelService<CKConnectModel>
    @EnvironmentObject var funService: CKPublicModelService<CKFunModel>
    
    @State var devMessage: String?
    
    @State var model: CKFunModel
    
    var body: some View {
        NavigationView {
            List {
                Text("CKFunDetailView")
                Text("name \(model.name ?? "~")")
                Text("bucks \(String(describing: model.bucks))")
                
                Section(header: Text("Data")) {
                    Text("title \(model.title ?? "~")")
                    
                    TextField("name", text: $model.name ?? "")
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("description", text: $model.description ?? "")
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("bucks", value: $model.bucks ?? 2, formatter: NumberFormatter())
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
            .navigationBarTitle("Fun")
            .navigationBarItems(leading: leadingButton, trailing: trailingButton)
        }
    }
    
    private var leadingButton: some View {
           HStack {
               if self.familyKitAppState.userService.currentUser == nil {
                   Button(action:onTrailing) { Image(systemName: "person.circle") }
               } else {
                   Button(action:onTrailing) { Image(systemName: "person.circle.fill") }
               }
           }
       }
       
       private var trailingButton: some View {
           Button(action:onSave) { Image(systemName: "square.and.arrow.up") }
       }
       
       func onSave() {
        funService.pushUpdateCreate(model: model) { (result) in
               switch result {
               case .failure(let error):
                   self.devMessage = error.localizedDescription
               case .success(let record):
                   print( "success \(record)")
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
