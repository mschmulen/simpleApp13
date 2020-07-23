//
//  ContentView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 7/19/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.window) var window: UIWindow?
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var marinaStore: SimpleNetworkStore<MarinaModel>
    @EnvironmentObject var boatStore: SimpleNetworkStore<BoatModel>
    
    enum TopView {
        case tabView
        case authenticationView
        case purchaseView
    }
    
    var body: some View {
        Group {
            
            if appState.topView == .tabView {
                TopTabView()
                    .environmentObject(appState)
                    .environmentObject(marinaStore)
                    .environmentObject(boatStore)
            }
            
            if appState.topView == .authenticationView {
                AutheticationView()
                    .environmentObject(appState)
            }
            
            if appState.topView == .purchaseView {
                PurchaseView()
                    .environmentObject(appState)
            }
            
            EmptyView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
