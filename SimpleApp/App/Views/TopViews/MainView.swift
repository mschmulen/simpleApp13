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
                    Section(header: Text("Fun")) {
                        ForEach(funStore.models, id: \.self) { model in
                            Text("Fun \(model.name)")
                        }
                    }
                    
                    Section(header: Text("Chores")) {
                        ForEach(choreStore.models, id: \.self) { model in
                            Text("\(model.name)")
                        }
                    }

                    Section(header: Text("Connect")) {
                        ForEach(connectStore.models, id: \.self) { model in
                            Text("\(model.name)")
                        }
                    }
                }
            }
        }
    }
}
