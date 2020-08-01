//
//  PurchaseView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 7/19/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit

struct PurchaseView: View {
    
    @Environment(\.window) var window: UIWindow?
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack {
            
            Text("PurchaseView")
            
//            Spacer()
//            VStack(alignment: .center, spacing: 20.0) {
//                Button(action: {
//                    let _ = self.appState.makePurchase(purchase: .premium)
//                    self.appState.topView = .mainView
//                }) {
//                    Text("Yes! purchase premium for $X.XX")
//                }.padding()
//
//                Button(action: {
//                    self.appState.topView = .mainView
//                }) {
//                    Text("No Thanks")
//                }.padding()
//            }.padding()
            
            Spacer()
        }
    }
}

struct PurchaseView_Previews: PreviewProvider {
    static var previews: some View {
        PurchaseView()
    }
}
