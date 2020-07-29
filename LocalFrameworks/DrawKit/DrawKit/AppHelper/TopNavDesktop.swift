//
//  TopNavDesktop.swift
//  DrawKit
//
//  Created by Matthew Schmulen on 7/29/20
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation
import SwiftUI

//struct TopNavDesktopView: View {
//    
//    @State private var currentDrawing: Scribble = Scribble()
//    @State private var currentLayer: [Scribble] = [Scribble]()
//    @State private var penColor: Color = Color.black
//    @State private var boardColor: Color = Color.white
//    @State private var lineWidth: CGFloat = 3.0
//
//    @State private var showFooterToolbar: Bool = false
//
//    let viewModel:TopNavViewModel// = TopNavViewModel.defaultConfig
//
//    var header: some View {
//        HStack{
//            Spacer()
//            ClockView(viewModel: viewModel.clockConfig)
//            Spacer()
//            Button(action: {
//                self.showFooterToolbar.toggle()
//            }) {
//                AppImage(icon: .tools)
//            }
//            Spacer()
//        }
//    }
//
//    var footer: some View {
//        Text("footer")
//        //DrawingControls(layer: $currentLayer)
//    }
//
//    var body: some View {
//        VStack(alignment: .center) {
//            header
//            DrawingPad(
//                drawPadService: drawPadService,
//                currentScribble: $currentDrawing,
//                currentLayer: $currentLayer,
//                boardColor: $boardColor,
//                penColor: $penColor,
//                lineWidth: $lineWidth)
//            if showFooterToolbar == true {
//                footer
//            }
//        }.onAppear {
//            self.penColor = self.viewModel.penColor.color
//            self.boardColor = self.viewModel.boardColor.color
//        }
//    }
//} // end TopNavDesktopView
//
