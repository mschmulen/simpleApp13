//
//  PlayerOnboardingView.swift
//  FamilyKit
//
//  Created by Matthew Schmulen on 7/30/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import CloudKit

public struct PlayerOnboardingView: View {
    
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
                
                if familyKitAppState.isSimulator == true {
                    Text("SIMULATOR: SOME FEATURES NOT SUPPORTED")
                        .font(.caption)
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
                            Text("Simulator only \"mock Kid\"")
                                .padding()
                        }
                    }
                    
                    if familyKitAppState.isSimulator == true {
                        Button(action: {
                            self.familyKitAppState.setCurrentPlayer(player: Player.adult(CKAdultModel.mock))
                        }) {
                            Text("Simulator only \"mock Adult\"")
                                .padding()
                        }
                    }
                }
                
                VStack {
                    Text("network state: \(networkStateViewModel.pathStatus.friendlyString) \(networkStateViewModel.isExpensive ? "true" : "false")")
                        .font(.caption)
                        .foregroundColor(.red)
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


