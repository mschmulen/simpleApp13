//
//  MarinaModel.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 7/19/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation

/// Marina Model
public struct MarinaModel: NetworkModel {
    
    public typealias ModelType = MarinaModel
    
    public let id: String
    public let name: String
    public let info: String
    public let country: String
}

extension MarinaModel {
    
    public static var mock: ModelType {
        return MarinaModel(
            id: UUID().uuidString,
            name: "Marina \(Int.random(in: 1...100))",
            info: "some info",
            country: "US"
        )
    }
    
    public static var mockJSON: ModelType {
        let str = """
{
"id": "5005477",
"name": "Linton Bay Marina",
"info": "Marina in Panaam",
"country": "pa"
}
"""
        let data = Data(str.utf8)
        do {
            let model = try JSONDecoder().decode(MarinaModel.self, from: data)
            return model
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
            fatalError()
        }
    }
}
