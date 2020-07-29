//
//  DrawingPadView.swift
//  DrawKit
//
//  Created by Matthew Schmulen on 7/29/20
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct DrawingPadView<T:DrawableTool,U:Drawable>: View {
    
    @EnvironmentObject var drawPadService: DrawPadService
    
    @State private var localScribble: Scribble = Scribble.mock
    
    var layersView: some View {
        GeometryReader { geometry in
            ForEach(self.drawPadService.layers.items.reversed(), id:\.id ) { layer in
                LayerPadView(layer: layer)
            }
        }
        .frame(maxHeight: .infinity)
    }
    
    // MAS TODO Rename this to localOverlayPenView
    var localScribbleView: AnyView {
        
        switch self.drawPadService.activeTool {
        case .none:
            return AnyView(EmptyView())
        case .scribble(let pen):
            return AnyView(
                ScribblePenOverlayView(
                    pen: pen,
                    applyCallback: { command in
                        _ = self.drawPadService.apply( command: command )
                })
            )
        case .line(let pen):
            return AnyView(
                LinePenOverlayView(
                    pen: pen,
                    applyCallback: { command in
                        _ = self.drawPadService.apply( command: command )
                })
            )
        case .stamp(let pen):
            return AnyView(
                StampPenOverlayView(
                    pen: pen,
                    applyCallback: { command in
                        if let command = command {
                            _ = self.drawPadService.apply( command: command )
                        }
                        // reset the active tool to none
                        let tool = Tool.none
                        let command = Command.setTool(uuid: UUID(), new: tool, old: self.drawPadService.activeTool)
                        _ = self.drawPadService.apply(command: command)
                })
            )
        default:
            return AnyView(EmptyView())
        }
    }
    
    var body: some View {
        ZStack {
            layersView
                .background(Color(self.drawPadService.canvasColor))
            localScribbleView
        }
    }
}
