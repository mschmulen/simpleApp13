//
//  LargeTextPillBox.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/28/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct LargeTextPillBox: View {
    
    private let title: String
    
    init(
        _ title: String
    ) {
        self.title = title
    }
    
    var body: some View {
        Text(title)
            .font(.system(size: 27, weight: .bold, design: .rounded))
            .padding()
            .background(SemanticAppColor.random)
            .cornerRadius(10)
            .foregroundColor(Color.white)
    }
}

struct LargeTextPillBox_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LargeTextPillBox("START THIS ACTIVITY")
            
            LargeTextPillBox("Hello, World!")
                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
                .previewDisplayName("iPhone SE")
        }
    }
}
