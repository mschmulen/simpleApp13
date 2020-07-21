//
//  TopTabView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 7/19/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct TopTabView: View {
    
    @Environment(\.window) var window: UIWindow?
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var marinaStore: SimpleNetworkStore<MarinaModel>
    @EnvironmentObject var boatStore: SimpleNetworkStore<BoatModel>
    
    public enum TabViewIndex: Int {
        case boats = 0
        case marinas = 1
        case user = 2
    }
    
    @State private var selectedTab: Int = TabViewIndex.boats.rawValue
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            BoatsView(changeSelectedTabCallback: changeTab)
                .environmentObject(appState)
                .environmentObject(marinaStore)
                .environmentObject(boatStore)
                .tabItem {
                    Image(systemName:"wind")
                    Text("Boats")
            }.tag(TabViewIndex.boats.rawValue)
            
            MarinasView(changeSelectedTabCallback: changeTab)
                .environmentObject(appState)
                .environmentObject(marinaStore)
                .environmentObject(boatStore)
                .tabItem {
                    Image(systemName:"globe")
                    Text("Marinas")
            }.tag(TabViewIndex.marinas.rawValue)
            
            UserView()
                .environmentObject(appState)
                .tabItem {
                    Image(systemName:"person.circle")
                    Text("User")
            }.tag(TabViewIndex.user.rawValue)
            
        }.onAppear {
            print( "tab appear")
        }
    }
    
    func changeTab(tab: TabViewIndex) {
        self.selectedTab = tab.rawValue
    }
}
