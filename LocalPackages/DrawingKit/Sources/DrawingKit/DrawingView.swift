//
//  DrawingView.swift
//  
//
//  Created by Matthew Schmulen on 8/4/20.
//

import SwiftUI

public struct DrawingState: Codable {
    public var layers: [ScribbleLayer]
    public var scribbles: [Scribble]
    public var currentScribble: Scribble

    public static var mock:DrawingState {
        DrawingState(
            layers: [ScribbleLayer](),
            scribbles: [Scribble](),
            currentScribble: Scribble()
        )
    }
}

//public class DrawingState: ObservableObject, Codable {
//
//    public var layers: [ScribbleLayer]
//    public var scribbles: [Scribble]
//    public var currentScribble: Scribble
//
//    public static var mock:DrawingState {
//        DrawingState()
//    }
//
//    public init() {
//        self.layers = [ScribbleLayer]()
//        self.scribbles =  [Scribble]()
//        self.currentScribble = Scribble()
//    }
//}


public struct DrawingView:View {
    
    @Binding var drawingState: DrawingState// = DrawingState.mock
    
    @State private var currentColor: Color = Color.red
    @State private var currentLineWidth: CGFloat = 3.0
    
    var saveCallback: ((DrawingState)->())?
    
    public var body: some View {
        VStack(alignment: .center) {
            Button(action: {
                self.save()
            }) {
                Text("save")
            }
            DrawingPad(
                drawingState: $drawingState,
                currentColor: $currentColor,
                currentLineWidth: $currentLineWidth
            )
            DrawingControls(
                drawingState: $drawingState,
                currentColor: $currentColor,
                currentLineWidth: $currentLineWidth,
                saveCallback: saveCallback
            )
        }
    }
    
    public init(
        drawingState: Binding<DrawingState>,
        saveCallback: ((DrawingState)->())?
    ){
        self._drawingState = drawingState
        self.saveCallback = saveCallback
    }
    
    func save() {
        saveCallback?(drawingState)
    }
}

struct DrawingView_Previews: PreviewProvider {
    static var previews: some View {
        DrawingView(
            drawingState: .constant(DrawingState.mock),
            saveCallback: nil
        )
    }
}
