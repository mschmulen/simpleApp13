//
//  ChoreDetailView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 7/24/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit

struct ChoreDetailView: View  {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode

    @EnvironmentObject var appState: AppState
    @EnvironmentObject var familyKitAppState: FamilyKitAppState

    var model: ChoreModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Chore detail")
            model.image
                .renderingMode(.original)
                .resizable()
                .frame(width: 155, height: 155)
                .cornerRadius(5)
            Text(model.name)
                .foregroundColor(.primary)
                .font(.caption)
            Text(model.description)
            Button(action: {
                // TODO: fix points
                self.familyKitAppState.modifyCurrentPlayersBucks(bucks: self.model.bucks)
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("+ \(self.model.bucks) pts")
            }
        }
        .padding(.leading, 15)
    }
}

struct NewChoreView: View  {
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("New  detail")
//            model.image
//                .renderingMode(.original)
//                .resizable()
//                .frame(width: 155, height: 155)
//                .cornerRadius(5)
//            Text(model.name)
//                .foregroundColor(.primary)
//                .font(.caption)
        }
        .padding(.leading, 15)
    }
}


//
//struct ChoreDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChoreDetailView(model: ChoreModel.moc)
//    }
//}
