//
//  CKChoreAddItemView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/2/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit

struct CKChoreAddItemView: View {
    
    var image: Image {
        Image(systemName:"plus")
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            image
                .renderingMode(.original)
                .resizable()
                .frame(width: 155, height: 155)
                .cornerRadius(5)
            Text("NEW Private Chore")
                .foregroundColor(.primary)
                .font(.caption)
        }
        .padding(.leading, 15)
    }
}//end CKChoreAddItemView
