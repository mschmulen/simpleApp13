//
//  ScribbleToolView.swift
//  DrawKit
//
//  Created by Matthew Schmulen on 7/29/20
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct ScribbleToolView: View {
    
    @Binding var pen: ScribblePen
    
    @State var localPenLineWidth: CGFloat = 1.0
    
    let applyCallback: (()->Void)?
    
    private let colors = ColorPaletteProvider.supportedColors()
    
    var body: some View {
        VStack{
            Text("Scribble Pen width \(localPenLineWidth)")
            
            Slider(value: $localPenLineWidth, in: 1.0...15.0) { (success) in
              self.pen = ScribblePen(
                    stroke:
                    Stroke(
                        uiColor: self.pen.stroke.uiColor,
                        lineWidth: self.localPenLineWidth
                    )
                )
            }
            
            Text("Scribble Pen Color")
            List(colors) { colorInfo in
                ColorEntry(colorInfo: colorInfo).onTapGesture {
                    self.pen = ScribblePen(
                        stroke:Stroke(
                            uiColor: colorInfo.uiColor,
                            lineWidth: self.localPenLineWidth
                    ))
                }
            }
        }//end VStack
            .onAppear {
                self.localPenLineWidth = self.pen.stroke.lineWidth
        }
    }//end body
    
}//end struct

struct _ScribbleToolView_Previews: PreviewProvider {
    static var previews: some View {
        ScribbleToolView(
            pen: .constant(ScribblePen.mock),
            applyCallback: nil
        )
    }
}
