//
//  SchoolModel.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 7/19/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation

protocol NetworkModel: Codable, Identifiable {
    
}

public struct SimpleModel : NetworkModel {
    public let id: String
    public let name: String
    public let schoolURL: String
    public let povertyLevel: String
    public let city: String
    public let zip: String
    public let state: String
    public let totalProposals: String
}

extension SimpleModel {
    
    static var mock:SimpleModel {
        let str = """
{
"id": "5005477",
"name": "some school name",
"schoolURL": "https://www.donorschoose.org/school/colson-elementary-school/59270/",
"povertyLevel": "some povertyLevel info",
"city": "Austin",
"zip": "76021",
"state": "TX",
"totalProposals":"2",
}
"""
        let data = Data(str.utf8)
        do {
            let model = try JSONDecoder().decode(SimpleModel.self, from: data)
            return model
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
            fatalError()
        }
    }
}
