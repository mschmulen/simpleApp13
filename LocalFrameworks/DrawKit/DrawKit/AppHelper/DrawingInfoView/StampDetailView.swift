//
//  StampDetailView.swift
//  DrawKit
//
//  Created by Matthew Schmulen on 7/29/20
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct StampDetailView: View {
    
    var model: Stamp
    
    // MAS TODO use the StampView?
    var stampView: AnyView {
        switch model.shape {
        case .customShape(let shape, _):
            switch shape {
            case .heart:
                let view = HeartShape()
                    .fill(model.shader.stroke.color)
                    .frame(width: 40, height: 40)
                    .padding(.all)
                    .background(Color(.sRGB, white: 0.7, opacity: 0.5))
                return AnyView(view)
            case .star:
                let view = StarShape(corners: 5, smoothness: 0.45)
                    .fill(model.shader.stroke.color)
                    .frame(width: 40, height: 40)
                    .padding(.all)
                    .background(Color(.sRGB, white: 0.7, opacity: 0.5))
                return AnyView(view)
            case .arrow:
                let view = ArrowShape()
                    .fill(model.shader.stroke.color)
                    .frame(width: 40, height: 40)
                    .padding(.all)
                    .background(Color(.sRGB, white: 0.7, opacity: 0.5))
                return AnyView(view)
            }
        case .circle:
            let view = Circle()
                .fill(model.shader.stroke.color)
                .frame(width: 40, height: 40)
                .padding(.all)
                .background(Color(.sRGB, white: 0.7, opacity: 0.5))
            return AnyView(view)
        case .rectangle:
            let view = Rectangle()
                .fill(model.shader.stroke.color)
                .frame(width: 40, height: 40)
                .padding(.all)
                .background(Color(.sRGB, white: 0.7, opacity: 0.5))
            return AnyView(view)
        }
    }
    var body: some View {
        Form {
            Text("STAMP DETAIL")
            Text("\(model.id)")
                .font(.caption)
            
            Section(header: Text("shape")) {
                Text("shape: \(model.shape.info)")
                stampView
            }
            
            Section(header: Text("shader")) {
                Text("rotation: \(model.shader.rotation)")
                Text("offset: (\(model.shader.offset.x),(\(model.shader.offset.y))")
                Text("scale: (\(model.shader.scale.width),(\(model.shader.scale.height))")
                Text("offset: (\(model.shader.offset.x),(\(model.shader.offset.y))")
            }
            
            Section(header: Text("stroke")) {
                Text("stroke: \(model.shader.stroke.description)")
                Text("stroke.lineWidth: \(model.shader.stroke.lineWidth)")
                Text("stroke.color: \(model.shader.stroke.uiColor)")
            }
            
            //            Section {
            //                Text("points \(model.points.count)")
            //                List(pointList) { point in
            //                    VStack{
            //                        Text("(\(point.point.x), \(point.point.y))")
            //                            .font(.caption)
            //                    }
            //                }
            //            }//end section
        }
    }
    
    var stampName:String {
        switch model.shape {
        case .customShape(_, let name): return name
        case .rectangle: return "Rectangle"
        case .circle: return "Circle"
        }
    }
    
}
