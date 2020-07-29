//
//  DrawBoardView.swift
//  DrawKit
//
//  Created by Matthew Schmulen on 7/29/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct DevDrawBoardViewModel: Codable {
    let clockViewModel: ClockViewModel
}

extension DevDrawBoardViewModel {
    static var defaultConfig: DevDrawBoardViewModel {
        return DevDrawBoardViewModel(
            clockViewModel: ClockViewModel.defaultConfig
        )
    }
}//end DevDrawBoardViewModel

let drawPadFileService:FileService = FileService()

public struct DevDrawBoardView: View {
    
    //@EnvironmentObject var drawPadService: DrawPadService
    @State private var drawPadService = DrawPadService(drawPadFileService)
    @State private var currentLayer: [Scribble] = [Scribble]()
    
    // sheets
    @State private var showFileView: Bool = false
    @State private var showInfoView: Bool = false
    @State private var showToolView: Bool = false
    
    let autoSaveIsEnabled = false
    let lastDrawingFile = "tmp.json"
    
    let viewModel: DevDrawBoardViewModel = DevDrawBoardViewModel.defaultConfig
    
    public init() {
        
        if autoSaveIsEnabled {
            let result = drawPadFileService.readFromFileStorage(shortFileName: lastDrawingFile)
            switch result {
            case .success(_):
                let loadResult = self.drawPadService.loadFromFile(shortFileName: "tmp.json")
                switch loadResult{
                case .success(_):
                    print("success loading tmp.json")
                case .failure(let error):
                    print("failed to load tmp.json \(error)")
                }
            case .failure(let error):
                print("failed \(error)")
            }
        }
    }
    
    var drawingPad: some View {
        DrawingPadView<ScribblePen, Scribble>(
        )
            .environmentObject(drawPadService)
    }

    var undoRedoBarView: some View {
        HStack{
            Button(action: {
                _ = self.drawPadService.undoLastCommand()
            }) {
                AppImage(icon: .undo)
            }

            Button(action: {
                _ = self.drawPadService.redoTheLastUndo()
            }) {
                AppImage(icon: .redo)
            }
        }
        .padding()
        .border(Color.green)
    }//end undoRedoBarView

    var toolBarView: some View {
        HStack{
            Button(action: {
                self.showInfoView.toggle()
            }) {
                AppImage(icon: .info)
            }.sheet(isPresented: $showInfoView) {
                DrawingInfoView(
                    isShown: self.$showInfoView
                )
                    .environmentObject(self.drawPadService)
            }

            // NavigationLink(destination: FileView(fileService: drawPadService.fileService), isActive: $showFileView) {
            //                AppImage(icon: .file)
            //            }.padding()

            Button(action: {
                self.showFileView.toggle()
            }) {
                AppImage(icon: .file)
            }.sheet(isPresented: $showFileView) {
                FileView(
                    fileService: self.drawPadService.fileService,
                    isShown: self.$showFileView
                )
                    .environmentObject(self.drawPadService)
            }

            toolButton
        }.padding()
            .border(Color.black)
        //.background(Color.gray)
    }

    var toolButton: some View {
        Button(action: {
                        self.showToolView.toggle()
                    }) {
                        ZStack{
                            Image(systemName: "circle.fill")
                                .foregroundColor(Color.black)
                                .imageScale(.large)
                                .accessibility(label: Text("Background"))
                            toolImage
                        }

                    }.sheet(isPresented: $showToolView) {
                        ToolsView(
                            isShown: self.$showToolView
                        )
                            .environmentObject(self.drawPadService)
                    }
    }

    var toolImage: AnyView {
        switch drawPadService.activeTool {
        case .none:
            return AnyView (
                Image(systemName: "n.circle.fill")
                    .imageScale(.large)
                    .accessibility(label: Text("none"))
            )
        case .scribble(let pen):
            return AnyView (
                Image(systemName: "pencil.circle.fill")
                    .foregroundColor(pen.stroke.color)
                    .imageScale(.large)
                    .accessibility(label: Text("scribble"))
            )
        case .stamp(let pen):
            return AnyView (
                Image(systemName: "s.circle.fill")
                    .foregroundColor(pen.stroke.color)
                    .imageScale(.large)
                    .accessibility(label: Text("stamp"))

            )
        case .line(let pen):
            return AnyView (
                Image(systemName: "l.circle.fill")
                    .foregroundColor(pen.stroke.color)
                    .imageScale(.large)
                    .accessibility(label: Text("stamp"))

            )
        default:
            return AnyView (
                Image(systemName: "y.circle.fill")
                    .imageScale(.large)
            )
        }
    }

    var clockBarView: some View {
        ClockView(viewModel: viewModel.clockViewModel)
    }

    var headerView: some View {
        HStack{
            clockBarView

            undoRedoBarView

            toolBarView
        }
    }
    
    public var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                headerView
                drawingPad
            }.onAppear {
                switch self.drawPadService.activeTool {
                case .none:
                    let tool = Tool.scribble(ScribblePen.mock)
                    let command = Command.setTool(uuid: UUID(), new: tool, old:self.drawPadService.activeTool)
                    _ = self.drawPadService.apply(command: command)
                default:
                    print( "no need we have an active tool that is not none")
                }
            }
            .navigationBarTitle("TopNav")
            .navigationBarHidden(true)
        }.navigationViewStyle(StackNavigationViewStyle())
            .statusBar(hidden: true)
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("undo"))) { notification in
                _ = self.drawPadService.undoLastCommand()
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("redo"))) { notification in
            _ = self.drawPadService.redoTheLastUndo()
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("tools"))) { notification in
            self.showToolView.toggle()
        }
    }//end bodyNav

}
