//
//  MainView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 7/23/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation
import SwiftUI
import FamilyKit

struct MainView: View {
    
    @Environment(\.window) var window: UIWindow?
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @State var funStore:FunStore = FunStore(storeConfig: StoreConfig.local)
    @State var choreStore:ChoreStore = ChoreStore(storeConfig: StoreConfig.local)
    @State var connectStore:ConnectStore = ConnectStore(storeConfig: StoreConfig.local)
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Text("Featured View")
                }
                
                List{
                    
                    Section() {
                        FunRowView(categoryName: "Fun", items: funStore.models)
                        
                    }.listRowInsets(EdgeInsets())
                    
                    Section() {
                        ChoreRowView(categoryName: "Chores", items: choreStore.models)
                    }.listRowInsets(EdgeInsets())
                    
                    Section() {
                        ConnectRowView(categoryName: "Connect", items: connectStore.models)
                    }.listRowInsets(EdgeInsets())
                }
            }
            .navigationBarItems(leading: addButton, trailing: profileButton)
        }
    }
    
    private var profileButton: some View {
        Group {
            NavigationLink(destination:
                UserView()
                    .environment(\.window, window)
                    .environmentObject(appState)
                    .environmentObject(familyKitAppState)
                
            ){
                HStack {
                    Text("\(familyKitAppState.currentPlayer.emoji) \(familyKitAppState.currentPlayer.name)")
                    Image(systemName: "person.circle.fill")
                }
            }

            
            // TODO : Clean up
//            if self.appState.currentUserModel == nil {
//                NavigationLink(destination: UserView()){
//                    Image(systemName: "person.circle")
//                }
//            } else {
//                NavigationLink(destination: UserView()){
//                    HStack {
//                        Text("\(familyKitAppState.currentPlayer.emoji) \(familyKitAppState.currentPlayer.name)")
//                        Image(systemName: "person.circle.fill")
//                    }
//                }
//            }
            
        }
    }
    
    private var addButton: some View {
        NavigationLink(destination: NewChoreView() ) {
            Image(systemName: "plus")
        }
    }
        
}






