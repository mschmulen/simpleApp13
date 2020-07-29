//
//  Layer.swift
//  DrawKit
//
//  Created by Matthew Schmulen on 7/29/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation

struct Layer: Codable, Identifiable {
    
    let id: UUID = UUID()
    var name: String
    
    var drawables: StackDrawable = StackDrawable()
    
    var info: String {
        return " name:\(name) drawables:\(drawables.items.count) "
    }

    init(name:String) {
        self.name =  name
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        //case drawables
    }
}

extension Layer {
    
    static var mock: Layer {
        return Layer(
            name: "init"
        )
    }
}

extension Layer {
    
//    mutating func pushMixed(_ u:ListItemDrawable) {
//        mixedStack.push(u)
//    }
    
    mutating func pop() -> Drawable? {
        return drawables.pop()
    }
    
    mutating func push<U: Drawable>(_ u:U) {
//        print( "u \(u.id) \(type(of: u.self))")
//        var a = [U]()
//        a.append(u)
//        var drawables = StackX<U>()
//        drawables.push(u)
            
        drawables.push(u)
    }
    
//    mutating func push(_ drawable:Scribble) {
//        self.scribbles.push(drawable)
//        self.push(drawable)
//    }

//    mutating func popScribble() -> Scribble? {
//        return drawables.pop()
//    }
    
//    mutating func push(_ drawable:Stamp) {
//        self.stamps.push(drawable)
//        self.push(drawable)
//    }

//    mutating func popStamp() -> Stamp? {
//        return stamps.pop()
//    }
    
    //    func peekScribble() -> Scribble? {
    //        return self.drawables.peek()
    //    }
    
//    mutating func popLine() -> Line? {
//        return lines.pop()
//    }
    
}
