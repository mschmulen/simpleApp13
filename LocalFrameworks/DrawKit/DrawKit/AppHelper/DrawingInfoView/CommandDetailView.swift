//
//  CommandDetailView.swift
//  DrawKit
//
//  Created by Matthew Schmulen on 7/29/20
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct CommandDetailView: View {
    
    var command:Command
    
    var body: some View {
        Form {
            Text("COMMAND DETAIL")
            Text("\(command.id)")
                .font(.caption)
            Text("\(command.info)")
            
            Section(header: Text("attributes")){
                attributes
            }
        }
    }
    
    var attributes: AnyView {
        switch command {
        case .addScribble(_, let scribble):
            let view = VStack {
                Text("scribble: \(scribble.id)")
                Text("scribble.points: \(scribble.points.count)")
                Text("scribble.shader.stroke: \(scribble.shader.stroke.info)")
            }
            return AnyView(view)
        case .addStamp(_, let stamp):
            let view = VStack {
                Text("stamp.id: \(stamp.id)")
                Text("stamp.offset: (\(stamp.shader.offset.x)),(\(stamp.shader.offset.y))")
                Text("stamp.size: (\(stamp.shader.scale.width)),(\(stamp.shader.scale.height))")
                Text("stamp.shader.stroke: \(stamp.shader.stroke.info)")
            }
            return AnyView(view)
        case .setTool(_, let new, let old):
            let view = VStack {
                Text("new: \(new.info)")
                Text("old: \(old.info)")
            }
            return AnyView(view)
        case .newLayer(_, let name):
            let view = VStack {
                Text("name:\(name)")
            }
            return AnyView(view)
        default:
            let view = VStack {
                Text("TODO attributes")
            }
            return AnyView(view)
        }        
    }
}
