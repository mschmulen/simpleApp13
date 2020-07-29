//
//  ColorPicker.swift
//  DrawKit
//
//  Created by Matthew Schmulen on 7/29/20
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct ColorPickerView: View {
    
    @Binding var color: Color
    @Binding var colorPickerShown: Bool
    
    private let colors = ColorPaletteProvider.supportedColors()
    
    var body: some View {
        List(colors) { colorInfo in
            ColorEntry(colorInfo: colorInfo).onTapGesture {
                self.color = Color(colorInfo.uiColor)
                self.colorPickerShown = false
            }
        }
    }//end body
}
