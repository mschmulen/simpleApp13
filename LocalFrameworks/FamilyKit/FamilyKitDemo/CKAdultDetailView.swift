//
//  CKAdultDetailView.swift
//  FamilyKitDemo
//
//  Created by Matthew Schmulen on 7/30/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit

struct CKAdultDetailView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var familyKitState: FamilyKitState
    
    @EnvironmentObject var choreService: CKPublicModelService<CKChoreModel>
    @EnvironmentObject var connectService: CKPublicModelService<CKConnectModel>
    @EnvironmentObject var funService: CKPublicModelService<CKFunModel>
    
    @State var devMessage: String?
    
    @State var model: CKAdultModel
    
    var body: some View {
        NavigationView {
            List {
                Text("Kid name \(model.name ?? "~")")
                Section(header: Text("Data")) {
                    Text("title \(model.title ?? "~")")
                    
                    TextField("name", text: $model.name ?? "")
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("bucks", value: $model.bucks ?? 2, formatter: NumberFormatter())
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("emoji", text: $model.emoji ?? "😀")
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
            }
            .navigationBarTitle("Adult")
            .navigationBarItems( trailing: trailingButton)
        }
    }
    
    private var trailingButton: some View {
        Button(action:onSave) { Image(systemName: "square.and.arrow.up") }
    }
    
    func onSave() {
        self.familyKitState.adultService.pushUpdateCreate(model: model) { (result) in
            switch result {
            case .failure(let error):
                self.devMessage = error.localizedDescription
            case .success(let record):
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

