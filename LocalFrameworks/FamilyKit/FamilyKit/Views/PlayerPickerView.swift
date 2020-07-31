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
    
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
//    @State var kidService: CKPrivateModelService<CKKidModel> = CKPrivateModelService<CKKidModel>(
//        container: CKContainer(identifier: CKContainerIdentifier)
//    )
//    @State var adultService: CKPrivateModelService<CKAdultModel> = CKPrivateModelService<CKAdultModel>(
//        container: CKContainer(identifier: CKContainerIdentifier)
//    )
    
    @State var errorMessage: String?
    
    @State var showNewPlayer: Bool = false
    @State var newPlayerName: String = ""
    
    @State private var selectedPlayerType = PlayerType.adult
    enum PlayerType: CaseIterable, Hashable, Identifiable {
        case adult
        case kid
        var name: String {
            return "\(self)".map {
                $0.isUppercase ? " \($0)" : "\($0)" }.joined().capitalized
        }
        var id: PlayerType {self}
    }
    
    public var body: some View {
        NavigationView {
            VStack {
                if errorMessage != nil {
                    Text(errorMessage!)
                        .foregroundColor(.red)
                }
                Text("Who is Playing")
                
                if showNewPlayer == true {
                    VStack {
                        TextField("playerName", text: $newPlayerName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Picker(selection: $selectedPlayerType, label: Text("Type")) {
                            ForEach(PlayerType.allCases) { v in
                                Text(v.name).tag(v)
                            }
                        }.pickerStyle(SegmentedPickerStyle())
                        
                        HStack {
                            Button(action: {
                                print( "save ")
                                if self.newPlayerName.isEmpty {
                                    self.errorMessage = "Player name cannot be empty"
                                } else {
                                    
                                    switch self.selectedPlayerType {
                                    case .kid:
                                        var newModel = CKKidModel()
                                        newModel.bucks = 0
                                        newModel.name = self.newPlayerName
                                        self.familyKitAppState.kidService.pushUpdateCreate(model: newModel) { (result) in
                                            switch result {
                                            case .failure(let error):
                                                print( "failure \(error)")
                                            case .success(let record):
                                                self.showNewPlayer.toggle()
                                            }
                                        }
                                    case .adult:
                                        var newModel = CKAdultModel()
                                        newModel.bucks = 0
                                        newModel.name = self.newPlayerName
                                        self.familyKitAppState.adultService.pushUpdateCreate(model: newModel) { (result) in
                                            switch result {
                                            case .failure(let error):
                                                print( "failure \(error)")
                                            case .success(let record):
                                                self.showNewPlayer.toggle()
                                            }
                                        }
                                    }
                                    
                                }
                            }) {
                                Text("SAVE")
                            }
                            Spacer()
                            Button(action: {
                                self.showNewPlayer.toggle()
                            }) {
                                Text("Cancel")
                            }
                        }
                    }
                } else {
                    Button(action: {
                        self.showNewPlayer.toggle()
                    }) {
                        HStack{
                            Text("NEW Player")
                            Image(systemName: "plus")
                        }
                    }
                }
                                
                List {
                    Section(header: Text("kids")) {
                        ForEach(self.familyKitAppState.kidService.models) { model in
                            Button(action: {
                                self.familyKitAppState.setCurrentPlayer(player: Player.kid(model))
                                //                            self.appState.signIn(user: model)
                                //                            self.appState.topView = .mainView
                                //                            self.presentationMode.wrappedValue.dismiss()
                            }) {
                                HStack {
                                    Text("\(model.name ?? "~")")
                                    Text("\(model.emoji ?? "~")")
                                }
                            }
                        }
                    }
                    
                    Section(header: Text("adults")) {
                        ForEach(self.familyKitAppState.adultService.models) { model in
                            Button(action: {
                                self.familyKitAppState.setCurrentPlayer(player: Player.adult(model))
                            }) {
                                HStack {
                                    Text("\(model.name ?? "~")")
                                    Text("\(model.emoji ?? "~")")
                                }
                            }
                        }
                    }
                }
            }
            .onAppear(perform: {
                //self.familyKitAppState.onUpdate()
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
