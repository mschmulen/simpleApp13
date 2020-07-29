//
//  Line.swift
//  DrawKit
//
//  Created by Matthew Schmulen on 7/29/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import CoreGraphics
import Foundation
import SwiftUI

struct Line: Drawable, Codable {
    
    typealias DrawableType = Line
    
    let id: UUID = UUID()
    
    //var points: [CGPoint] = [CGPoint]()
    var startPoint: CGPoint = CGPoint(x: 0,y: 0)
    var endPoint: CGPoint = CGPoint(x: 0,y: 0)

    //var size: CGSize
    var offset: CGPoint = CGPoint(x: 0,y: 0)
    
    var shader: Shader
    
    var info: String {
        return "shader: \(shader.info)"
    }
    static var mock: Line {
        return Line(
            shader: Shader(
                stroke: Stroke(uiColor: .white, lineWidth: 3.0)
            )
        )
    }
}

extension Line: CustomStringConvertible {
    var description: String {
        return " shader:\(shader.info)"
    }
}

extension Line {
    var drawView: AnyView {
        return AnyView(
            lineView
        )
    }
    
    var lineView: some View {
        GeometryReader { geometry in
            Path { path in
                path.move(to: self.startPoint)
                path.addLine(to: self.endPoint)
            }
            .stroke(self.shader.stroke.color, style: self.shader.stroke.strokeStyle)
            //.background(self.transparentColor)
        }
        .frame(maxHeight: .infinity)
    }
    
}
