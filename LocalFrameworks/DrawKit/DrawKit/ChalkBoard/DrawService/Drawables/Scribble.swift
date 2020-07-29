//
//  Scribble.swift
//  DrawKit
//
//  Created by Matthew Schmulen on 7/29/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import CoreGraphics
import Foundation
import SwiftUI

struct Scribble: Drawable, Codable {

    typealias DrawableType = Scribble
    
    let id: UUID = UUID()
    
    var points: [CGPoint] = [CGPoint]()
    
    //var size: CGSize
    var offset: CGPoint = CGPoint(x: 0,y: 0)
    
    var shader: Shader
    
    var info: String {
        return "points: \(points.count) shader: \(shader.info)"
    }
    static var mock: Scribble {
        return Scribble(
            shader: Shader(
                stroke: Stroke(uiColor: .white, lineWidth: 3.0)
            )
        )
    }
}

extension Scribble: CustomStringConvertible {
    var description: String {
        return "points: \(points.count) shader:\(shader.info)"
    }
}

extension Scribble {
    
    var drawView: AnyView {
        return AnyView(scribbleView)
    }
    
    var scribbleView: some View {
        GeometryReader { geometry in
            Path { path in
                self.add(drawing: self, toPath: &path)
            }
            .stroke(self.shader.stroke.color, style: self.shader.stroke.strokeStyle)
            //.background(self.transparentColor)
        }
        .frame(maxHeight: .infinity)
    }
    
    private func add(drawing: Scribble, toPath path: inout Path) {
        let points = drawing.points
        if points.count > 1 {
            for i in 0..<points.count-1 {
                let current = points[i]
                let next = points[i+1]
                path.move(to: current)
                path.addLine(to: next)
            }
        }
    }//end add
}



