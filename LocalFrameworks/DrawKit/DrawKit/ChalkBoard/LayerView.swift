//
//  LayerPadView.swift
//  DrawKit
//
//  Created by Matthew Schmulen on 7/29/20
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct LayerPadView: View {
    
    let layer: Layer
    
    let transparentColor: Color = Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.0001)
    
    var body: some View {
        ZStack{
            
            GeometryReader { geometry in
                ForEach( self.layer.drawables.items.reversed(), id: \.id ) { drawable in
                    drawable.drawView
                }
            }
        }
        .frame(maxHeight: .infinity)
    }    
}
