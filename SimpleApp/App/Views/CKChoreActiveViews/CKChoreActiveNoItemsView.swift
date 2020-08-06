//
//  CKChoreDescriptionNoItemsView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/2/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct CKChoreActiveNoItemsView: View {
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                Rectangle()
                    .foregroundColor(.gray)
                    .frame(width: 155, height: 155)
                    .cornerRadius(5)
                VStack {
                    Text("No Chores")
                        .foregroundColor(.white)
                        .font(.body)
                    Text("ask an Adult")
                        .foregroundColor(.white)
                        .font(.body)
                    Text("to add some")
                        .foregroundColor(.white)
                        .font(.body)
                }
            }
        }
        .padding(.leading, 15)
    }
}//end CKChoreNoItemsView

struct CKChoreActiveNoItemsView_Previews: PreviewProvider {
    static var previews: some View {
        CKChoreActiveNoItemsView()
    }
}
