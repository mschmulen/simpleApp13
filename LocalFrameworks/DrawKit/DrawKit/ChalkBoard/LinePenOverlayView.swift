//
//  LinePenOverlayView.swift
//  DrawKit
//
//  Created by Matthew Schmulen on 7/29/20
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct LinePenOverlayView: View {

    let transparentColor: Color = Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.0001)

    var pen: LinePen
    var applyCallback: ((_ command:Command)->Void)?
    
    @State private var hasSetFirstPoint = false
    @State private var lineStartPoint: CGPoint = CGPoint(x: 0.0, y: 0.0)
    @State private var lineEndPoint: CGPoint = CGPoint(x: 0.0, y: 0.0)
    
    @State private var localLine: Line = Line.mock
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                path.move(to: self.localLine.startPoint)
                path.addLine(to: self.localLine.endPoint)
            }
            .stroke(self.pen.stroke.color, style: self.pen.stroke.strokeStyle)
            .background(self.transparentColor)
            .gesture(
                DragGesture(minimumDistance: 0.1)
                    .onChanged({ (value) in
                        let currentPoint = value.location
                        
                        if self.hasSetFirstPoint == false {
                            self.lineStartPoint = currentPoint
                            self.hasSetFirstPoint = true
                        }
                        else {
                            self.lineEndPoint = currentPoint
                        }
                        
                        if currentPoint.y >= 0
                            && currentPoint.y < geometry.size.height {
                            
                            if self.pen.forceOrthogonal == true {
                                // MAS TODO Lock the vertica or horizontal axis
                                self.lineEndPoint = currentPoint
                                self.localLine.startPoint = self.lineStartPoint
                                self.localLine.endPoint = currentPoint
                                self.localLine.shader = Shader(
                                    stroke: self.pen.stroke
                                )
                            } else {
                                self.lineEndPoint = currentPoint
                                self.localLine.startPoint = self.lineStartPoint
                                self.localLine.endPoint = currentPoint
                                self.localLine.shader = Shader(
                                    stroke: self.pen.stroke
                                )
                            }
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

extension LinePenOverlayView {
    
    private func applyEnd() {
        let command = Command.addLine(uuid: UUID(), drawable: self.localLine)
        applyCallback?(command)
        self.newLocalLine()
    }
    
    private func newLocalLine() {
        hasSetFirstPoint = false
        localLine = Line(
            shader: Shader(
                stroke: self.pen.stroke
            )
        )
    }
}

struct LinePenOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        LinePenOverlayView(pen: LinePen.mock, applyCallback: nil)
    }
}
