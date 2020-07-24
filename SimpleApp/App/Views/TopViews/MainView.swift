//
//  MainView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 7/23/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation
import SwiftUI

struct MainView: View {
    
    @Environment(\.window) var window: UIWindow?
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var marinaStore: SimpleNetworkStore<MarinaModel>
    @EnvironmentObject var boatStore: SimpleNetworkStore<BoatModel>
    
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
        NavigationLink(destination: UserView()){
            Image(systemName: "person.circle")
        }
    }
    
    private var addButton: some View {
        NavigationLink(destination: NewChoreView() ) {
            Image(systemName: "plus")
        }
    }
    
}






