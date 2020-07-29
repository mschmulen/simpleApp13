//
//  BackgroundLayerPen.swift
//  DrawKit
//
//  Created by Matthew Schmulen on 7/29/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct BackgroundLayerPen: DrawableTool {
    
    typealias DrawableToolType = BackgroundLayerPen
    
    let id: UUID = UUID()

    let stroke: Stroke
    
    var info: String {
        return "BackgroundLayerPen \(stroke)"
    }

    init(stroke: Stroke ) {
        self.stroke = stroke
    }
    
    static var mock:BackgroundLayerPen {
        return BackgroundLayerPen(
            stroke: Stroke(uiColor: .white, lineWidth: 3.0)
        )
    }
    
}

extension BackgroundLayerPen: Codable {
    
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

extension BackgroundLayerPen: CustomStringConvertible {
    var description: String {
        return "\(info)"
    }
}
