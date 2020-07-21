//
//  UserModel.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 7/19/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation

/// User Model
public struct UserModel: NetworkModel {
    
    public typealias ModelType = UserModel
    
    public var id: UUID
    public var email: String
}

extension UserModel {
    
    public static var mock: UserModel {
        return UserModel(
            id: UUID(),
            email: "mock@mock.com"
        )
    }
    
    public static var mockJSON: UserModel {
        return UserModel(
            id: UUID(),
            email: "mock@mock.com"
        )
    }
}

