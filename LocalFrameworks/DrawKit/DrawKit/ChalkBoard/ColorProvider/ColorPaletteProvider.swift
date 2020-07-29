//
//  ColorPaletteProvider.swift
//  DrawKit
//
//  Created by Matthew Schmulen on 7/29/20
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import UIKit

// palette
struct ColorInfo: Identifiable {
    let id: Int
    let displayName: String
    let uiColor:UIColor
}

class ColorPaletteProvider {
    
    static func supportedColors() -> [ColorInfo] {
        
        var colors = [
            ColorInfo(id: 1, displayName: "Black", uiColor: .black),
            ColorInfo(id: 2, displayName: "White", uiColor: .white),
            ColorInfo(id: 4, displayName: "Red", uiColor: .red),
            ColorInfo(id: 5, displayName: "Green", uiColor: .green),
            ColorInfo(id: 3, displayName: "Blue", uiColor: .blue),
            ColorInfo(id: 6, displayName: "Yellow", uiColor: .yellow),
            ColorInfo(id: 7, displayName: "Orange", uiColor: .orange),
            ColorInfo(id: 8, displayName: "Gray", uiColor: .gray),
            //ColorInfo(id: 9, displayName: "Pink", uiColor: .pink),
            ColorInfo(id: 10, displayName: "Purple", uiColor: .purple)
        ]
        
//        let semanticColors = [
//            Color.white,
//            Color.black,
//            Color.gray,
//            Color.red,
//            Color.green,
//            Color.blue,
//            Color.purple,
//            Color.pink
//        ]
//
//        let sColors = semanticColors.map { (colorIn) -> ColorInfo in
//            return ColorInfo(
//                id: colorIn.hashValue,
//                displayName: "semantic\(colorIn.hashValue)",
//                uiColor: colorIn.uiColor()
//            )
//        }
//        colors.append(contentsOf: sColors)
        return colors
    }
    
}
