//
//  FunDetailView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 7/24/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit

struct FunDetailView: View  {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    var model: FunModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Fun detail")
            model.image
                .renderingMode(.original)
                .resizable()
                .frame(width: 155, height: 155)
                .cornerRadius(5)
            Text(model.name)
                .foregroundColor(.primary)
                .font(.caption)
            
            Button(action: {
                // TODO: fix points
                //self.familyKitAppState.modifyCurrentPlayersBucks(bucks: self.model.bucks)
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("- 2 pts")
            }
        }
        .padding(.leading, 15)
    }
}