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
    @EnvironmentObject var familyKitState: FamilyKitState
    
    @EnvironmentObject var choreService: CKModelService<CKChoreModel>
    @EnvironmentObject var connectService: CKModelService<CKConnectModel>
    @EnvironmentObject var funService: CKModelService<CKFunModel>
    
    @State var devMessage: String?
    
    @State var model: CKChoreModel
    var containerConfig: CKContainerConfig
    
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
            .navigationBarTitle("Detail")
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
        
//        switch containerConfig {
//        case .privateCloudDatabase:
//            privateChoreService.pushUpdateCreate(model: model) { (result) in
//                switch result {
//                case .failure(let error):
//                    self.devMessage = error.localizedDescription
//                case .success(let record):
//                    print( "success \(record)")
//                    DispatchQueue.main.async {
//                        self.presentationMode.wrappedValue.dismiss()
//                    }
//                }
//            }
//        case .publicCloudDatabase:
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


// TextField($test.bound)
//extension Optional where Wrapped == String {
//    var _bound: String? {
//        get {
//            return self
//        }
//        set {
//            self = newValue
//        }
//    }
//    public var bound: String {
//        get {
//            return _bound ?? ""
//        }
//        set {
//            _bound = newValue.isEmpty ? nil : newValue
//        }
//    }
//}


//TextField("", text: $test ?? "default value")
func ??<T>(lhs: Binding<Optional<T>>, rhs: T) -> Binding<T> {
    Binding(
        get: { lhs.wrappedValue ?? rhs },
        set: { lhs.wrappedValue = $0 }
    )
}

//struct IntTextField: TextField {
//
//    init(_ text: String, binding: Binding<Int>) {
//
//    }
//}
