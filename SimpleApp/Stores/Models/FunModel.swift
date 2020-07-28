//
//  FunModel.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 7/23/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation
import SwiftUI

public struct FunModel: Hashable, Codable, Identifiable {
    public var id: Int
    public var name: String
    public var points: Int
    
    fileprivate var imageName: String
}

extension FunModel {
    var image: Image {
        ImageStore.shared.image(name: imageName)
    }
}

