//
//  File.swift
//  
//
//  Created by Matthew Schmulen on 8/12/20.
//

import SwiftUI

@available(iOS 13.0, *)
public struct Scribble: Codable {
    var points: [CGPoint] = [CGPoint]()
}

@available(iOS 13.0, *)
public struct ScribbleLayer: Codable, Identifiable {
    public let id:UUID = UUID()
    var scribbles: [Scribble] = [Scribble]()
    var color: DrawingColor = DrawingColor.swiftColor(Color.red)
    var lineWidth: CGFloat = 3.0
    
    mutating func removeLastScribble() {
        if scribbles.count > 0 {
            scribbles.removeLast()
        }
    }
}

@available(iOS 13.0, *)
struct LayerDrawingPad: View {
    
    var layer: ScribbleLayer
    
    var body: some View {
        Path { path in
            for scribble in self.layer.scribbles {
                self.add(scribble: scribble, toPath: &path)
            }
        }
        .stroke(layer.color.color, lineWidth: layer.lineWidth)
    }
    
    private func add(scribble: Scribble, toPath path: inout Path) {
        let points = scribble.points
        if points.count > 1 {
            for i in 0..<points.count-1 {
                let current = points[i]
                let next = points[i+1]
                path.move(to: current)
                path.addLine(to: next)
            }
        }
    }
}
