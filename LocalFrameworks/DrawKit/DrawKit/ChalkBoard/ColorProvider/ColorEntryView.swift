//
//  ColorEntry.swift
//
//  Created by Matthew Schmulen on 7/29/20
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct ColorEntry: View {
    
    let colorInfo: ColorInfo
    
    var body: some View {
        HStack {
            Rectangle()
                .fill(Color(colorInfo.uiColor))
//                .padding()
                .border(Color.black)
                .frame(width: 40, height: 40)
                .padding(.all)
            Text(colorInfo.displayName)
        }
    }
}
