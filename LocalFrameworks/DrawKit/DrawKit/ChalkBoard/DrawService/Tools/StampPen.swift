//
//  StampTool.swift
//  DrawKit
//
//  Created by Matthew Schmulen on 7/29/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct StampPen: DrawableTool {
    
    typealias DrawableToolType = StampPen
    
    let id: UUID = UUID()
    
    let stroke: Stroke
    
    let shape: Stamp.Shape
    
    var info: String {
        return "StampPen \(shape) \(stroke)"
    }
    
    init(stroke: Stroke, shape: Stamp.Shape) {
        self.stroke = stroke
        self.shape = shape
    }
    
    static var mock: StampPen {
        return StampPen(
            stroke: Stroke.mock,
            shape: Stamp.Shape.rectangle
        )
    }
    
}

extension StampPen: Codable {
    
    enum CodingKeys: CodingKey {
        case shape
        case stroke
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.stroke = try container.decode(Stroke.self, forKey: .stroke)
        self.shape = try container.decode(Stamp.Shape.self, forKey: .shape)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(stroke, forKey: .stroke)
        try container.encode(shape, forKey: .shape)
    }
    
}

extension StampPen: CustomStringConvertible {
    var description: String {
        return "\(info)"
    }
}





