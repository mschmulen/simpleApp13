//
//  CKChoreDetailView.swift
//  FamilyKitDemo
//
//  Created by Matthew Schmulen on 7/29/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit

struct CKChoreDetailView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var choreService: CKPublicModelService<CKChoreDescriptionModel>
    @EnvironmentObject var connectService: CKPublicModelService<CKConnectModel>
    @EnvironmentObject var funService: CKPublicModelService<CKFunModel>
    
    @State var devMessage: String?
    
    @State var model: CKChoreDescriptionModel
    
    var body: some View {
        NavigationView {
            List{
                if devMessage != nil {
                    Text("\(devMessage!)")
                        .foregroundColor(.red)
                        .onTapGesture {
                            self.devMessage = nil
                    }
                }
                
                Button(action:onSave) {
                    HStack {
                        Text("Save")
                        Image(systemName: "square.and.arrow.up")
                    }
                }
                
                Section(header: Text("Data")) {
                    Text("title \(model.title ?? "~")")
                    
                    TextField("name", text: $model.name ?? "")
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
            .navigationBarTitle("Detail")
            //.navigationBarItems(leading: leadingButton, trailing: trailingButton)
        }
    }
    
//    private var leadingButton: some View {
//        HStack {
//            if self.familyKitAppState.userService.currentUser == nil {
//                Button(action:onTrailing) { Image(systemName: "person.circle") }
//            } else {
//                Text("\(self.familyKitAppState.userService.currentUser!.appleIDProvider_credential_user_givenName ?? "??")")
//                Button(action:onTrailing) { Image(systemName: "person.circle.fill") }
//            }
//        }
//    }
//
//    private var trailingButton: some View {
//        Button(action:onSave) { Image(systemName: "square.and.arrow.up") }
//    }
    
    func onSave() {
        choreService.pushUpdateCreate(model: model) { (result) in
                switch result {
                case .failure(let error):
                    self.devMessage = error.localizedDescription
                case .success(let record):
                    print( "success \(record)")
                    DispatchQueue.main.async {
                        self.presentationMode.wrappedValue.dismiss()
                        self.choreService.fetch { (result) in
                            print( "result")
                        }

                    }
                }
            }
//        }//end switch
    }
    
    func onTrailing() {
        print( "onTrailing")
    }
    
}


