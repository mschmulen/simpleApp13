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
    
    @State var devMessage:String?
    
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
                
                Section(header: Text("Boats")) {
                    ForEach( boatStore.models) { model in
                        Text("\(model.name)")
                    }
                }
                
                Section(header: Text("Marinas")) {
                    ForEach( marinaStore.models) { model in
                        Text("\(model.name)")
                    }
                }
                
            }
            .navigationBarTitle("Marinas")
            .navigationBarItems(leading: addButton, trailing: profileButton)
        }.onAppear {
            print("MarinasView.onAppear")
        }
    }
    
    private var addButton: some View {
            Button(action:onAdd) { Image(systemName: "plus") }
    }
    
    func onAdd() {
        self.marinaStore.addModel( MarinaModel.mock)
    }
    
    private var profileButton: some View {
        if appState.currentUserModel == nil {
            return AnyView(
            Button(action:onProfile) { Image(systemName: "person.circle") })
        } else {
            return AnyView(
            Button(action:onProfile) { Image(systemName: "person.circle.fill") })
        }
    }
    
    func onProfile() {
        changeSelectedTabCallback(.user)
    }
        
}

