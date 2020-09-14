//
//  Agent.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 9/12/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import Combine
import FamilyKit

struct AgentModel {
    
    var name: String
    var emoji: String = "🦑"
    
//    public static func == (lhs: CKActivityModel, rhs: CKActivityModel) -> Bool {
//        return lhs.id == rhs.id
//    }
//    public func hash(into hasher: inout Hasher) { hasher.combine(id) }
    
    
}

enum Agent {
    
    case random
    case mock
    
    var name: String {
        switch self {
        case .random: return "random"
        case .mock: return "mock"
        }
    }
    
    var emoji: String {
        switch self {
        case .random: return "🦑"
        case .mock: return "🦈"
        }
    }
    
    var reccomendations: [CKActivityDescriptionModel] {
        
        var models = [CKActivityDescriptionModel]()
        
        switch self {
        case .random:
            models.append(CKActivityDescriptionModel.mock)
            models.append(CKActivityDescriptionModel.mock)
            models.append(CKActivityDescriptionModel.mock)
            models.append(CKActivityDescriptionModel.mock)
            models.append(CKActivityDescriptionModel.mock)
            models.append(CKActivityDescriptionModel.mock)
            models.append(CKActivityDescriptionModel.mock)
        case .mock:
            models.append(CKActivityDescriptionModel.mock)
            models.append(CKActivityDescriptionModel.mock)
            models.append(CKActivityDescriptionModel.mock)
        }
        
        return models
    }
}
