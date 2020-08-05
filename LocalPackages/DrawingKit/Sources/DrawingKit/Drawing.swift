//
//  File.swift
//  
//
//  Created by Matthew Schmulen on 8/4/20.
//

import Foundation
import CoreGraphics
import SwiftUI

struct Drawing {
    var points: [CGPoint] = [CGPoint]()
}

struct DrawingControls: View {
    @Binding var color: Color
    @Binding var drawings: [Drawing]
    @Binding var lineWidth: CGFloat
    
    @State private var colorPickerShown = false

    private let spacing: CGFloat = 40
    
    var body: some View {
        NavigationView {
            VStack {
                HStack(spacing: spacing) {
                    Button("Pick color") {
                        self.colorPickerShown = true
                    }
                    Button("Undo") {
                        if self.drawings.count > 0 {
                            self.drawings.removeLast()
                        }
                    }
                    Button("Clear") {
                        self.drawings = [Drawing]()
                    }
                }
                HStack {
                    Text("Pencil width")
                        .padding()
                    
                    Slider(value: $lineWidth, in: 1.0...10.0)
                        .padding()
                }
            }

        }
        .frame(height: 200)
        .sheet(isPresented: $colorPickerShown, onDismiss: {
            self.colorPickerShown = false
        }, content: { () -> ColorPicker in
            ColorPicker(color: self.$color, colorPickerShown: self.$colorPickerShown)
        })
    }
}

struct DrawingPad: View {
    @Binding var currentDrawing: Drawing
    @Binding var drawings: [Drawing]
    @Binding var color: Color
    @Binding var lineWidth: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                for drawing in self.drawings {
                    self.add(drawing: drawing, toPath: &path)
                }
                self.add(drawing: self.currentDrawing, toPath: &path)
            }
            .stroke(self.color, lineWidth: self.lineWidth)
                .background(Color(white: 0.95))
                .gesture(
                    DragGesture(minimumDistance: 0.1)
                        .onChanged({ (value) in
                            let currentPoint = value.location
                            if currentPoint.y >= 0
                                && currentPoint.y < geometry.size.height {
                                self.currentDrawing.points.append(currentPoint)
                            }
                        })
                        .onEnded({ (value) in
                            self.drawings.append(self.currentDrawing)
                            self.currentDrawing = Drawing()
                        })
            )
        }
        .frame(maxHeight: .infinity)
    }
    
    private func add(drawing: Drawing, toPath path: inout Path) {
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

struct ColorInfo: Identifiable {
    let id: Int
    let displayName: String
    let color: Color
}

