//
//  Drawable.swift
//  DrawKit
//
//  Created by Matthew Schmulen on 7/29/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

protocol Drawable {
    
    //associatedtype DrawableType
    
    var id: UUID { get }
    
    var shader: Shader { get }
    
    var drawView: AnyView { get }
    
    //static var mock: DrawableType { get }
    //static var mock: Drawable { get }
}







