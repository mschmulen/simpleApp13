//
//  MarinaViews.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 7/19/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct MarinasView: View {
    
    @Environment(\.window) var window: UIWindow?
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var marinaStore: SimpleNetworkStore<MarinaModel>
    @EnvironmentObject var boatStore: SimpleNetworkStore<BoatModel>
    
    @State var devMessage: String?
    
    var changeSelectedTabCallback: (TopTabView.TabViewIndex)->Void
    
    var body: some View {
        NavigationView {
            List{
                if devMessage != nil {
                    Text("\(devMessage!)")
                        .foregroundColor(.red)
                        .onTapGesture {
                            self.devMessage = nil
                    }
                }
                
                Section(header: Text("Marinas")) {
                    ForEach( marinaStore.models) { model in
                        NavigationLink(destination: MarinaDetail(model: model)) {
                            MarinaRowView(model: model)
                        }
                    }
                }
                
                Section(header: Text("Boats")) {
                    ForEach( boatStore.models) { model in
                        BoatRowView(model: model)
                    }
                }
            }
            .navigationBarTitle("Marinas")
            .navigationBarItems(leading: addButton, trailing: profileButton)
        }
    }
    
    private var addButton: some View {
            Button(action:onAdd) { Image(systemName: "plus") }
    }
    
    func onAdd() {
        self.marinaStore.createModel( MarinaModel.mock)
    }
    
    private var profileButton: some View {
        HStack {
            if appState.currentPurchaseModel == nil {
                Button(action:onProfile) { Image(systemName: "star.circle") }
            } else {
                Button(action:onProfile) { Image(systemName: "star.circle.fill") }
            }
            
            if appState.currentUserModel == nil {
                Button(action:onProfile) { Image(systemName: "person.circle") }
            } else {
                Button(action:onProfile) { Image(systemName: "person.circle.fill") }
            }
        }
    }
    
    func onProfile() {
        changeSelectedTabCallback(.user)
    }
    
}

