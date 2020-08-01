//
//  File.swift
//  
//
//  Created by Matthew Schmulen on 8/1/20.
//

import Foundation

struct ChatUser: Hashable {
    var name: String
    var emoji: String
    var isCurrentUser: Bool = false
}

