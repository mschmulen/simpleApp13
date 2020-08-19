//
//  Drawing.swift
//  
//
//  Created by Matthew Schmulen on 8/4/20.
//

import Foundation
import CoreGraphics
import SwiftUI

struct DrawingControls: View {
    
    @Binding var drawingState: DrawingState
    
    @Binding var currentColor: Color
    @Binding var currentLineWidth: CGFloat
    
    let saveCallback: ((DrawingState, UIImage?)->())?
    
    @State private var colorPickerShown = false
    
    private let spacing: CGFloat = 40
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button(action: {
                        self.colorPickerShown.toggle()
                    }) {
                        Image(systemName: "paintbrush.fill")
                            .foregroundColor(self.currentColor)
                            .padding()
                    }
                    
                    Slider(value: $currentLineWidth, in: 1.0...10.0) { (changed) in
                        if changed {
                            self.addLayer()
                        }
                    }.padding()
                }
                
                HStack(spacing: spacing) {
                    Button(action: {
                        if self.drawingState.scribbles.count > 0 {
                            self.drawingState.scribbles.removeLast()
                        } else {
                            // start to undo the layers
                            if self.drawingState.layers.count > 0 {
                                // TODO: fix the layer pop situation and allow removall of scribbles
                                //self.layers.first?.removeLastScribble()
                                self.drawingState.layers.removeLast()
                            }
                        }
                    }) {
                        Text("Undo")
                    }
                    
                    //                    Button(action: {
                    //                        self.scribbles = [Scribble]()
                    //                    }) {
                    //                        Text("Clear")
                    //                    }
                }
                
            }
        }
        //.frame(height: 200)
        .sheet(isPresented: $colorPickerShown) {
            ColorPicker(
                color: self.$currentColor,
                colorPickerShown: self.$colorPickerShown
            ).onAppear {
                self.addLayer()
            }
        }
    }
    
    func addLayer() {
        
        if self.drawingState.scribbles.count > 0 {
            self.drawingState.layers.append(
                ScribbleLayer(
                    scribbles: self.drawingState.scribbles,
                    color: DrawingColor.swiftColor(self.currentColor),
                    lineWidth: self.currentLineWidth
                )
            )
            self.drawingState.scribbles = [Scribble]()
        }
    }
}



struct ColorInfo: Identifiable {
    let id: Int
    let displayName: String
    let color: Color
}


enum DrawingColor {
    
    case swiftColor( Color )
    //case uiColor( UIColor)
    
    var color: Color {
        switch self {
        case .swiftColor(let color):
            return color
//        case .uiColor(let color):
//            return Color(color)
        }
    }
}

extension DrawingColor : Codable {
    
    enum Key: CodingKey {
        case rawValue
        
        case redComponent
        case greenComponent
        case blueComponent
        case alphaComponent
    }
    
    enum CodingError: Error {
        case unknownValue
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let rawValue = try container.decode(Int.self, forKey: .rawValue)
        
        switch rawValue {
        case 0:
            let redComponent = try container.decode(CGFloat.self, forKey: .redComponent)
            let greenComponent = try container.decode(CGFloat.self, forKey: .greenComponent)
            let blueComponent = try container.decode(CGFloat.self, forKey: .blueComponent)
            let alphaComponent = try container.decode(CGFloat.self, forKey: .alphaComponent)
//            let uiColor = UIColor(red: redComponent, green: greenComponent, blue: blueComponent, alpha: alphaComponent)
//            self = .swiftColor(Color(uiColor))
            self = .swiftColor(Color.blue) // TODO: fix this hack
            
//        case 1:
            //            let redComponent = try container.decode(Double.self, forKey: .redComponent)
            //            let greenComponent = try container.decode(Double.self, forKey: .greenComponent)
            //            let blueComponent = try container.decode(Double.self, forKey: .blueComponent)
            //            let alphaComponent = try container.decode(Double.self, forKey: .alphaComponent)
//            self = .uiColor(UIColor(red: redComponent, green: greenComponent, blue: blueComponent, alpha: alphaComponent))
        default:
            throw CodingError.unknownValue
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        switch self {
        case .swiftColor(let color):
            try container.encode(0, forKey: .rawValue)
            var redComponent: CGFloat = 0
            var greenComponent: CGFloat = 0
            var blueComponent: CGFloat = 0
            var alphaComponent: CGFloat = 0
            color.uiColor().getRed(&redComponent, green: &greenComponent, blue: &blueComponent, alpha: &alphaComponent)
            try container.encode(redComponent, forKey: .redComponent)
            try container.encode(greenComponent, forKey: .greenComponent)
            try container.encode(blueComponent, forKey: .blueComponent)
            try container.encode(alphaComponent, forKey: .alphaComponent)
            
            //        case .uiColor( let color):
            //            try container.encode(1, forKey: .rawValue)
        }
    }
}

extension Color {

    func uiColor() -> UIColor {

        let components = self.components()
        return UIColor(red: components.r, green: components.g, blue: components.b, alpha: components.a)
    }

    private func components() -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {

        let scanner = Scanner(string: self.description.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
        var hexNumber: UInt64 = 0
        var r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0

        let result = scanner.scanHexInt64(&hexNumber)
        if result {
            r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
            g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
            b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
            a = CGFloat(hexNumber & 0x000000ff) / 255
        }
        return (r, g, b, a)
    }
}
