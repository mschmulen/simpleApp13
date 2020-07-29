//
//  StampPenOverlayView.swift
//  DrawKit
//
//  Created by Matthew Schmulen on 7/29/20
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct StampPenOverlayView: View {
    
    let transparentColor: Color = Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.0001)
    
    var pen: StampPen
    
    var applyCallback: ((_ command: Command?)->Void)?
    
    @State private var localStamp: Stamp = Stamp.mock
    
    @State private var size: CGSize = CGSize(width: 100, height: 100)
    @State private var startPoint: CGPoint?
    @State private var currentPoint: CGPoint = CGPoint(x: 200, y: 400)
    @State private var endPoint: CGPoint = CGPoint(x: 0, y: 0)
    
    @State private var scaleMultiplier: CGFloat = 1.0
    @State private var rotationTheta: Double = 0.0
    
    private var frameWidth: CGFloat { return size.width * scaleMultiplier }
    private var frameHeight: CGFloat { return size.height * scaleMultiplier }
    private var rotationAngle: Angle { return Angle(degrees: rotationTheta) }
    private var position: CGPoint { return CGPoint(x: currentPoint.x - size.width/2, y: currentPoint.y - size.height/2) }
    
    var gesture: some Gesture {
        return DragGesture(minimumDistance: 0.1)
            .onChanged({ (value) in
                let currentPoint = value.location
                if currentPoint.y >= 0 {
                    self.localStamp.shader = Shader (
                        stroke: self.pen.stroke,
                        scale: self.size,
                        offset: self.currentPoint,
                        rotation:CGFloat(self.rotationTheta)
                    )
                }
                self.startPoint = value.startLocation
                self.currentPoint = value.location
            })
            .onEnded({ (value) in
                // fish the scribble by applying it to the current layer
                self.endPoint = value.location
                self.applyEnd()
            })
    }
    
//    var stamp: some View {
//        StampView(stamp: $localStamp)
//    }
    
    var stamp: AnyView {
        switch pen.shape {
        case .customShape(let shape, _ ):
            switch shape {
            case .heart:
                let view = HeartShape()
                    .fill( pen.stroke.color )
                    .frame( width: frameWidth, height: frameHeight )
                    .rotationEffect( rotationAngle, anchor: .center )
                    .position( position )
                    // .offset( CGPoint(x: currentPoint.x - size.width/2, y: currentPoint.y - size.height/2))
                    .gesture( gesture )
                return AnyView(view)
            case .star:
                let view = StarShape(corners: 5, smoothness: 0.45)
                    .fill(pen.stroke.color)
                    .frame( width: frameWidth, height: frameHeight )
                    .rotationEffect(rotationAngle, anchor: .center)
                    .position(position)
                    .gesture( gesture )
                return AnyView(view)
            case .arrow:
                let view = ArrowShape()
                    .fill(pen.stroke.color)
                    .frame( width: frameWidth, height: frameHeight )
                    .rotationEffect(rotationAngle, anchor: .center)
                    .position(position)
                    .gesture( gesture )
                return AnyView(view)
            }
            
        case .circle:
            let view = Circle()
                .size( CGSize( width: frameWidth, height: frameHeight))
                .offset( position)
                .fill(pen.stroke.color)
                .gesture( gesture )
            return AnyView(view)
        case .rectangle:
            let view = Rectangle()
                .size( CGSize( width: frameWidth, height: frameHeight))
                .offset( position )
                .fill(pen.stroke.color)
                .gesture( gesture )
            return AnyView(view)
        }
    }
    
    var controlView: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Slider(value: $scaleMultiplier, in: 0.2...4.0)
//                { success in
//                    self.localStamp.shader = StampShader (
//                        stroke: self.pen.stroke,
//                        scale: self.size,
//                        offset: self.currentPoint,
//                        rotation: CGFloat(self.rotationTheta)
//                    )
//                }
                .accentColor(.red)
                .frame(width: 200, height: 50, alignment: .topLeading)
                Slider(value: $rotationTheta, in: 0...360)
//                { success in
//                    self.localStamp.shader = StampShader (
//                        stroke: self.pen.stroke,
//                        scale: self.size,
//                        offset: self.currentPoint,
//                        rotation: CGFloat(self.rotationTheta)
//                    )
//                }
                .accentColor(.blue)
                .frame(width: 200, height: 50, alignment: .topLeading)
                HStack{
                    Button(action: {
                        self.applyDone()
                    }) {
                        Text("DONE")
                    }
                    Button(action: {
                        self.applyCancel()
                    }) {
                        Text("CANCEL")
                    }
                }// end HStack
            }//end VStack
        }
        .padding()
        .background(Color.black)
        .border(Color.yellow)
        .position(x: 120, y: 100)
    }//end controls
    
    var body: some View {
        Group{
            controlView
            stamp
        }//end group
            .onAppear {
                self.localStamp = Stamp(
                    shader: Shader(
                        stroke: self.pen.stroke,
                        scale: self.size,
                        offset: self.currentPoint,
                        rotation: CGFloat(self.rotationTheta)
                    ),
                    shape: self.pen.shape
                )
        }
    }//end body
    
}//end view

extension StampPenOverlayView {
    
    private func applyEnd() {
        print("StampToolView.applyEnd()")
    }
    
    private func applyCancel() {
        applyCallback?(nil)
    }
    
    private func applyDone() {
        let finalSize = CGSize(
            width: size.width * scaleMultiplier,
            height: size.height * scaleMultiplier
        )
        let finalOffset = CGPoint(x: currentPoint.x - size.width/2, y: currentPoint.y - size.height/2)
        let finalStamp = Stamp(
            shader: Shader(
                stroke: pen.stroke,
                scale: finalSize,
                offset: finalOffset,
                rotation: CGFloat(self.rotationTheta)
            ),
            shape: localStamp.shape
        )
        let command = Command.addStamp(uuid: UUID(), stamp: finalStamp)
        applyCallback?(command)
    }
}

struct StampPenOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        StampPenOverlayView(
            pen: StampPen.mock,
            applyCallback: nil
        )
    }
}
