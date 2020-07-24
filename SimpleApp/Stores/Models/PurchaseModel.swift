//
//  PurchaseModel.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 7/20/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation

/// Purchase Model
public struct PurchaseModel: Identifiable {
    
     public typealias ModelType = UserModel
    
    public var id: UUID
    
    public var status: PurchaseStatus
    
    public enum PurchaseStatus: Int {
        case unknown
        case none
        case basic
        case premium
        
        var friendlyName: String {
            switch self {
            case .unknown: return "unknown"
            case .none: return "none"
            case .basic: return "basic"
            case .premium: return "premium"
            }
        }
    }
}

extension PurchaseModel {
    public static var mock: PurchaseModel {
        return PurchaseModel(
            id: UUID(),
            status: .unknown
        )
    }
}
