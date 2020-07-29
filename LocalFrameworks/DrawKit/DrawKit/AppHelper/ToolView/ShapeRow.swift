//
//  StampEntry.swift
//  DrawKit
//
//  Created by Matthew Schmulen on 7/29/20
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct ShapeRow: View {
    
    let shape: Stamp.Shape
    
    let currentPen: StampPen
    
    var body: some View {
        Group{
            HStack {
                shapeView
                Text("\(stampName)")
            }
        }
    }
    
    var shapeView: AnyView {
        switch shape {
        case .customShape(let shape, _):
            switch shape {
            case .heart:
                let view = HeartShape()
                    .fill(currentPen.stroke.color)
                    .frame(width: 40, height: 40)
                    .padding(.all)
                    .background(Color(.sRGB, white: 0.7, opacity: 0.5))
                return AnyView(view)
            case .star:
                let view = StarShape(corners: 5, smoothness: 0.45)
                    .fill(currentPen.stroke.color)
                    .frame(width: 40, height: 40)
                    .padding(.all)
                    .background(Color(.sRGB, white: 0.7, opacity: 0.5))
                return AnyView(view)
            case .arrow:
                let view = ArrowShape()
                    .fill(currentPen.stroke.color)
                    .frame(width: 40, height: 40)
                    .padding(.all)
                    .background(Color(.sRGB, white: 0.7, opacity: 0.5))
                return AnyView(view)
            }
        case .circle:
            let view = Circle()
                .fill(currentPen.stroke.color)
                .frame(width: 40, height: 40)
                .padding(.all)
            .background(Color(.sRGB, white: 0.7, opacity: 0.5))
            return AnyView(view)
        case .rectangle:
            let view = Rectangle()
                .fill(currentPen.stroke.color)
                .frame(width: 40, height: 40)
                .padding(.all)
            .background(Color(.sRGB, white: 0.7, opacity: 0.5))
            return AnyView(view)
        }
    }
    
    var stampName:String {
        switch shape {
        case .customShape(_, let name): return name
        case .rectangle: return "Rectangle"
        case .circle: return "Circle"
        }
    }
}

struct ShapeRow_Previews: PreviewProvider {
    static var previews: some View {
        ShapeRow(
            shape: Stamp.Shape.circle, 
            currentPen: StampPen.mock
        )
            .previewLayout(PreviewLayout.sizeThatFits)
            .padding()
    }
}
