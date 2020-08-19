//
//  SemanticAppColor.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/19/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

// Semantic Colors
//For example, Color.red isn’t the pure red of RGB(255, 0, 0), but instead slightly lighter or slightly darker based on the environment – it adapts automatically without us needing to think about it.
//
//Similarly, Color.primary, Color.secondary, and Color.accentColor all refer to fixed values that are provided by the environment, allowing us to structure and highlight content in a standardized way.
//

struct SemanticAppColor {
    
    static let colors = [
        Color(#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)),
        Color(#colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)),
        Color(#colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)),
        Color(#colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)),
        Color(#colorLiteral(red: 0.4993005991, green: 0.1969205439, blue: 0.67317307, alpha: 1)),
        Color(#colorLiteral(red: 0.5808190107, green: 0.0884276256, blue: 0.3186392188, alpha: 1))
    ]
    
    static var random: Color {
        return SemanticAppColor.colors.randomElement()!
    }
}
