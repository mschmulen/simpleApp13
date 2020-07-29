//
//  ToolsView.swift
//  DrawKit
//
//  Created by Matthew Schmulen on 7/29/20
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct ToolsView: View {
    
    @EnvironmentObject var drawPadService: DrawPadService
    
    @Binding var isShown: Bool
    
    enum ToolViewTab: CaseIterable, Hashable, Identifiable {
        
        case scribble
        case stamp
        case background
        case line
        
        var name: String {
            return "\(self)".map {
                $0.isUppercase ? " \($0)" : "\($0)" }.joined().capitalized
        }
        
        var id: ToolViewTab {self}
    }
    
    @State private var selectedToolView = ToolViewTab.scribble
    
    @State private var localActiveTool:Tool = Tool.scribble(ScribblePen.mock)
    
    @State private var localBoardColor: UIColor = .green
    
    // local pens MAS TODO maybe we can get rid of this
    @State private var localStampPen: StampPen = StampPen.mock
    @State private var localScribblePen: ScribblePen = ScribblePen.mock
    @State private var localLinePen: LinePen = LinePen.mock

    var scribbleToolView: some View {
        ZStack {
            Color(localScribblePen.stroke.uiColor)
                .opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .allowsHitTesting(false)
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 300, height: 300)
                .clipShape(Circle())
                .allowsHitTesting(false)
                .blur(radius: 12)
            
            ScribbleToolView(
                pen: $localScribblePen,
                applyCallback: nil
            )
        }
    }//end scribbleToolView
    
    var lineToolView: some View {
        ZStack {
            Color(localLinePen.stroke.uiColor)
                .opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .allowsHitTesting(false)
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 300, height: 300)
                .clipShape(Circle())
                .allowsHitTesting(false)
                .blur(radius: 12)
            
            LineToolView(
                pen: $localLinePen,
                applyCallback: nil
            )
        }
    }//end lineToolView
    
    var stampToolView: some View {
        ZStack {
            Color(localStampPen.stroke.uiColor)
                .opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .allowsHitTesting(false)
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 300, height: 300)
                .clipShape(Circle())
                .allowsHitTesting(false)
                .blur(radius: 12)
            StampToolView(
                localStampPen: $localStampPen,
                applyCallback: nil
            )
        }
    }//end stampToolView
    
    var backgroundToolView: some View {
        ZStack {
            Color(localBoardColor)
                .opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .allowsHitTesting(false)
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 300, height: 300)
                .clipShape(Circle())
                .allowsHitTesting(false)
                .blur(radius: 12)
            BackgroundToolView(
                localBoardColor: $localBoardColor,
                applyCallback: nil
            )
        }
    }//end backgroundToolView
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Button(action: {
                    self.updateActiveTool()
                }) {
                    CloseButtonView()
                        .padding()
                }
                Spacer()
                Text("Tools")
                    .padding()
                Spacer()
            }
            
            Picker(selection: $selectedToolView, label: Text("Tools")) {
                ForEach(ToolViewTab.allCases) { t in
                    Text(t.name).tag(t)
                }
            }.pickerStyle(SegmentedPickerStyle())
            
            ZStack(alignment: .top) {
                if selectedToolView == .scribble {
                    scribbleToolView
                }
                if selectedToolView == .line {
                    lineToolView
                }
                if selectedToolView == .background {
                    backgroundToolView
                }
                if selectedToolView == .stamp {
                    stampToolView
                }
            }
        }//end VStack
            .onAppear {
                
                self.localActiveTool = self.drawPadService.activeTool
                
                switch self.localActiveTool {
                case .scribble( let pen ):
                    self.selectedToolView = ToolViewTab.scribble
                    self.localScribblePen = pen
                case .line( let pen):
                    self.selectedToolView = ToolViewTab.line
                    self.localLinePen = pen
                case .stamp( let pen ):
                    self.selectedToolView = ToolViewTab.stamp
                    self.localStampPen = pen
                case .setLayerBackground(let pen):
                    // fatalError("MAS TODO")
                    print( "TODO setLayerBackground pen \(pen)")
                case .none:
                    self.selectedToolView = ToolViewTab.scribble
                }
        }
        .onDisappear {
            //self.updatePen()
        }
    }
    
    func updateActiveTool() {
        switch selectedToolView {
        case .scribble:
            let newPen = localScribblePen
            let tool = Tool.scribble(newPen)
            let command = Command.setTool(uuid: UUID(), new: tool, old: self.drawPadService.activeTool)
            _ = self.drawPadService.apply(command: command)
        case .stamp:
            let newPen = localStampPen
            let tool = Tool.stamp(newPen)
            let command = Command.setTool(uuid: UUID(), new: tool, old: self.drawPadService.activeTool)
            _ = self.drawPadService.apply(command: command)
        case .line:
            let newPen = localLinePen
            let tool = Tool.line(newPen)
            let command = Command.setTool(uuid: UUID(), new: tool, old: self.drawPadService.activeTool)
            _ = self.drawPadService.apply(command: command)
        case .background:
            print( "todo background tool")
            _ = self.drawPadService.apply(command:
                .changeBoardBackground(
                    uuid: UUID(),
                    new: self.localBoardColor,
                    old: drawPadService.canvasColor
                )
            )
        }
        self.isShown = false
    }
}

struct ToolsView_Previews: PreviewProvider {
    
    @State static var isShown = true
    
    static var previews: some View {
        ToolsView(
            isShown: $isShown
        )
            .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
            .previewDisplayName("iPhone SE")
    }
    
    //    .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
    //    .previewLayout(.sizeThatFits)
    //    .padding(10)
    
    //    .previewDevice(PreviewDevice(rawValue: deviceName))
    //    .previewDisplayName(deviceName)
}

//#if DEBUG
//struct ContentView_Previews: PreviewProvider {
//   static var previews: some View {
//      Group {
//         ContentView()
//            .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
//            .previewDisplayName("iPhone SE")
//
//         ContentView()
//            .previewDevice(PreviewDevice(rawValue: "iPhone XS Max"))
//            .previewDisplayName("iPhone XS Max")
//      }
//   }
//}
//#endif


