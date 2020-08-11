//
//  DrawingView.swift
//  
//
//  Created by Matthew Schmulen on 8/4/20.
//

import SwiftUI

public struct DrawingView:View {
    
    @State private var currentDrawing: Drawing = Drawing()
    @State private var layers: [Layer] = [Layer]()
    @State private var drawings: [Drawing] = [Drawing]()
    @State private var color: Color = Color.black
    @State private var lineWidth: CGFloat = 3.0
    
    public var body: some View {
        VStack(alignment: .center) {
            Text("Draw something")
                .font(.largeTitle)
            DrawingPad(currentDrawing: $currentDrawing,
                       drawings: $drawings,
                       color: $color,
                       lineWidth: $lineWidth)
            DrawingControls(color: $color, drawings: $drawings, lineWidth: $lineWidth)
        }

    }
    
    public init(){
    }
}

struct DrawingView_Previews: PreviewProvider {
    static var previews: some View {
        DrawingView()
    }
}
