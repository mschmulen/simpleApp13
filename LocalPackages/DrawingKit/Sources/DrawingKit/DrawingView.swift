//
//  DrawingView.swift
//  
//
//  Created by Matthew Schmulen on 8/4/20.
//

import SwiftUI

@available(iOS 13.0, *)
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

@available(iOS 13.0, *)
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
        
        print( "XXX self.frameSize \(self.frameSize)")
        print( "XXX self.frameOrigin \(self.frameOrigin)")
        
        print( "XXX makeDrawPadView.geometry.size \(geometry.size)")
        print( "XXX makeDrawPadView.frame.global \(geometry.frame(in: .global).origin)")
        print( "XXX makeDrawPadView.frame.local \(geometry.frame(in: .local).origin)")
        
        DispatchQueue.main.async {
            self.frameSize = geometry.size
            self.frameOrigin = geometry.frame(in: .global).origin
        }
        
        return DrawingPad(
            drawingState: self.$drawingState,
            currentColor: self.$currentColor,
            currentLineWidth: self.$currentLineWidth
        )
    }
    
    public var body: some View {
        VStack(alignment: .center) {
            if isReadOnly == false {
                HStack  {
                    Spacer()
                    Button(action: {
                        self.save()
                    }) {
                        Text("save")
                    }.padding()
                }
            }
            
            drawPad
            
            if isReadOnly == false {
                DrawingControls(
                    drawingState: $drawingState,
                    currentColor: $currentColor,
                    currentLineWidth: $currentLineWidth,
                    saveCallback: saveCallback
                )
            }
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
        print( "XXX save ")
        print( "XXX DrawingView.frameOrigin: \(self.frameOrigin)")
        print( "XXX DrawingView.frameSize: \(self.frameSize)")
        
        let frame = CGRect(x: self.frameOrigin.x, y: self.frameOrigin.y, width: frameSize.width, height: frameSize.height)
        //screenShotImage = self.takeScreenshot(frame: frame, afterScreenUpdates: true)
        screenShotImage = drawPad.takeScreenshot(frame: frame, afterScreenUpdates: true)
        
        if let image = screenShotImage {
            self.saveCallback?(self.drawingState, image)
        } else {
            self.saveCallback?(self.drawingState, nil)
        }
    }
}

@available(iOS 13.0, *)
struct DrawingView_Previews: PreviewProvider {
    static var previews: some View {
        DrawingView(
            drawingState: .constant(DrawingState.mock),
            isReadOnly: false,
            saveCallback: nil
        )
    }
}
