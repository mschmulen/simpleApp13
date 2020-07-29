//
//  Tool.swift
//  DrawKit
//
//  Created by Matthew Schmulen on 7/29/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

enum Tool {
    
    case scribble( ScribblePen )
    case line( LinePen )
    
    case stamp( StampPen )
    
    case setLayerBackground( BackgroundLayerPen)
    case none
    
    var info:String {
        switch self {
        case .none:
            return "none"
        case .scribble(let pen):
            return "scribble: \(pen.info)"
        case .line(let pen):
            return "line: \(pen.info)"
        case .stamp(let pen):
            return "stamp: \(pen.info)"
        case .setLayerBackground(let pen):
            return "setLayerBackground: \(pen.info)"
        }
    }
    
    static var mock:Tool {
        return Tool.scribble(ScribblePen.mock)
    }
    
}

extension Tool : Codable {
    
    private enum CodingKeys: String, CodingKey {
        case toolType
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        guard let toolTypeName = try? container.decode(String.self, forKey: .toolType) else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: container.codingPath, debugDescription: "Data doesn't match"))
        }
        
        switch toolTypeName {
        case "scribble":
            self = .scribble(ScribblePen.mock)
        case "stamp":
            self = .stamp(StampPen.mock)
        case "setLayerBackground":
            self = .setLayerBackground(BackgroundLayerPen.mock)
        case "none":
            self = .none
        default:
            print( "toolTypeName error: \(toolTypeName)")
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: container.codingPath, debugDescription: "Data doesn't match"))
        }
    }//end decode
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .scribble(let pen):
            try container.encode("scribble", forKey: .toolType)
        case .line(let pen):
            try container.encode("line", forKey: .toolType)
        case .stamp(let pen):
            try container.encode("stamp", forKey: .toolType)
        case .setLayerBackground(let pen):
            try container.encode("setLayerBackground", forKey: .toolType)
        case .none:
            try container.encode("none", forKey: .toolType)
        }
    }//end encode
}//end Codable

extension Tool: CustomStringConvertible {
    var description: String {
        return self.info
    }
}
