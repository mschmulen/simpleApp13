//
//  DrawableTool.swift
//  DrawKit
//
//  Created by Matthew Schmulen on 7/29/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

protocol DrawableTool :Identifiable, Codable {
    
    associatedtype DrawableToolType
    
    var id: UUID { get }
    
    // MAS TODO add drawable and shader
    // var drawable: Drawable  { get }
    var stroke: Stroke { get }
    
    var info:String { get }
}
