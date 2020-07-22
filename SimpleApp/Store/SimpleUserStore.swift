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
    
    struct RegisterRequestModel: Codable {
        var email: String
        var password: String
    }
    
    struct SignInResponseModel: Codable {
        var token: String
    }
    
    enum InternalError:Error {
        case unknown
        case invalidResponseFromServer
    }
}

/// UserStore
extension SimpleUserStore {
    
    public func signOut(
        completion: @escaping (Result<UserModel?, Error>) -> ()
    ){
        completion(.success(nil))
    }
    
    public func signIn(
        email: String,
        password:String,
        completion: @escaping (Result<UserModel, Error>) -> ()
    ){
//        let model = UserModel(id:12345, email:email)
//        completion(.success(model))
        
        let model = RegisterRequestModel(email: email, password: password)
        guard let encoded = try? JSONEncoder().encode(model) else {
            completion(.failure(InternalError.unknown))
            return
        }
        
        let url = URL(string: "https://reqres.in/api/login")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(InternalError.unknown))
                }
                return
            }
            
            if let decodedModel = try? JSONDecoder().decode(SignInResponseModel.self, from: data) {
                print( "token: \(decodedModel.token)")
                let user = UserModel(id: 5555, email: email)
                completion(.success(user))
            } else {
                completion(.failure(InternalError.invalidResponseFromServer))
            }
        }.resume()
        
    }
    
    public func register(
        email: String,
        password:String,
        completion: @escaping (Result<UserModel, Error>) -> ()
    ) {
        let model = RegisterRequestModel(email: email, password: password)
        guard let encoded = try? JSONEncoder().encode(model) else {
            completion(.failure(InternalError.unknown))
            return
        }
        
        let url = URL(string: "https://reqres.in/api/register")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(InternalError.unknown))
                }
                return
            }
            
            if let decodedModel = try? JSONDecoder().decode(UserModel.self, from: data) {
                completion(.success(decodedModel))
            } else {
                completion(.failure(InternalError.invalidResponseFromServer))
            }
        }.resume()
    }
}
