//
//  DrawPadService.swift
//  DrawKit
//
//  Created by Matthew Schmulen on 7/29/20
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import UIKit
import Combine

struct DrawPadInfo {
    let name: String
    let description: String
}

class DrawPadService: ObservableObject {
    
    public let objectWillChange = PassthroughSubject<Void,Never>()
    
    public let fileService: FileService
    
    @Published
    public private(set) var canvasColor: UIColor {
        didSet {
            update()
        }
    }
    
    @Published
    public var title: String {
        didSet {
            update()
        }
    }
    
    @Published
    public var description: String {
        didSet {
            update()
        }
    }
    
    @Published
    public private(set) var activeTool: Tool {
        didSet {
            update()
        }
    }
    
    @Published
    public private(set) var layers: Stack<Layer> {
        didSet {
            update()
        }
    }
    
    public private(set) var undoStack: Stack<Command>
    
    public private(set) var redoStack: Stack<Command>
    
    public init(_ fileService:FileService) {
        self.fileService = fileService
        
        activeTool = .none
        canvasColor = .black
        title = "init title"
        description = "init description"
        
        undoStack = Stack<Command>()
        redoStack = Stack<Command>()
        layers = Stack<Layer>()
        layers.push(Layer.mock)
    }
    
    func update() {
        //DispatchQueue.main.async {
        self.objectWillChange.send()
        //}
    }
    
    enum ServiceError: Error {
        case unknown
        case invalidCommand
    }
}//end DrawPadService

// MARK: Command methods
extension DrawPadService {
    
    public func apply( command: Command) -> Result<Bool, Error> {
        switch command {
        case .setTool( _, let new, let old):
            activeTool = new
            undoStack.push( command )
        case .addScribble( _, let drawable ):
            if drawable.points.count <= 0 {
                return .failure(ServiceError.unknown)
            }
            if var activeLayer = layers.pop() {
                activeLayer.push(drawable)
                layers.push(activeLayer)
            }
            undoStack.push( command )
        case .addLine( _, let drawable ):
            if var activeLayer = layers.pop() {
                activeLayer.push(drawable)
                layers.push(activeLayer)
            }
            undoStack.push( command )
        case .addStamp( _, let stamp ):
            if var activeLayer = layers.pop() {
                activeLayer.push(stamp)
                layers.push(activeLayer)
            }
            undoStack.push( command )
        case .changeBoardBackground (_, let color, _):
            self.canvasColor = color
            undoStack.push( command )
        case .newLayer( _, let name):
            self.layers.push(Layer(name: name))
            undoStack.push( command )
        case .clearAllLayers( _, _):
            self.layers = Stack<Layer>()
            self.layers.push(Layer.mock)
            undoStack.push( command )
        case .deleteLastScribbleFromActiveLayer:
            var cachedScribble:Scribble? = nil
            if var activeLayer = layers.pop() {
//                cachedScribble = activeLayer.popScribble()
//                _ = activeLayer.popScribble()
//                layers.push(activeLayer)
            }
            undoStack.push(.deleteLastScribbleFromActiveLayer(uuid: command.id, oldScribble: cachedScribble))
            
            // case .updateInfo(_,let title,let description):
            //            self.title = title
            //            self.description = description
        }
        update()
        
        return .success(true)
    }
    
    public func undoLastCommand() -> Result<Command?, Error> {
        if let command = undoStack.pop() {
            switch command {
            case .setTool(_, let new, let old):
                self.activeTool = old
                redoStack.push(command)
                update()
                return .success( command )
            case .addScribble(_, _ ):
//                if var activeLayer = layers.pop() {
//                    _ = activeLayer.popScribble()
//                    layers.push(activeLayer)
//                }
//                update()
//                redoStack.push(command)
                //return .success( command )
                return .failure(ServiceError.invalidCommand)
            case .addLine( _, let drawable ):
//                 if var activeLayer = layers.pop() {
//                     _ = activeLayer.popLine()
//                     layers.push(activeLayer)
//                 }
//                 update()
//                 redoStack.push(command)
//                 return .success( command )
                return .failure(ServiceError.invalidCommand)
            case .addStamp(_,_):
//                if var activeLayer = layers.pop() {
//                    _ = activeLayer.popStamp()
//                    layers.push(activeLayer)
//                }
//                update()
//                redoStack.push(command)
//                return .success( command )
                return .failure(ServiceError.invalidCommand)
            case .newLayer(_,_):
                _ = layers.pop()
                update()
                redoStack.push(command)
                return .success( command )
            case .changeBoardBackground(_, _, let oldColor):
                self.canvasColor = oldColor
                update()
                redoStack.push(command)
                return .success( command )
            case .clearAllLayers( _, let oldLayers):
                self.layers = oldLayers
                update()
                redoStack.push(command)
                return .success( command )
            default:
                return .failure( ServiceError.invalidCommand )
            }
        } else {
            return .failure( ServiceError.invalidCommand )
        }
    }
    
    public func redoTheLastUndo() -> Result<Command?, Error> {
        if let redoCommand = redoStack.pop() {
            
            let result = apply(command: redoCommand)
            switch result {
            case .success:
                return .success(redoCommand)
            case .failure(let error):
                return .failure(error)
            }
        } else {
            return .failure( ServiceError.invalidCommand )
        }
    }//end redoTheLastUndo
    
}//end DrawPadService

// MARK: FILE IO
extension DrawPadService {
    
    public func saveToFile(shortFileName:String) -> Result<Bool, Error> {
        let drawingData = DrawingData(
            version: "1.0.0",
            title: self.title,
            description: self.description,
            lastSaveDate: Date(),
            createdDate: Date(),
            layers: self.layers,
            //activeTool: self.activeTool,
            commandStack: self.undoStack
        )
        
        let result = fileService.writeToFileStorage(shortFileName: shortFileName, data: drawingData)
        switch result {
        case .failure(let error) :
            print( "failed \(error)")
        case .success(let data):
            print( "success \(data)")
        }
        return result
    }
    
    public func loadFromFile( shortFileName: String ) -> Result<DrawingData, Error> {
        let result = fileService.readFromFileStorage(shortFileName: shortFileName)
        switch result {
        case .failure(let error) :
            return .failure( error )
        case .success(let data):
            guard let data = data else {
                return .failure(ServiceError.unknown)
            }
            loadFromData(data)
            return .success(data)
        }
    }
    
    private func loadFromData(_ data: DrawingData ) {
        self.title = data.title
        self.description = data.description
        self.layers = data.layers
        //self.activeTool = data.activeTool
        self.undoStack = data.commandStack
    }
}

extension DrawPadService {
    
    // let pasteboard = UIPasteboard.general
    // pasteboard?.persistent = true
    
    // TODO: exportToClipBoard
    public func exportToClipBoard() -> Result<Bool, Error> {
        print("MAS TODO exportToClipBoard")
        let pasteboard = UIPasteboard.general
        pasteboard.string = "Hello, DrawKit!"
        
        //        imageView:UIImageView
        //        let image = imageView.image!
        //        if let data = image.pngData() {
        //            ///pasteboard.setData(data, forPasteboardType: .kUTTypePNG as String)
        //        }
        
        //        if let data = UIImagePNGRepresentation(image) {
        //            UIPasteboard.generalPasteboard().setData(data,
        //                forPasteboardType: kUTTypePNG as String)
        //        }
        
        return .success(true)
    }
    
    // TODO: exportToFile
    public func exportToFile(shortFileName: String) -> Result<Bool, Error> {
        print("MAS TODO exportToFile")
        return .success(true)
    }
    
    public func addFromPasteBoard() {
        
        let pasteboard = UIPasteboard.general
        if pasteboard.hasStrings{
            print("pasteboard has strings")
        }
        if pasteboard.hasImages{
            print("pasteboard has images")
        }
        //backgroundImage.image = pasteboard.image
        //            let imageTypes = UIPasteboardTypeListImage as! [String]
        //            if pasteboard.containsPasteboardTypes(imageTypes) {
        //                for imageType in imageTypes {
        //                    if let data = pasteboard.dataForPasteboardType(imageType) {
        //                        if let image = UIImage(data: data) {
        //                            // found image
        //                            break
        //                        }
        //                    }
        //                }
        //            }
        
        //        let imageView = UIImageView(frame: pasteContentView.bounds)
        //        imageView.contentMode = .Center
        //        pasteContentView.addSubview(imageView)
        //        return imageView
    }
}
