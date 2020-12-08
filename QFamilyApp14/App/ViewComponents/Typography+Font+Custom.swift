//
//  Typography+Font+Custom.swift
//  QFamilyApp14
//
//  Created by Matthew Schmulen on 10/15/20.
//

import SwiftUI

// Typography + Font

extension Font {
    
    static let DefaultHeader = Font.system(size: 27.0, weight: .medium, design: .rounded)
    
    static let DefaultBody = Font.system(size: 22, weight: .medium, design: .rounded)
    
    
    static func appFont(size: CGFloat) -> Font {
        //return Font.custom("Yack", size: size)
        return Font.system(size:size)
    }
    
    static let appTitle = appFont(size: 32).weight(.semibold)
    static let appBody = appFont(size: 20).weight(.medium)
    static let appCaption = appFont(size: 14).weight(.regular)
    
}

