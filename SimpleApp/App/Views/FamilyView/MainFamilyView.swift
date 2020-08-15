//
//  MainFamilyView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/13/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation
import SwiftUI
import FamilyKit
import CloudKit

struct MainFamilyView: View {
    
    @Environment(\.window) var window: UIWindow?
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var privateChoreService: CKPrivateModelService<CKActivityDescriptionModel>
    @EnvironmentObject var privateActiveChoreService: CKPrivateModelService<CKActivityModel>
    @EnvironmentObject var chatService: ChatService
    
    @State var devMessage: String?
    
    // playerPickerView
    let cardSize:CGFloat = 50
    let cardRadius:CGFloat = 20
    
    enum Filter {
        case allFamily
        case person( CKPlayerModel)
        
        var name:String {
            switch self {
            case .allFamily:
                return "All Family"
            case .person( let playerModel):
                return "\(playerModel.name ?? "~")"
            }
        }
    }
    @State var currentFilter = Filter.allFamily
    
    var playerPickerView: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack {
                VStack {
                    Text("🏡")
                        .font(.body)
                    Spacer()
                    Text("Family")
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundColor(Color(.white))
                }
                .frame(width: cardSize, height: cardSize)
                .padding()
                .background(Color.blue)
                .cornerRadius(cardRadius)
                .onTapGesture {
                    self.currentFilter = Filter.allFamily
                }
                
                ForEach( self.familyKitAppState.playerService.models ) { player in
                    VStack {
                        Text("\(player.emoji ?? "")")
                        Spacer()
                        Text("\(player.name ?? "")")
                            .font(.system(size: 15, weight: .medium, design: .rounded))
                    }
                    .frame(width: self.cardSize, height: self.cardSize)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(self.cardRadius)
                    .onTapGesture {
                        self.currentFilter = Filter.person( player )
                    }
                }
            }.padding()
        }//end ScrollView
    }//end playerPickerView
    
    var body: some View {
        NavigationView {
            VStack {
                DevMessageView(devMessage: $devMessage)
                
                List {
                    playerPickerView
                    Section(header: Text("\(currentFilter.name)")) {
                        ForEach( privateActiveChoreService.models) { model in
                            NavigationLink(
                                destination: CKActivityActiveDetailView(
                                    model: model
                                )
                            ){
                                FamilyActivityCardView(model:model)
                            }
                        }
                        
                    }
                }
                
                Text("version \(AppModel().appShortVersion)(\(AppModel().appBuildVersion))")
                    .font(.caption)
            }//end VStack
                .navigationBarTitle("Family")
                
                .navigationBarItems(leading: leadingButton, trailing: trailingButton)
                .onReceive(NotificationCenter.default.publisher(for: FamilyKitNotifications.CKChangedNotification)) { _ in
                    print("Notification.Name(CloudKitModelService) recieved")
                    self.devMessage = "silent Push! DB changed"
                    
                    self.privateChoreService.fetch { (result) in
                        print( "result")
                    }
                    self.privateActiveChoreService.fetch { (result) in
                        print( "result")
                    } }
            
        }//end Navigation
    }//end body
    
    private var trailingButton: some View {
        Group {
            NavigationLink(destination:
                AdultUserView()
                    .environment(\.window, window)
                    .environmentObject(appState)
                    .environmentObject(familyKitAppState)
            ){
                HStack {
                    Text("\(familyKitAppState.currentPlayer.name)")
                    Text("\(familyKitAppState.currentPlayer.emoji)")
                }
            }
        }
    }
    
    private var leadingButton: some View {
        NavigationLink(destination:
            PlayerOnboardingView()
                .environment(\.window, window)
                .environmentObject(familyKitAppState)
                .environmentObject(privateChoreService)
        ){
            HStack {
                Text("change player")
            }
        }
    }
}

struct MainFamilyView_Previews: PreviewProvider {
    
    static let container = CKContainer(identifier: CKContainerIdentifier)
    
    static var previews: some View {
        MainFamilyView()
            .environmentObject(AppState())
            .environmentObject((FamilyKitAppState(container: container)))
            .environmentObject(CKPrivateModelService<CKActivityDescriptionModel>(container:container))
            .environmentObject(CKPrivateModelService<CKActivityModel>(container: container))
            .environmentObject(ChatService(container:container))
        
    }
}