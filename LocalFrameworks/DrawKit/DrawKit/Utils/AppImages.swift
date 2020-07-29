//
//  AppImages.swift
//  DrawKit
//
//  Created by Matthew Schmulen on 7/29/20
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct AppImage: View {
    
    let icon:ImageIcon
    
    enum ImageIcon {
        
        case reset
        case pause
        case resume
        case tools
        case info
        case file
        case layers
        case deleteLastScribbleFromLayer
        case undo
        case redo
        case close
        
        case add
        case trashAll
        case star
        
        case pencil
        case folder
        case heart
        
        case custom( name:String)
        
        
        //case play "play"
        //case refresh "refresh"
        //case play "play"
//        rewind
//        search
//        reply
//        stop
        
        //"gamecontroller"
        // "square"
        // "circle"
        
        // "cloud" cloud.rain cloud.rain.fill
        // "moon"
        // "sun.max.fill"
        // sparkles
        // "sunrise" "sunrise.fill"
        //"moon.stars.fill"
         // "tornado"
        var systemName:String {
            switch self {
            case .reset: return "r.circle.fill"
            case .pause: return "p.square.fill"
            case .resume: return "g.square.fill"
            case .tools: return "pencil.circle.fill"
            case .file: return "square.and.arrow.down"//"f.circle.fill"
            case .info: return "i.circle.fill"
            case .layers: return "l.circle.fill"
            case .deleteLastScribbleFromLayer: return "d.circle.fill"
            case .undo: return "u.circle.fill"
            case .redo: return "r.circle.fill"
            case .close: return "x.circle.fill"
                
            case .add: return "plus"
            case .trashAll: return "trash"
            case .star: return "star"
                
            case .pencil: return "pencil"
            case .folder: return "folder"
            case .heart: return "heart" // "heart.fill"
            
            case .custom( let name ): return name
                
                // case .pencil: return "pencil" // "pencil.circle", "pencil.circle.fill"
                // case .pencil: return "trash.fill"
                
                // case .pencil: return "folder" // "folder.fill"
                // case .pencil: return "pencil"
                // "square.and.arrow.up"
                // "square.and.arrow.up.fill"
                // "square.and.arrow.down"
                // "trash.circle.fill"
                
                // "camera"
                // "compose"

            }
        }
        
        var accessibilityString:String {
            switch self {
            case .reset: return "reset"
            case .pause: return "pause"
            case .resume: return "resume"
            case .tools: return "tools"
            case .info: return "info"
            case .file: return "file"
            case .layers: return "layers"
            case .deleteLastScribbleFromLayer: return "delete Scribble"
            case .undo: return "undo"
            case .redo: return "redo"
            case .close: return "close"
            
            case .add: return "add"
            case .trashAll: return "trashAll"
            case .star: return "star"
                
            case .pencil: return "pencil"
            case .folder: return "folder"
            case .heart: return "heart"
            case .custom( let name ): return name
            }
        }
        
    }
    
    var body: some View {
        Image(systemName: icon.systemName)
            .imageScale(.large)
            .accessibility(label: Text(icon.accessibilityString))
    }
    
}

//

//
//Image(systemName: "trash")
//.imageScale(.large)
//.accessibility(label: Text("Reset"))


struct AppImage_Previews: PreviewProvider {
    static var previews: some View {
        AppImage( icon: .trashAll)
    }
}
