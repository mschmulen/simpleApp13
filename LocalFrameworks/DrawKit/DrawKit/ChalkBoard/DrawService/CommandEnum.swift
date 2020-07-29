//
//  Command.swift
//  DrawKit
//
//  Created by Matthew Schmulen on 7/29/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation
import SwiftUI

enum Command: Identifiable {
    
    case setTool( uuid: UUID, new: Tool, old: Tool)
    //case addDrawable( uuid: UUID, drawable: Drawable )
    case addScribble( uuid: UUID, scribble: Scribble )
    case addLine( uuid: UUID, drawable: Line )
    case addStamp( uuid: UUID, stamp: Stamp )
    
    case newLayer( uuid: UUID, name: String )
    case changeBoardBackground (uuid: UUID, new: UIColor, old:UIColor)
    case clearAllLayers ( uuid: UUID , oldLayers: Stack<Layer>)
    //case clearAllCommands ( uuid: UUID , oldCommands: Stack<Commnd>)
    case deleteLastScribbleFromActiveLayer( uuid: UUID, oldScribble: Scribble? )
    //case updateMetaInfo( uuid: UUID, title: String, description: String )
    
}

extension Command: CustomStringConvertible {
    
    var description: String {
        return self.info
    }
    
    var info: String {
        switch self {
        case .setTool(_ , let new , let old):
            return "setTool new:\(new.info) old:\(old.info) "
        case .addScribble( _, let scribble ):
            return "addScribble \(scribble.info)"
        case .addLine( _, let drawable ):
            return "addLine \(drawable.info)"
        case .addStamp( _, let stamp ):
            return "addStamp \(stamp.info)"
        case .changeBoardBackground (_, let new, let old):
            return "changeBoardBackground new:\(new) old:\(old)"
        case .newLayer(_, let name ):
            return "newLayer \(name)"
        case .clearAllLayers( _, _):
            return "clearAllLayers"
        case .deleteLastScribbleFromActiveLayer( _, _):
            return "deleteLastScribbleFromActiveLayer"
        }
    }
    
    var id: UUID {
        switch self {
        case .setTool( let id, _ , _):
            return id
        case .addScribble( let id, _ ):
            return id
        case .addLine(let id , _):
            return id
        case .addStamp( let id, _ ):
            return id
        case .changeBoardBackground (let id, _, _):
            return id
        case .newLayer(let id, _):
            return id
        case .clearAllLayers( let id, _):
            return id
        case .deleteLastScribbleFromActiveLayer( let id,_):
            return id
        }
    }
    
    
}

extension Command : Equatable {
    static func == (lhs: Command, rhs: Command) -> Bool {
        if lhs.id == rhs.id {
            return true
        } else {
            return false
        }
    }
}

extension Command : Codable {
    
    private enum CodingKeys: String, CodingKey {
        
        case uuid
        case command
        
        case name
        case scribble
        case oldLayers
        case newColor
        case oldColor
        case newTool
        case oldTool
        case stamp
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        guard let id = try? container.decode(UUID.self, forKey: .uuid) else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: container.codingPath, debugDescription: "Data doesn't match"))
        }
        
        guard let commandString = try? container.decode(String.self, forKey: .command) else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: container.codingPath, debugDescription: "Data doesn't match"))
        }
        
        switch commandString {
        case "setTool":
            do {
                // let newTool = try container.decode(ScribblePen.self, forKey: .newTool)
                // let oldTool= try container.decode(ScribblePen.self, forKey: .oldTool)
                self = .setTool(uuid: id, new: Tool.none, old: Tool.none)
            } catch {
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: container.codingPath, debugDescription: "Data doesn't match"))
            }
            
        case "addScribble":
            do {
                let scribble = try container.decode(Scribble.self, forKey: .scribble)
                self = .addScribble(uuid: id, scribble: scribble)
            } catch {
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: container.codingPath, debugDescription: "Data doesn't match"))
            }
        case "addStamp":
            do {
                let stamp = try container.decode(Stamp.self, forKey: .stamp)
                self = .addStamp(uuid: id, stamp: Stamp.mock)
            } catch {
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: container.codingPath, debugDescription: "Data doesn't match"))
            }
        case "changeBoardBackground":
            do {
                let newColorData = try container.decode(ColorData.self, forKey: .newColor)
                let oldColorData = try container.decode(ColorData.self, forKey: .oldColor)
                self = .changeBoardBackground(uuid: id, new: newColorData.uiColor, old: oldColorData.uiColor)
            } catch {
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: container.codingPath, debugDescription: "Data doesn't match"))
            }
        case "newLayer":
            do {
                let name = try container.decode(String.self, forKey: .name)
                self = .newLayer(uuid: id, name: name)
            } catch {
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: container.codingPath, debugDescription: "Data doesn't match"))
            }
        case "removeAllLayers":
            do {
                let oldLayers = try container.decode(Stack<Layer>.self, forKey: .oldLayers)
                self = .clearAllLayers(uuid: id, oldLayers: oldLayers)
            } catch {
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: container.codingPath, debugDescription: "Data doesn't match"))
            }
        case "deleteLastScribbleFromActiveLayer":
            if let oldScribble = try? container.decode(Scribble.self, forKey: .scribble) {
                self = .deleteLastScribbleFromActiveLayer(uuid: id, oldScribble: oldScribble)
            } else {
                self = .deleteLastScribbleFromActiveLayer(uuid: id, oldScribble: nil)
            }
        default:
            print( "command\(commandString)")
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: container.codingPath, debugDescription: "Data doesn't match"))
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .setTool( let uuid, let new, let old ):
            try container.encode(uuid, forKey: .uuid)
//            try container.encode(new, forKey: .newTool)
//            try container.encode(old, forKey: .oldTool)
            try container.encode("setTool", forKey: .command)
        case .addScribble( let uuid, let scribble ):
            try container.encode(uuid, forKey: .uuid)
            try container.encode("addScribble", forKey: .command)
            try container.encode(scribble, forKey: .scribble)
        case .addLine( let uuid, let drawable ):
            try container.encode(uuid, forKey: .uuid)
            try container.encode("addLine", forKey: .command)
            // MAS TODO Fix this
            try container.encode(drawable, forKey: .scribble)
        case .addStamp( let uuid, let stamp ):
            try container.encode(uuid, forKey: .uuid)
            try container.encode("addStamp", forKey: .command)
            try container.encode(stamp, forKey: .stamp)
        case .changeBoardBackground (let uuid, let newColor, let oldColor):
            try container.encode(uuid, forKey: .uuid)
            try container.encode("changeBoardBackground", forKey: .command)
            try container.encode(ColorData(newColor), forKey: .newColor)
            try container.encode(ColorData(oldColor), forKey: .oldColor)
        case .newLayer(let uuid, let name):
            try container.encode(uuid, forKey: .uuid)
            try container.encode("newLayer", forKey: .command)
            try container.encode(name, forKey: .name)
        case .clearAllLayers( let uuid, let oldLayers):
            try container.encode(uuid, forKey: .uuid)
            try container.encode("removeAllLayers", forKey: .command)
            try container.encode(oldLayers, forKey: .oldLayers)
        case .deleteLastScribbleFromActiveLayer( let uuid, let oldScribble):
            try container.encode(uuid, forKey: .uuid)
            try container.encode("deleteLastScribbleFromActiveLayer", forKey: .command)
            if let oldScribble = oldScribble {
                try container.encode(oldScribble, forKey: .scribble)
            }
        }
    }
}

