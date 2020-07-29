//
//  BackgroundToolView.swift
//  DrawKit
//
//  Created by Matthew Schmulen on 7/29/20
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation
import SwiftUI

struct BackgroundToolView: View {

    @Binding var localBoardColor: UIColor
    
    let applyCallback: (()->Void)?
    
    private let colors = ColorPaletteProvider.supportedColors()
    
    var body: some View {
        VStack{
            Text("Background Color")
            List(colors) { colorInfo in
                ColorEntry(colorInfo: colorInfo).onTapGesture {
                    self.localBoardColor = colorInfo.uiColor
                    self.updateActiveTool()
                }
            }
        }//end VStack
    }//end body
    
    func updateActiveTool() {
        print("updateActiveTool")
        applyCallback?()

        //        if (self.color == self.drawPadService.currentTool.color) && (self.lineWidth == self.drawPadService.currentTool.lineWidth) {
//            self.isShown = false
//            return
//        }
//        self.drawPadService.apply(command: .newLayer(uuid: UUID(), name: "pen change"))
//        self.drawPadService.apply(command: .changePen(uuid: UUID(), color: self.localColor, lineWidth: self.localLineWidth))
        //self.isShown = false
    }
}
