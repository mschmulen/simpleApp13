//
//  CKChoreDescriptionAddItemView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/2/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit

struct CKChoreDescriptionAddItemView: View {
    
    var image: Image {
        Image(systemName:"plus")
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            image
                .renderingMode(.original)
                .resizable()
                .frame(width: 100, height: 100)
                .cornerRadius(5)
            Text("NEW Private Chore")
                .foregroundColor(.primary)
                .font(.caption)
        }
        .padding(.leading, 15)
    }
}//end CKChoreAddItemView

#if DEBUG
struct CKChoreAddItemView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CKChoreDescriptionAddItemView()
                .previewLayout(.fixed(width: 300, height: 300))
            .previewDisplayName("300x300 view")
            
            CKChoreDescriptionAddItemView()
                .previewLayout(.fixed(width: 300, height: 300))
                .environment(\.colorScheme, .dark)
                .previewDisplayName("dark mode")
        }
    }
}
#endif
