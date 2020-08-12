//
//  DrawingPad.swift
//  
//
//  Created by Matthew Schmulen on 8/12/20.
//

import SwiftUI

struct DrawingPad: View {
    
    @Binding var drawingState: DrawingState
    
    @Binding var currentColor: Color
    @Binding var currentLineWidth: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach( self.drawingState.layers) { layer in
                    LayerDrawingPad(layer: layer)
                }
                
                Path { path in
                    for scribble in self.drawingState.scribbles {
                        self.add(scribble: scribble, toPath: &path)
                    }
                }
                .stroke(self.currentColor, lineWidth: self.currentLineWidth)
                
                Path { path in
                    self.add(scribble: self.drawingState.currentScribble, toPath: &path)
                }
                .stroke(self.currentColor, lineWidth: self.currentLineWidth)
            }
            .background(Color(white: 0.95))
            .gesture(
                DragGesture(minimumDistance: 0.1)
                    .onChanged({ (value) in
                        let currentPoint = value.location
                        if currentPoint.y >= 0
                            && currentPoint.y < geometry.size.height {
                            self.drawingState.currentScribble.points.append(currentPoint)
                        }
                    })
                    .onEnded({ (value) in
                        self.drawingState.scribbles.append(self.drawingState.currentScribble)
                        self.drawingState.currentScribble = Scribble()
                    })
            )
        }
        .frame(maxHeight: .infinity)
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


