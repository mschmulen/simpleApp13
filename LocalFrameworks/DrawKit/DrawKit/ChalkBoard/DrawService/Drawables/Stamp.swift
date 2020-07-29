//
//  Stamp.swift
//  DrawKit
//
//  Created by Matthew Schmulen on 7/29/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import CoreGraphics
import Foundation
import SwiftUI

struct Stamp: Drawable, Codable {
    
    typealias DrawableType = Stamp
    
    let id: UUID = UUID()
    
    var shader: Shader
    
    var shape: Shape
    
    var info: String {
        return " pen:\(shader) shape: \(shape)"
    }
    
    static var mock: Stamp {
        return Stamp(
            shader: Shader.mock,
            shape: .rectangle
        )
    }
    
    enum Shape: Codable, CaseIterable, Identifiable {
        
        case rectangle
        case circle
        
        case customShape( shape: CustomStampShape, name: String)
        
        static var allCases: [Shape] {
            return [
                Shape.rectangle,
                Shape.circle,
                Shape.customShape( shape: .star, name: "star"),
                Shape.customShape( shape: .arrow, name: "arrow"),
                Shape.customShape( shape: .heart, name: "heart")
            ]
        }
        
        var id: UUID {
            return UUID()
        }
        
        var info: String {
            switch self {
            case .rectangle: return "rectangle"
            case .circle: return "circle"
            case .customShape(let customStampShape, let name):
                return "name:\(name) customStampShape:\(customStampShape)"
            }
        }
        
        private enum CodingKeys: String, CodingKey {
            case shapeName
            case customShapeName
        }
        
        init(from decoder: Decoder) throws {
            
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            guard let shapeName = try? container.decode(String.self, forKey: .shapeName) else {
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: container.codingPath, debugDescription: "Data doesn't match"))
            }
            
            switch shapeName {
            case "circle":
                self = .circle
            case "rectangle":
                self = .rectangle
            case "custom":
                let customShapeName = try container.decode(String.self, forKey: .customShapeName)
                switch customShapeName {
                case "arrow":
                    self = .customShape(shape: .arrow, name: customShapeName)
                case "heart":
                    self = .customShape(shape: .heart, name: customShapeName)
                case "star":
                    self = .customShape(shape: .star, name: customShapeName)
                default:
                    print( "customShapeName error: \(customShapeName)")
                    throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: container.codingPath, debugDescription: "Data doesn't match"))
                }
            default:
                print( "shapeString error: \(shapeName)")
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: container.codingPath, debugDescription: "Data doesn't match"))
            }
        }//end decode
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            switch self {
            case .circle:
                try container.encode("circle", forKey: .shapeName)
            case .rectangle:
                try container.encode("rectangle", forKey: .shapeName)
            case .customShape(let shape, let name):
                try container.encode("custom", forKey: .shapeName)
                try container.encode(name, forKey: .customShapeName)
            }
        }//end encode
    }//end Shape enum
    
    enum CustomStampShape: Codable, CaseIterable, Identifiable {
        
        case star
        case arrow
        case heart
        
        var id: UUID {
            return UUID()
        }
        
        private enum CodingKeys: String, CodingKey {
            case shapeStampName
        }
        
        init(from decoder: Decoder) throws {
            
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            guard let shapeStampName = try? container.decode(String.self, forKey: .shapeStampName) else {
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: container.codingPath, debugDescription: "Data doesn't match"))
            }
            
            switch shapeStampName {
            case "star":
                self = .star
            case "arrow":
                self = .arrow
            case "heart":
                self = .heart
            default:
                print( "shapeString error: \(shapeStampName)")
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: container.codingPath, debugDescription: "Data doesn't match"))
            }
        }//end decode
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            switch self {
            case .star:
                try container.encode("star", forKey: .shapeStampName)
            case .arrow:
                try container.encode("arrow", forKey: .shapeStampName)
            case .heart:
                try container.encode("heart", forKey: .shapeStampName)
            }
        }//end encode
    }//end CustomStampShape enum
    
}//end Stamp

extension Stamp: CustomStringConvertible {
    var description: String {
        return "shape: \(shape) pen:\(shader.info)"
    }
}

extension Stamp {
    
    var drawView: AnyView {
        AnyView(stampView)
    }
    
    var stampView: some View {
        switch self.shape {
        case .customShape(let shape, _):
            switch shape {
            case .heart:
                let view = HeartShape()
                    .fill(self.shader.stroke.color)
                    .frame(width: self.shader.scale.width, height: self.shader.scale.height)
                    .rotationEffect(self.shader.angle, anchor: .center)
                    .position(self.shader.offset)
                return AnyView(view)
            case .star:
                let view = StarShape(corners: 5, smoothness: 0.45)
                    .fill(self.shader.stroke.color)
                    .frame(width: self.shader.scale.width, height: self.shader.scale.height)
                    .rotationEffect(self.shader.angle, anchor: .center)
                    .position(self.shader.offset)
                return AnyView(view)
            case .arrow:
                let view = ArrowShape()
                    .fill(self.shader.stroke.color)
                    .frame(width: self.shader.scale.width, height: self.shader.scale.height)
                    .rotationEffect(self.shader.angle, anchor: .center)
                    .position(self.shader.offset)
                return AnyView(view)
            }
        case .rectangle:
            let view = Rectangle()
                .size(self.shader.scale)
                .rotation(self.shader.angle, anchor: .center)
                .offset(self.shader.offset)
                .fill(self.shader.stroke.color)
            return AnyView(view)
        case .circle:
            let view = Circle()
                .size(self.shader.scale)
                .rotation(self.shader.angle, anchor: .center)
                .offset(self.shader.offset)
                .fill(self.shader.stroke.color)
            return AnyView(view)
        }
    }
    
}
