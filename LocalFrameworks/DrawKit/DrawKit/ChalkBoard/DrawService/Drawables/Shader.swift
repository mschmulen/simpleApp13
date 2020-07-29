//
//  Shader.swift
//  DrawKit
//
//  Created by Matthew Schmulen on 7/29/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct Shader: Identifiable, Codable {
    
    //typealias DrawableToolType = StampShader
    
    let id: UUID = UUID()
    
    /// stroke color and line attributes
    let stroke: Stroke
    
    /// transformation attributes
    var scale: CGSize
    var offset: CGPoint
    var rotation: CGFloat
    
    var angle: Angle {
        Angle(degrees: Double(rotation))
    }
    
    init(
        stroke: Stroke,
        scale: CGSize = CGSize(width: 1.0, height: 1.0),
        offset: CGPoint = CGPoint(x: 0.0, y: 0.0),
        rotation: CGFloat = 0.0
    ) {
        self.stroke = stroke
        self.scale = scale
        self.offset = offset
        self.rotation = rotation
    }
    
    static var mock: Shader {
        return Shader(
            stroke: Stroke.mock,
            scale: CGSize(width: 100,height: 100),
            offset: CGPoint(x: 100,y: 100),
            rotation: 45.0
        )
    }
    
}

extension Shader {
    
    enum CodingKeys: CodingKey {
        case stroke
        case scaleWidth
        case scaleHeight
        case offsetX
        case offsetY
        case rotation
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.stroke = try container.decode(Stroke.self, forKey: .stroke)
        
        let offsetX = try container.decode(Float.self, forKey: .offsetX)
        let offsetY = try container.decode(Float.self, forKey: .offsetY)
        self.offset = CGPoint(x: CGFloat(offsetX), y: CGFloat(offsetY))
        let scaleWidth = try container.decode(Float.self, forKey: .scaleWidth)
        let scaleHeight = try container.decode(Float.self, forKey: .scaleHeight)
        self.scale = CGSize(width: CGFloat(scaleWidth),height: CGFloat(scaleHeight))
        let rot = try container.decode(Float.self, forKey: .rotation)
        self.rotation = CGFloat(rot)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(stroke, forKey: .stroke)
        
        try container.encode(Float(offset.x), forKey: .offsetX)
        try container.encode(Float(offset.y), forKey: .offsetY)
        
        try container.encode(Float(scale.width), forKey: .scaleWidth)
        try container.encode(Float(scale.height), forKey: .scaleHeight)
        
        try container.encode(Float(rotation), forKey: .rotation)
    }
    
}

extension Shader: CustomStringConvertible {
    
    var info: String {
        return "Shader stroke:\(stroke)"
    }
    
    var description: String {
        return "\(info)"
    }
}


