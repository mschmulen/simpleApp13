//
//  BoatModel.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 7/19/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation

/// Boat Model
public struct BoatModel : NetworkModel {
    
    public typealias ModelType = BoatModel
    
    public let id: String
    public let name: String
    public let info: String
    public let imageURL: String
    public let hullMaterial: String
    public let loa: String
    public let lwl: String
    public let displacement: String
    public let beam: String
    public let rig: String
}

extension BoatModel {
    
    
    public static var mock: ModelType {
        return BoatModel(
            id: UUID().uuidString,
            name: "Boat \(Int.random(in: 1...100))",
            info: "some info",
            imageURL: "https://images.boats.com/resize/1/22/57/7472257_20200606162043594_1_XLARGE.jpg?t=1591461800000&w=600&h=600",
            hullMaterial: "Fiberglass",
            loa: "39.92 ft / 12.17 m",
            lwl: "34.00 ft / 10.36 m",
            displacement: "23,520 lb / 10,668 kg",
            beam: "12.33 ft / 3.76 m",
            rig: "Cutter"
        )
    }
    
    public static var mockJSON: ModelType {
        let str = """
{
"id": "5005477",
"name": "Valiant 40",
"info": "Valiant 40",
"imageURL": "https://images.boats.com/resize/1/22/57/7472257_20200606162043594_1_XLARGE.jpg?t=1591461800000&w=600&h=600",
"hullMaterial": "Fiberglass",
"loa": "39.92 ft / 12.17 m",
"lwl": "34.00 ft / 10.36 m",
"displacement": "23,520 lb / 10,668 kg",
"beam":"12.33 ft / 3.76 m",
"rig":"cutter",
}
"""
        let data = Data(str.utf8)
        do {
            let model = try JSONDecoder().decode(BoatModel.self, from: data)
            return model
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
            fatalError()
        }
    }
}
