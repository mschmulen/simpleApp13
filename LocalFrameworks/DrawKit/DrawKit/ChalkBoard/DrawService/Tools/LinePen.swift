//
//  LinePen.swift
//  DrawKit
//
//  Created by Matthew Schmulen on 7/29/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct LinePen: DrawableTool {
    
    typealias DrawableToolType = LinePen
    
    let id: UUID = UUID()
    
    let stroke:Stroke
    
    let forceOrthogonal:Bool
    
    var info: String {
        return "stroke: \(stroke)"
    }
    
    init(stroke: Stroke, forceOrthogonal:Bool ) {
        self.stroke = stroke
        self.forceOrthogonal = forceOrthogonal
    }
    
    static var mock: LinePen {
        return LinePen(
            stroke: Stroke(uiColor: .white, lineWidth: 3.0),
            forceOrthogonal: false
        )
    }
    
    enum CodingKeys: CodingKey {
        case stroke
        case forceOrthogonal
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.stroke = try container.decode(Stroke.self, forKey: .stroke)
        self.forceOrthogonal = try container.decode(Bool.self, forKey: .forceOrthogonal)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(stroke, forKey: .stroke)
        try container.encode(forceOrthogonal, forKey: .forceOrthogonal)
    }
    
}

extension LinePen: CustomStringConvertible {
    var description: String {
        return info
    }
}
