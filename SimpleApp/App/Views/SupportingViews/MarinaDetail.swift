//
//  MarinaDetail.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 7/22/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
struct MarinaDetail: View {
    
    @Environment(\.window) var window: UIWindow?
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var marinaStore: SimpleNetworkStore<MarinaModel>
    @EnvironmentObject var boatStore: SimpleNetworkStore<BoatModel>
    
    @State var devMessage: String?
    
    var model: MarinaModel
    
    var body: some View {
        VStack {
            Text("Marina Detail")
            Text("Name: \(model.name)")
            Text("Info: \(model.info)")
        }
    }
}
