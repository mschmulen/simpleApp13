//
//  SimpleUserStore.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 7/19/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import Combine
import SwiftUI

public final class SimpleUserStore {
}

/// UserStore
extension SimpleUserStore {
    
    public func signIn(
        email: String,
        password:String,
        completion: @escaping (Result<UserModel, Error>) -> ()
    ){
        let model = UserModel(id:UUID(), email:email)
        completion(.success(model))
    }
    
    public func signOut(
        completion: @escaping (Result<UserModel?, Error>) -> ()
    ){
        completion(.success(nil))
    }
    
    public func register(
        email: String,
        password:String,
        completion: @escaping (Result<UserModel, Error>) -> ()
    ) {
        let model = UserModel(id:UUID(), email:email)
        completion(.success(model))
    }
}
