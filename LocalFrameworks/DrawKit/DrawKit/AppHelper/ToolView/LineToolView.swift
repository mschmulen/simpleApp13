//
//  LineToolView.swift
//  DrawKit
//
//  Created by Matthew Schmulen on 7/29/20
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct LineToolView: View {
    
    @Binding var pen: LinePen
    
    @State var localPenLineWidth: CGFloat = 1.0
    
    @State var forceOrthogonal:  Bool = false
    
    let applyCallback: (()->Void)?
    
    private let colors = ColorPaletteProvider.supportedColors()
    
    var body: some View {
        VStack{
            
            Toggle("Force Orthogonal", isOn: $forceOrthogonal)
            
            Text("Line Pen width \(localPenLineWidth)")
            
            Slider(value: $localPenLineWidth, in: 1.0...15.0) { (success) in
              self.pen = LinePen(
                    stroke:
                    Stroke(
                        uiColor: self.pen.stroke.uiColor,
                        lineWidth: self.localPenLineWidth
                ),
                    forceOrthogonal: self.forceOrthogonal
                )
            }
            
            Text("Line Pen Color")
            List(colors) { colorInfo in
                ColorEntry(colorInfo: colorInfo).onTapGesture {
                    self.pen = LinePen(
                        stroke:Stroke(
                            uiColor: colorInfo.uiColor,
                            lineWidth: self.localPenLineWidth
                    ), forceOrthogonal: self.forceOrthogonal)
                }
            }
        }//end VStack
            .onAppear {
                self.localPenLineWidth = self.pen.stroke.lineWidth
        }
    }//end body
    
}//end struct

struct LineToolView_Previews: PreviewProvider {
    static var previews: some View {
        LineToolView(
            pen: .constant(LinePen.mock),
            applyCallback: nil
        )
    }
}

