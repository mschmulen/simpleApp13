//
//  ConnectDetailView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 7/24/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct ConnectDetailView: View  {
    
    @EnvironmentObject var appState: AppState
    
    var model: ConnectModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Connect detail")
            model.image
                .renderingMode(.original)
                .resizable()
                .frame(width: 155, height: 155)
                .cornerRadius(5)
            Text(model.name)
                .foregroundColor(.primary)
                .font(.caption)
            
            Button(action: {
                self.appState.modifyCurrentPlayersPoints(points: +2)
            }) {
                Text("plus 2 pts")
            }

        }
        .padding(.leading, 15)
    }
}
