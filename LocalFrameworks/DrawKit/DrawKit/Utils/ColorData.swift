//
//  AppColor.swift
//  DrawKit
//
//  Created by Matthew Schmulen on 7/29/20
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation
import SwiftUI

struct ColorData: Codable {
    
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var alpha: CGFloat = 1.0
    
    var uiColor: UIColor {
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    init(_ uiColor: UIColor) {
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    }
}


//extension Color: Codable {
//
//}

extension Color {
    func uiColor() -> UIColor {
        let hex = self.description
        let space = CharacterSet(charactersIn: " ")
        let trim = hex.trimmingCharacters(in: space)
        let value = hex.first != "#" ? "#\(trim)" : trim
        let values = Array(value)

        func radixValue(_ index: Int) -> CGFloat? {
            var result: CGFloat?
            if values.count > index + 1 {
                var input = "\(values[index])\(values[index + 1])"
                if values[index] == "0" {
                    input = "\(values[index + 1])"
                }
                if let val = Int(input, radix: 16) {
                    result = CGFloat(val)
                }
            }
            return result
        }
        
        var rgb = (red: CGFloat(0), green: CGFloat(0), blue: CGFloat(0), alpha: CGFloat(0))
        if let outputR = radixValue(1) { rgb.red = outputR / 255 }
        if let outputG = radixValue(3) { rgb.green = outputG / 255 }
        if let outputB = radixValue(5) { rgb.blue = outputB / 255 }
        if let outputA = radixValue(7) { rgb.alpha = outputA / 255 }
        return UIColor(red: rgb.red, green: rgb.green, blue: rgb.blue, alpha: rgb.alpha)
    }
}
