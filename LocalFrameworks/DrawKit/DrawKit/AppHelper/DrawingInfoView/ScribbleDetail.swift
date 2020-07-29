//
//  ScribbleDetail.swift
//  DrawKit
//
//  Created by Matthew Schmulen on 7/29/20
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation
import SwiftUI

struct ScribbleDetailView: View {
    
    var model: Scribble
    
    struct LocalPoint: Identifiable {
        let id: UUID = UUID()
        let point: CGPoint
    }
    
    var pointList: [LocalPoint] {
        return model.points.map { data in
            LocalPoint( point: data)
        }
    }
    
    var body: some View {
        Form {
            Text("Scribble DETAIL")
            Text("\(model.id)")
                .font(.caption)
            
            Section(header: Text("stroke")) {
                Text("stroke: \(model.shader.stroke.description)")
                Text("stroke.lineWidth: \(model.shader.stroke.lineWidth)")
                Text("stroke.color: \(model.shader.stroke.uiColor)")
            }
            
            Section(header: Text("shader")) {
                Text("rotation: \(model.shader.rotation)")
                Text("offset: (\(model.shader.offset.x),(\(model.shader.offset.y))")
                Text("scale: (\(model.shader.scale.width),(\(model.shader.scale.height))")
                Text("offset: (\(model.shader.offset.x),(\(model.shader.offset.y))")
            }
            
            Section {
                Text("points \(model.points.count)")
                List(pointList) { point in
                    VStack{
                        Text("(\(point.point.x), \(point.point.y))")
                            .font(.caption)
                    }
                }
            }//end section
        }//end Form
    }//end body
    
}
