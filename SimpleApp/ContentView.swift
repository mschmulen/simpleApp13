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
    
    enum TopView {
        case mainView
        case pickPlayerView
        case purchaseView
    }
    
    @ViewBuilder
    var body: some View {
        Group {
            
            if appState.topView == .mainView {
                MainView()
                    .environmentObject(appState)
            }
            
            if appState.topView == .pickPlayerView {
                PickPlayerView()
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
