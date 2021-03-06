//
//  PlayerSelectView.swift
//  FamilyKit
//
//  Created by Matthew Schmulen on 7/30/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import CloudKit

public struct PlayerSelectView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var activityDescriptionService: CKPrivateModelService<CKActivityDescriptionModel>
    @EnvironmentObject var activityService: CKPrivateModelService<CKActivityModel>
    
    @State var errorMessage: String?
    @State var showNoiCloudConnection = false
    @State var showNoCurrentPlayer = false
    @State var networkStateViewModel: NetworkStateViewModel = NetworkStateViewModel()
    @State var cloudKitStateViewModel: CloudKitStateViewModel = CloudKitStateViewModel()
    
    @State var showNewPlayer: Bool = false
    
    @Binding var backgroundColor: Color
    
    public var body: some View {
        NavigationView {
            
            ZStack {
                backgroundColor
                    .edgesIgnoringSafeArea(.vertical)
                    // .scaledToFill()
                    //.frame(maxWidth: .infinity, maxHeight: .infinity)
                    //.background(backgroundColor)
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
                        .foregroundColor(.white)
                    
                    if showNewPlayer == true {
                        NewPlayerView(showNewPlayer: $showNewPlayer)
                    } else {
                        Button(action: {
                            self.showNewPlayer.toggle()
                        }) {
                            HStack{
                                Image(systemName: "plus")
                                    .foregroundColor(.white)
                                Text("Add User to this Account")
                                    .foregroundColor(.white)
                            }.padding()
                        }
                    }
                    
                    List {
                        ForEach(self.familyKitAppState.playerService.models) { model in
                            Button(action: {
                                // currentPlayerRecordIDRecordName = model.recordID?.recordName
                                self.familyKitAppState.setCurrentPlayer(
                                    playerModel: model
                                )
                                self.presentationMode.wrappedValue.dismiss()
                            }) {
                                HStack {
                                    Text("\(model.emoji ?? "~")")
                                    Text("\(model.name ?? "~")")
                                    Text( "\(model.isAdult ? "(Adult)": "(Kid)")")
                                }
                            }
                        }
                    }//end List
                    
                    if showNewPlayer == false {
                        NavigationLink(
                            destination: InviteUserView()
                        ) {
                            HStack{
                                Image(systemName: "plus")
                                    .foregroundColor(.white)
                                Text("Invite User")
                                    .foregroundColor(.white)
                            }.padding()
                        }
                    }
                    
                    VStack {
                        if familyKitAppState.isSimulator == true {
                            Button(action: {
                                
                                self.familyKitAppState.setCurrentPlayer(
                                    playerModel: CKPlayerModel.mockKid
                                )
                                
                                // lets also set up some mock cards.
                                self.activityDescriptionService.models.append( CKActivityDescriptionModel.mock )
                                self.activityDescriptionService.models.append( CKActivityDescriptionModel.mock )
                                self.activityService.models.append( CKActivityModel.mock )
                                self.activityService.models.append( CKActivityModel.mock )
                                
                            }) {
                                Text("Simulator only \"mock Kid\"")
                                    .padding()
                            }
                        }
                        
                        if familyKitAppState.isSimulator == true {
                            Button(action: {
                                
                                self.familyKitAppState.setCurrentPlayer(
                                    playerModel: CKPlayerModel.mock
                                )
                                
                                // lets also set up some mock cards.
                                self.activityDescriptionService.models.append( CKActivityDescriptionModel.mock )
                                self.activityDescriptionService.models.append( CKActivityDescriptionModel.mock )
                                self.activityService.models.append( CKActivityModel.mock )
                                self.activityService.models.append( CKActivityModel.mock )
                                
                            }) {
                                Text("Simulator only \"mock Adult\"")
                                    .padding()
                            }
                        }
                    }
                    
                    //                VStack {
                    //                    Text("network state: \(networkStateViewModel.pathStatus.friendlyString) \(networkStateViewModel.isExpensive ? "true" : "false")")
                    //                        .font(.caption)
                    //                        .foregroundColor(.red)
                    //                    Text("current player: \(familyKitAppState.currentPlayer.name)")
                    //                        .font(.caption)
                    //                        .foregroundColor(.red)
                    //                    if familyKitAppState.isCloudKitAvailable {
                    //                        Text("isCloudKitAvailable: \(familyKitAppState.isCloudKitAvailable ? "true" : "false")")
                    //                            .font(.caption)
                    //                            .foregroundColor(.red)
                    //                    }
                    //                    if cloudKitStateViewModel.hasFileManagerUbiquityIdentityToken == true {
                    //                        Text("hasFileManagerUbiquityIdentityToken = true")
                    //                            .font(.caption)
                    //                            .foregroundColor(.green)
                    //                    } else {
                    //                        Text("hasFileManagerUbiquityIdentityToken = false")
                    //                            .font(.caption)
                    //                            .foregroundColor(.red)
                    //                    }
                    //                    Text("accountStatus: \(cloudKitStateViewModel.accountStatus.friendlyString)")
                    //                        .font(.caption)
                    //                        .foregroundColor(.red)
                    //                }//end VStack
                    
                }//end VStack
            }// end ZStack
            .onAppear(perform: {
                
                //                    if let currentPlayerRecordIDRecordName = currentPlayerRecordIDRecordName {
                //                        print ("currentPlayerRecordIDRecordName \(currentPlayerRecordIDRecordName)")
                //
                //
                //                    }
            })
        }//end Navigation
    }//end body
    
    public init(backgroundColor: Binding<Color>) {
        self._backgroundColor = backgroundColor
    }
    
}

// TODO: Fix PlayerSelectView_Previews
struct PlayerSelectView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
        
        //PlayerSelectView()
    }
}




