//
//  ContentView.swift
//  FamilyKitDemo
//
//  Created by Matthew Schmulen on 7/29/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selectedTab: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            Text("CKUser")
                .tabItem {
                    Image(systemName:"wind")
                    Text("CKKids")
            }.tag(0)
            
            Text("CKKid")
                .tabItem {
                    Image(systemName:"wind")
                    Text("CKKids")
            }.tag(1)
            
            Text("CKChore")
                .tabItem {
                    Image(systemName:"wind")
                    Text("CKChore")
            }.tag(2)
            
            Text("CKFun")
                .tabItem {
                    Image(systemName:"wind")
                    Text("CKFun")
            }.tag(3)
            
            Text("CKConnect")
                .tabItem {
                    Image(systemName:"wind")
                    Text("CKConnect")
            }.tag(4)

        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
