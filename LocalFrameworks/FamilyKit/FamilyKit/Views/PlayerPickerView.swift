//
//  PlayerPickerView.swift
//  FamilyKit
//
//  Created by Matthew Schmulen on 7/30/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import CloudKit

public struct PlayerPickerView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var familyKitState: FamilyKitState
    
    @State var errorMessage: String?
    
    @State var showNewKid: Bool = false
    @State var newKidName: String = ""
    
    @State var showNewAdult: Bool = false
    @State var newAdultName: String = ""
    
    public var body: some View {
        NavigationView {
            VStack {
                
                Text("Pick Player")
                
                Spacer()
                
                if errorMessage != nil {
                    Text(errorMessage!)
                        .foregroundColor(.red)
                    Spacer()
                }
                
                List {
                    
                    if showNewKid == true {
                        VStack {
                            TextField("kidName", text: $newKidName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            HStack {
                                Button(action: {
                                    print( "save ")
                                    if self.newKidName.isEmpty {
                                        self.errorMessage = "Player name cannot be empty"
                                    } else {
                                        var newModel = CKKidModel()
                                        newModel.bucks = 0
                                        newModel.name = self.newKidName
                                        self.familyKitState.kidService.pushUpdateCreate(model: newModel) { (result) in
                                            switch result {
                                            case .failure(let error):
                                                print( "failure \(error)")
                                            case .success(let record):
                                                self.showNewKid.toggle()
                                            }
                                        }
                                    }
                                }) {
                                    Text("SAVE")
                                }
                                Spacer()
                                Button(action: {
                                    self.showNewKid.toggle()
                                }) {
                                    Text("Cancel")
                                }
                            }
                        }
                    } else {
                        Button(action: {
                            self.showNewKid.toggle()
                        }) {
                            HStack{
                                Text("NEW KID")
                                Image(systemName: "plus")
                            }
                        }
                    }
                    
                    ForEach(self.familyKitState.kidService.models) { model in
                        Button(action: {
                            self.familyKitState.setCurrentPlayer(player: Player.kid(model))
                            //                            self.appState.signIn(user: model)
                            //                            self.appState.topView = .mainView
                            //                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            VStack {
                                Text("\(model.name ?? "~")")
                            }
                        }
                    }
                    
                    if showNewAdult == true {
                        VStack {
                            TextField("adultName", text: $newAdultName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            HStack {
                                
                                
                                Button(action: {
                                    if self.newAdultName.isEmpty {
                                        self.errorMessage = "Player name cannot be empty"
                                    } else {
                                        var newModel = CKAdultModel()
                                        newModel.bucks = 0
                                        newModel.name = self.newAdultName
                                        self.familyKitState.adultService.pushUpdateCreate(model: newModel) { (result) in
                                            switch result {
                                            case .failure(let error):
                                                print( "failure \(error)")
                                            case .success(let record):
                                                self.showNewAdult.toggle()
                                            }
                                        }
                                    }
                                }) {
                                    Text("SAVE")
                                }
                                Spacer()
                                Button(action: {
                                    self.showNewAdult.toggle()
                                }) {
                                    Text("Cancel")
                                }
                            }
                            
                        }
                    } else {
                        Button(action: {
                            self.showNewAdult.toggle()
                        }) {
                            HStack{
                                Text("NEW ADULT")
                                Image(systemName: "plus")
                            }
                        }
                    }
                    
                    ForEach(self.familyKitState.adultService.models) { model in
                        Button(action: {
                            self.familyKitState.setCurrentPlayer(player: Player.adult(model))
                        }) {
                            VStack {
                                Text("\(model.name ?? "~")")
                            }
                        }
                    }
                }
            }
            .onAppear(perform: {
                self.familyKitState.onUpdate()
                //                self.kidService.fetch(completion: { result in
                //                    switch result {
                //                    case .success(let models) :
                //                        print( "kidService success \(models)")
                //                    case .failure(let error):
                //                        print( "choreService error \(error)")
                //                    }
                //                })
                //
                //                self.adultService.fetch(completion: { result in
                //                    switch result {
                //                    case .success(let models) :
                //                        print( "kidService success \(models)")
                //                    case .failure(let error):
                //                        print( "choreService error \(error)")
                //                    }
                //                })
            })
        }//end Navigation
    }//end body
    
    public init() {
    }
    
}
