//
//  StampToolView.swift
//  DrawKit
//
//  Created by Matthew Schmulen on 7/29/20
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct StampToolView: View {
    
    @Binding var localStampPen: StampPen
    
    @State private var localStampShaderLineWidth: CGFloat = 3.0
    
    let applyCallback: (()->Void)?
    
    private let colors = ColorPaletteProvider.supportedColors()
    
    var body: some View {
        VStack{
            
            ShapeRow(shape: localStampPen.shape, currentPen: localStampPen)
            
            Slider(value: $localStampShaderLineWidth, in: 1.0...15.0) { (success) in
                self.localStampPen = StampPen(
                    stroke: Stroke(
                        uiColor: self.localStampPen.stroke.uiColor,
                        lineWidth: self.localStampShaderLineWidth
                    ),
                    shape: self.localStampPen.shape
                )
            }
            
            List( Stamp.Shape.allCases) { shape in
                ShapeRow(shape: shape, currentPen: self.localStampPen).onTapGesture {
                    self.localStampPen = StampPen(
                        stroke: self.localStampPen.stroke,
                        shape: shape
                    )
                }
            }
            
            List(colors) { colorInfo in
                ColorEntry(colorInfo: colorInfo).onTapGesture {
                    self.localStampPen = StampPen(
                        stroke: Stroke(
                            uiColor: colorInfo.uiColor,
                            lineWidth: self.localStampShaderLineWidth
                        ),
                        shape: self.localStampPen.shape
                    )
                }
            }
        }//end VStack
    }//end body
}//end struct

struct StampToolView_Previews: PreviewProvider {
    static var previews: some View {
        StampToolView(
            localStampPen: .constant(StampPen.mock),
            applyCallback: nil
        )
    }
}
