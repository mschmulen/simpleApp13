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
    @EnvironmentObject var familyKitState: FamilyKitState
    
    @EnvironmentObject var publicChoreService: CKModelService<CKChoreModel>
    @EnvironmentObject var privateChoreService: CKModelService<CKChoreModel>

    @EnvironmentObject var publicConnectService: CKModelService<CKConnectModel>
    @EnvironmentObject var publicFunService: CKModelService<CKFunModel>
    @EnvironmentObject var privateFunService: CKModelService<CKFunModel>
    
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
                    
                    TextField("bucks", value: $model.bucks ?? 2, formatter: NumberFormatter())
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
            }
            .navigationBarTitle("Kid")
            .navigationBarItems(leading: leadingButton, trailing: trailingButton)
        }
    }
    
    private var leadingButton: some View {
           HStack {
               if self.familyKitState.userService.currentUser == nil {
                   Button(action:onTrailing) { Image(systemName: "person.circle") }
               } else {
                   Text("\(self.familyKitState.userService.currentUser!.appleIDProvider_credential_user_givenName ?? "??")")
                   Button(action:onTrailing) { Image(systemName: "person.circle.fill") }
               }
           }
       }
       
       private var trailingButton: some View {
           Button(action:onSave) { Image(systemName: "square.and.arrow.up") }
       }
       
       func onSave() {
        publicFunService.pushUpdateCreate(model: model) { (result) in
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
