//
//  ChoreModel.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 7/23/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation
import SwiftUI

public struct ChoreModel: Hashable, Codable, Identifiable {
    public var id: Int
    var name: String
    fileprivate var imageName: String
}

extension ChoreModel {
    var image: Image {
        ImageStore.shared.image(name: imageName)
    }
}
