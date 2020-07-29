//
//  ScribbleTool.swift
//  DrawKit
//
//  Created by Matthew Schmulen on 7/29/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct ScribblePen: DrawableTool {
    
    typealias DrawableToolType = ScribblePen
    
    let id: UUID = UUID()
    
    let stroke:Stroke
    
    var info: String {
        return "stroke: \(stroke)"
    }
    
    init(stroke: Stroke ) {
        self.stroke = stroke
    }
    
    static var mock: ScribblePen {
        return ScribblePen(
            stroke: Stroke(uiColor: .white, lineWidth: 3.0)
        )
    }
    
    enum CodingKeys: CodingKey {
        case stroke
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.stroke = try container.decode(Stroke.self, forKey: .stroke)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(stroke, forKey: .stroke)
    }
    
}

extension ScribblePen: CustomStringConvertible {
    var description: String {
        return info
    }
}

