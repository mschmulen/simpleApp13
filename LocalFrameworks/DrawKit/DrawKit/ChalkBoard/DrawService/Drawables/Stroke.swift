//
//  Stroke.swift
//  DrawKit
//
//  Created by Matthew Schmulen on 7/29/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct Stroke: Identifiable {
    
    let id: UUID = UUID()
    
    var uiColor: UIColor
    
    var lineWidth: CGFloat
    
    static var mock: Stroke {
        return Stroke(
            uiColor: UIColor.red,
            lineWidth: CGFloat(3.0)
        )
    }
    
    var color: Color { Color(uiColor) }
    
    var strokeStyle: StrokeStyle {
        return StrokeStyle(
            lineWidth: lineWidth
        )
        
        // .stroke(style: StrokeStyle(lineWidth: 8, dash: [CGFloat(10)]))
        
//        return StrokeStyle(
//            lineWidth: lineWidth,
//            lineCap: .round,
//            lineJoin: .miter,
//            miterLimit: 0,
//            dash: [], //[5, 10],
//            dashPhase: 0
//        )
    }
    
    // .stroke(clipShape(Circle(), style: .init(eoFill: T##Bool, antialiased: <#T##Bool#>)))
    
    var info: String {
        return "stroke info \(color) "
    }
}

extension Stroke: CustomStringConvertible {
    
    var description: String {
        return "\(info)"
    }
    
}

extension Stroke: Codable {
    
    enum CodingKeys: CodingKey {
        case lineWidth
        case uiColor
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let lineWidthString = try container.decode(String.self, forKey: .lineWidth)
        if let lw = Float(lineWidthString) {
            self.lineWidth = CGFloat(lw)
        } else {
            self.lineWidth = 3.0
        }
        
        let colorData = try container.decode(ColorData.self, forKey: .uiColor)
        self.uiColor = colorData.uiColor
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode("\(lineWidth)", forKey: .lineWidth)
        try container.encode(ColorData(uiColor), forKey: .uiColor)
    }
    
}
