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
    
    @State var errorMessage: String?
    @State var showNoiCloudConnection = false
    @State var showNoCurrentPlayer = false
    @State var networkStateViewModel:NetworkStateViewModel = NetworkStateViewModel()
    @State var cloudKitStateViewModel:CloudKitStateViewModel = CloudKitStateViewModel()
    
    @State var showNewPlayer: Bool = false
    
    public var body: some View {
        NavigationView {
            VStack {
                if errorMessage != nil {
                    Text(errorMessage!)
                        .foregroundColor(.red)
                }
                
                Text("Who is Playing")
                    .font(.system(size: 27, weight: .medium, design: .rounded))
                
                if showNewPlayer == true {
                    NewPlayerView(showNewPlayer: $showNewPlayer)
                } else {
                    Button(action: {
                        self.showNewPlayer.toggle()
                    }) {
                        HStack{
                            Image(systemName: "plus")
                            Text("New Player")
                        }
                    }
                }
                
                List {
                    
                    Section(header: Text("kids")) {
                        ForEach(self.familyKitAppState.kidService.models) { model in
                            Button(action: {
                                self.familyKitAppState.setCurrentPlayer(player: Player.kid(model))
                                self.presentationMode.wrappedValue.dismiss()
                            }) {
                                HStack {
                                    Text("\(model.emoji ?? "~")")
                                    Text("\(model.name ?? "~")")
                                }
                            }
                        }
                    }
                    
                    Section(header: Text("adults")) {
                        ForEach(self.familyKitAppState.adultService.models) { model in
                            Button(action: {
                                self.familyKitAppState.setCurrentPlayer(player: Player.adult(model))
                                self.presentationMode.wrappedValue.dismiss()
                            }) {
                                HStack {
                                    Text("\(model.emoji ?? "~")")
                                    Text("\(model.name ?? "~")")
                                }
                            }
                        }
                    }//end Section
                }//end List
                
                VStack {
                    if familyKitAppState.isSimulator == true {
                        Button(action: {
                            self.familyKitAppState.setCurrentPlayer(player: Player.kid(CKKidModel.mock))
                        }) {
                            Text("Simulator only \"mock Player\"")
                                .padding()
                        }
                    }
                    
                    // if networkStateViewModel.pathStatus != .satisfied {
                    Text("network state: \(networkStateViewModel.pathStatus.friendlyString) \(networkStateViewModel.isExpensive ? "true" : "false")")
                        .font(.caption)
                        .foregroundColor(.red)
                    // }
                    
                    Text("current player: \(familyKitAppState.currentPlayer.name)")
                        .font(.caption)
                        .foregroundColor(.red)
                    
                    if familyKitAppState.isCloudKitAvailable {
                        Text("isCloudKitAvailable: \(familyKitAppState.isCloudKitAvailable ? "true" : "false")")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                    
                    if cloudKitStateViewModel.hasFileManagerUbiquityIdentityToken == true {
                        Text("hasFileManagerUbiquityIdentityToken = true")
                            .font(.caption)
                            .foregroundColor(.green)
                    } else {
                        Text("hasFileManagerUbiquityIdentityToken = false")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                    
                    Text("accountStatus: \(cloudKitStateViewModel.accountStatus.friendlyString)")
                        .font(.caption)
                        .foregroundColor(.red)
                }//end VStack
                
            }//end VStack
                .onAppear(perform: {
                })
        }//end Navigation
    }//end body
    
    public init() {
    }
    
}


struct NewPlayerView: View {
    //@Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @Binding var showNewPlayer:Bool
    
    @State var errorMessage: String?
    
    @State var newPlayerName: String = ""
    @State var newPlayerEmoji: String = ""
    
    @State var selectedPlayerType: PlayerType = PlayerType.kid
    
    enum PlayerType: CaseIterable, Hashable, Identifiable {
        case adult
        case kid
        var name: String {
            return "\(self)".map {
                $0.isUppercase ? " \($0)" : "\($0)" }.joined().capitalized
        }
        var id: PlayerType {self}
    }
    
    @State private var stateBirthDate:Date = Calendar.current.date(byAdding: .year, value: -8, to: Date()) ?? Date()
    var starterDate: Date {
        switch selectedPlayerType {
        case .adult:
            return Calendar.current.date(byAdding: .year, value: -35, to: Date()) ?? Date()
        case .kid:
            return Calendar.current.date(byAdding: .year, value: -8, to: Date()) ?? Date()
        }
    }
    
    var body: some View {
        VStack {
            Text("New \(selectedPlayerType.name)")
            HStack {
                Spacer()
                Button(action: {
                    if self.newPlayerName.isEmpty {
                        self.errorMessage = "Player name cannot be empty"
                    } else {
                        
                        switch self.selectedPlayerType {
                        case .kid:
                            var newModel = CKKidModel()
                            newModel.bucks = 0
                            newModel.dateOfBirth = self.stateBirthDate
                            newModel.name = self.newPlayerName
                            newModel.emoji = self.newPlayerEmoji
                            self.familyKitAppState.kidService.pushUpdateCreate(model: newModel) { (result) in
                                switch result {
                                case .failure(let error):
                                    print( "failure \(error)")
                                    self.errorMessage = "failed to create"
                                case .success(_):
                                    self.showNewPlayer.toggle()
                                }
                            }
                        case .adult:
                            var newModel = CKAdultModel()
                            newModel.bucks = 0
                            newModel.dateOfBirth = self.stateBirthDate
                            newModel.name = self.newPlayerName
                            newModel.emoji = self.newPlayerEmoji
                            self.familyKitAppState.adultService.pushUpdateCreate(model: newModel) { (result) in
                                switch result {
                                case .failure(let error):
                                    print( "failure \(error)")
                                    self.errorMessage = "failed to create"
                                case .success(_):
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
                Spacer()
            }//end HStack
            
            TextField("playerName", text: $newPlayerName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("newPlayerEmoji", text: $newPlayerEmoji)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            VStack{
                Text("birthday")
                DatePicker(selection: $stateBirthDate, in: ...starterDate, displayedComponents: .date) {
                    Text("Select your birthday")
                }
                .labelsHidden()
            }
            .padding()
            .border(Color.gray)
            
            Picker(selection: $selectedPlayerType, label: Text("Type")) {
                ForEach(PlayerType.allCases) { v in
                    Text(v.name).tag(v)
                }
            }.pickerStyle(SegmentedPickerStyle())
        }//end VStack
    }
}
