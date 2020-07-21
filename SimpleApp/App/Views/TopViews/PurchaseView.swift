//
//  PurchaseView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 7/19/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct PurchaseView: View {
    
    @Environment(\.window) var window: UIWindow?
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        List{
            Text("PurchaseView")
            
            Button(action: {
                print( "Purchase")
            }) {
                Text("Purchase")
            }
            
            Button(action: {
                print("Cancel Purchase View")
            }) {
                Text("Cancel")
            }
        }
    }
}

