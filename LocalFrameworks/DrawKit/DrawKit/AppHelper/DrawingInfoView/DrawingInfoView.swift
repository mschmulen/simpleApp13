//
//  DrawingInfoView.swift
//  DrawKit
//
//  Created by Matthew Schmulen on 7/29/20
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct DrawingInfoView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var drawPadService: DrawPadService
    
    @Binding var isShown: Bool
    
    private let colors = ColorPaletteProvider.supportedColors()
    
    var topMenuView: some View {
        Group {
            Button(action: {
                self.close()
            }) {
                CloseButtonView()
            }
            .accessibility(label: Text("Close"))
            
            TextField("title", text: $drawPadService.title)
                .accessibility(label: Text("title"))
            
            TextField("description", text: $drawPadService.description)
                .accessibility(label: Text("description"))
            
        }
    }//end topMenuView
    
    var actionView: some View {
        Group {
            Button(action: {
                let command = Command.clearAllLayers(uuid: UUID(), oldLayers: self.drawPadService.layers)
                let result = self.drawPadService.apply( command: command )
                switch result {
                case .failure:
                    self.close()
                case .success:
                    self.close()
                }
            }) {
                HStack {
                    AppImage(icon: .trashAll)
                    Text("clearAllLayers")
                }
            }
            
            Button(action: {
                let command = Command.deleteLastScribbleFromActiveLayer(uuid: UUID(), oldScribble: nil )
                _ = self.drawPadService.apply( command: command)
            }) {
                HStack {
                    AppImage(icon: .deleteLastScribbleFromLayer)
                    Text("delete LastScribble From Layer")
                }
            }
            
            Button(action: {
                let result = self.drawPadService.undoLastCommand()
                print( "result \(result)")
            }) {
                HStack {
                    AppImage(icon: .undo)
                    Text("UNDO (\(self.drawPadService.undoStack.items.count)) last command ")
                }
            }
            
            Button(action: {
                let result = self.drawPadService.redoTheLastUndo()
                print( "result \(result)")
            }) {
                HStack {
                    AppImage(icon: .redo)
                    Text("REDO (\(self.drawPadService.redoStack.items.count)) last undid command ")
                }
            }
            
        }//end HStack
    }//end actionView
    
    var fileView: some View {
        Group {
            
            Button(action: {
                self.isShown.toggle()
                let result = self.drawPadService.saveToFile(shortFileName: "tmp.json")
                switch result {
                case .failure( let error):
                    print( "saveToFile fail \(error)")
                case .success( let data ):
                    print( "saveToFile success \(data)")
                }
            }) {
                Text("SAVE tmp.json")
            }
            .accessibility(label: Text("Save tmp.json"))

            
            Button(action: {
                let result = self.drawPadService.fileService.delete(shortFileName: "tmp.json")
                switch result {
                case .failure( let error):
                    print( "fail \(error)")
                case .success( let data ):
                    print( "success \(data)")
                }
            }) {
                Text("CLEAR tmp.json")
            }
            .accessibility(label: Text("CLEAR tmp.json"))

            
            Button(action: {
                let result = self.drawPadService.loadFromFile(shortFileName: "tmp.json")
                switch result {
                case .failure( let error):
                    print( "fail \(error)")
                case .success( let status ):
                    print( "success \(status)")
                }
            }) {
                Text("LOAD tmp.json")
            }
            .accessibility(label: Text("LOAD tmp.json"))
        }
    }//end fileView
    
    var commandStackView: some View {
        List(self.drawPadService.undoStack.items) { command in
            NavigationLink(destination: CommandDetailView(command:command)) {
                VStack{
                    Text("\(command.info)")
                        .font(.body)
                    .accessibility(label: Text("\(command.info)"))
                }
            }
        }
    }//end commandStackView
    
    var redoStackView: some View {
        List(self.drawPadService.redoStack.items) { command in
            NavigationLink(destination: CommandDetailView(command:command)) {
                VStack{
                    Text("\(command.info)")
                        .font(.body)
                        .accessibility(label: Text("\(command.info)"))
                }
            }
        }
    }//end redoStackView
    
    var layersView: some View {
        List(self.drawPadService.layers.items) { layer in
            NavigationLink(destination: LayerDetailView(model:layer)) {
                VStack{
                    Text("\(layer.info)")
                        .font(.caption)
                        .accessibility(label: Text("\(layer.info)"))
                }
            }
        }
    }//end layersView
    
    var body: some View {
        NavigationView {
            Form {
                topMenuView
                Section(header: Text("misc")) {
                    actionView
                }
                .accessibility(label: Text("misc"))

                
                Section(header: Text("info")) {
                    Text("boardColor: \(self.drawPadService.canvasColor.description)")
                        .padding()
                }
                .accessibility(label: Text("info"))

                Section(header: Text("layers (\(self.drawPadService.layers.items.count))")) {
                    
                    Button(action: {
                        let command = Command.newLayer(uuid: UUID(), name: "new-layer")
                        let result = self.drawPadService.apply(command: command)
                        switch result {
                        case .failure( let error):
                            print( "fail \(error)")
                        case .success( let status ):
                            print( "success \(status)")
                        }
                    }) {
                        Text("NEW LAYER")
                    }
                    
                    layersView
                }
                
                Section(header: Text("commandStack (\(self.drawPadService.undoStack.items.count))")) {
                    commandStackView
                }.accessibility(label: Text("command Stack"))

                
                Section(header: Text("redoStack (\(self.drawPadService.redoStack.items.count))")) {
                    Text("redoStack.count:")
                        .padding()
                    redoStackView
                }.accessibility(label: Text("redo stack"))
                
                Section(header: Text("file")) {
                    fileView
                }.accessibility(label: Text("file"))
            }
            //            .navigationBarTitle("TopNav")
            //            .navigationBarHidden(true)
        }//end NavigationView
            .navigationViewStyle(StackNavigationViewStyle())
        //.statusBar(hidden: true)
    }//end body
    
    func close() {
        //presentationMode.wrappedValue.dismiss()
        isShown = false
    }
}

struct DrawingInfoView_Previews: PreviewProvider {
    
    @State static var isShown = true
    
    static var previews: some View {
        DrawingInfoView(
            isShown: $isShown
        )
            .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
            .previewDisplayName("iPhone SE")
        
    }
}
