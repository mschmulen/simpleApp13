//
//  DrawingData.swift
//  DrawKit
//
//  Created by Matthew Schmulen on 7/29/20
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation

struct DrawingData: Codable {
    
    let version: String
    let title: String
    let description: String
    let lastSaveDate: Date
    let createdDate: Date
    let layers: Stack<Layer>
    //let activeTool: Tool
    let commandStack: Stack<Command>
    
    enum CodingKeys: CodingKey {
        case version
        case title
        case description
        case lastSaveDate
        case createdDate
        case layers
        //case activeTool
        case commandStack
    }
    
    static var mock:DrawingData {
        return DrawingData(
            version: "",
            title: "",
            description: "",
            lastSaveDate: Date(),
            createdDate: Date(),
            layers: Stack<Layer>(),
            //activeTool: Tool.scribble(ScribblePen.mock),
            commandStack: Stack<Command>()
        )
    }
}
