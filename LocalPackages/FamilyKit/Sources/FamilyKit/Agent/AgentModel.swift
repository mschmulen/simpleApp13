//
//  File.swift
//  
//
//  Created by Matthew Schmulen on 9/23/20.
//

import Foundation

public struct AgentModel {
    
    public var name: String
    public var emoji: String
    
//    public static func == (lhs: CKActivityModel, rhs: CKActivityModel) -> Bool {
//        return lhs.id == rhs.id
//    }
//    public func hash(into hasher: inout Hasher) { hasher.combine(id) }
    
    public static var mock:AgentModel {
        return AgentModel(name: "mock", emoji: "🦑")
    }
    
}

extension AgentModel {
    
    public struct AgentInput {
        public let numberOfChildren = 3
        public let numberOfAdults = 2
        
        public init() {
            
        }
    }
    
    public func generateRecommendations( agentInput: AgentInput ) -> [CKPublicActivityDescription] {
        
        var models = [CKPublicActivityDescription]()
        models.append(CKPublicActivityDescription.mock)
        models.append(CKPublicActivityDescription.mock)
        models.append(CKPublicActivityDescription.mock)

        return models
    }
    
}

//public enum AgentConfig {
//
//    case random
//    case mock
//
//    public var name: String {
//        switch self {
//        case .random: return "random"
//        case .mock: return "mock"
//        }
//    }
//
//    public var emoji: String {
//        switch self {
//        case .random: return "🦑"
//        case .mock: return "🦈"
//        }
//    }
//
//    public var reccomendations: [CKActivityDescriptionModel] {
//
//        var models = [CKActivityDescriptionModel]()
//
//        switch self {
//        case .random:
//            models.append(CKActivityDescriptionModel.mock)
//            models.append(CKActivityDescriptionModel.mock)
//            models.append(CKActivityDescriptionModel.mock)
//            models.append(CKActivityDescriptionModel.mock)
//            models.append(CKActivityDescriptionModel.mock)
//            models.append(CKActivityDescriptionModel.mock)
//            models.append(CKActivityDescriptionModel.mock)
//        case .mock:
//            models.append(CKActivityDescriptionModel.mock)
//            models.append(CKActivityDescriptionModel.mock)
//            models.append(CKActivityDescriptionModel.mock)
//        }
//
//        return models
//    }
//}

