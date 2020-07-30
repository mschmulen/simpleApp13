//
//  PlayerPickerView.swift
//  FamilyKit
//
//  Created by Matthew Schmulen on 7/30/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

public struct PlayerPickerView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var familyKitState: FamilyKitState
    
    @State var errorMessage: String?
    
    @State var showNewPlayer: Bool = false
    @State var newPlayerName: String = ""
    
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
                
                if showNewPlayer == true {
                    VStack {
                        TextField("name", text: $newPlayerName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Button(action: {
                            print( "save ")
                            if self.newPlayerName.isEmpty {
                                self.errorMessage = "Player name cannot be empty"
                            } else {
                                var newModel = CKKidModel()
                                newModel.bucks = 0
                                newModel.name = self.newPlayerName
                                self.familyKitState.kidService.pushUpdateCreate(model: newModel) { (result) in
                                    switch result {
                                    case .failure(let error):
                                        print( "failure \(error)")
                                    case .success(let record):
                                        self.showNewPlayer.toggle()
                                    }
                                }
                            }
                        }) {
                            Text("SAVE")
                        }
                    }
                }
                
                List {
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
                }
            }
            .onAppear(perform: {
                self.familyKitState.onUpdate()
            })
            .navigationBarItems(trailing: addButton)
        }//end Navigation
    }//end body
    
    private var addButton: some View {
        
        Button(action: {
            self.showNewPlayer.toggle()
        }) {
            Image(systemName: "plus")
        }
    }
    
    public init() {
    }
        
}
