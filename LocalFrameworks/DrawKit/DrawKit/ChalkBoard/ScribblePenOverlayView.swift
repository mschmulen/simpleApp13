//
//  ScribblePenOverlayView.swift
//  DrawKit
//
//  Created by Matthew Schmulen on 7/29/20
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct ScribblePenOverlayView: View {

    let transparentColor: Color = Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.0001)

    var pen: ScribblePen
    var applyCallback: ((_ command:Command)->Void)?
    
    @State private var localScribble: Scribble = Scribble.mock
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                self.add(drawing: self.localScribble, toPath: &path)
            }
            .stroke(self.pen.stroke.color, style: self.pen.stroke.strokeStyle)
            .background(self.transparentColor)
            .gesture(
                DragGesture(minimumDistance: 0.1)
                    .onChanged({ (value) in
                        let currentPoint = value.location
                        if currentPoint.y >= 0
                            && currentPoint.y < geometry.size.height {
                            self.localScribble.points.append(currentPoint)
                            
                            self.localScribble.shader = Shader(
                                stroke: self.pen.stroke
                            )
                        }
                    })
                    .onEnded({ (value) in
                        // fish the scribble by applying it to the current layer
                        self.applyEnd()
                    })
            )
        }
        .frame(maxHeight: .infinity)
    }
    
}

extension ScribblePenOverlayView {
    
    private func applyEnd() {
        let command = Command.addScribble(uuid: UUID(), scribble: self.localScribble)
        applyCallback?(command)
        self.newLocalScribble()
    }
    
    private func newLocalScribble() {
        localScribble = Scribble(
            shader: Shader(
                stroke: self.pen.stroke
            )
        )
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
    }
}

struct ScribblePenOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        ScribblePenOverlayView(pen: ScribblePen.mock, applyCallback: nil)
    }
}
