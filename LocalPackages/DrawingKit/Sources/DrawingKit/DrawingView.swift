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
    
    @Binding var drawingState: DrawingState
    
    @State private var currentColor: Color = Color.red
    @State private var currentLineWidth: CGFloat = 3.0
    
    var saveCallback: ((DrawingState, UIImage?)->())?
    
    @State var frameOrigin: CGPoint = .zero
    @State var frameSize: CGSize = .zero
    @State private var screenShotImage: UIImage?
    
    // TODO: isReadOnly make this function
    var isReadOnly: Bool
    
    public var drawPad: some View {
        GeometryReader { geometry in
            self.makeDrawPadView(geometry)
        }
    }
    
    func makeDrawPadView(_ geometry: GeometryProxy) -> some View {
        print(geometry.size.width, geometry.size.height)
        
        DispatchQueue.main.async {
            self.frameSize = geometry.size
            self.frameOrigin = geometry.frame(in: .global).origin
        }
        
        return DrawingPad(
            drawingState: self.$drawingState,
            currentColor: self.$currentColor,
            currentLineWidth: self.$currentLineWidth
        )
        // .frame(width: geometry.size.width)
    }
    
    public var body: some View {
        VStack(alignment: .center) {
            if isReadOnly == false {
                Button(action: {
                    self.save()
                }) {
                    Text("save")
                }
            }
            drawPad
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
        isReadOnly: Bool,
        saveCallback: ((DrawingState,UIImage?)->())?
    ){
        self._drawingState = drawingState
        self.isReadOnly = isReadOnly
        self.saveCallback = saveCallback
    }
    
    func save() {
        // TODO: Take a screen shot of this view
        
//        let image = self.takeScreenshot(
//            origin: drawPad.frame(in: .global).origin,
//            size: drawPad.size
//        )
        
//        DispatchQueue.main.async {
            
        print( "frameOrigin: \(self.frameOrigin)")
        print( "frameSize: \(self.frameSize)")
            
        if let image = screenShotImage {
            self.saveCallback?(self.drawingState, image)
        } else {
            self.saveCallback?(self.drawingState, nil)
        }
        
//            if let image = self.drawPad.takeScreenshot(
//                origin: self.frameOrigin,
//                size: self.frameSize
//                ) {
//                self.saveCallback?(self.drawingState, image)
//            } else {
//                self.saveCallback?(self.drawingState, nil)
//            }
//        }
        
    }
}

struct DrawingView_Previews: PreviewProvider {
    static var previews: some View {
        DrawingView(
            drawingState: .constant(DrawingState.mock),
            isReadOnly: false,
            saveCallback: nil
        )
    }
}
