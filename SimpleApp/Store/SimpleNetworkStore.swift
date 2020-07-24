//
//  SimpleNetworkStore.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 7/19/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import Combine

public enum StoreConfig {
    case prod
    case stage
    case local
}

public protocol NetworkModel: Codable, Identifiable {
    associatedtype ModelType: Codable, Identifiable
    
    static var mockJSON: ModelType { get }
    static var mock: ModelType { get }
}

/// Generic Network Store
public final class SimpleNetworkStore<T:NetworkModel>: ObservableObject {
    
    public let objectWillChange = ObservableObjectPublisher()
    
    private var storeConfig: StoreConfig
    private var url: URL {
        URL(string: "http://api.server.org/boats/")!
    }
    
    @Published public var models: [T] = [] {
        willSet {
            updateChanges()
        }
    }
    
    public init(storeConfig: StoreConfig) {
        self.storeConfig = storeConfig
    }
    
    private func updateChanges() {
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
    
    enum InternalError:Error {
        case unknown
        case invalidResponseFromServer
    }
}

extension SimpleNetworkStore {
    
    public func fetch() {
        switch storeConfig {
        case .prod:
            print( "TODO: fetchNetwork")
            fetchNetwork()
        case .stage:
            print( "TODO: fetchNetwork")
            fetchNetwork()
        case .local:
            DispatchQueue.main.async {
                self.models = []
                self.models.append(T.mockJSON as! T)
            }
        }
    }
    
    private func fetchNetwork() {
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("Error: invalid HTTP response code")
                return
            }
            guard let data = data else {
                print("Error: missing response data")
                return
            }

            do {
                let models = try JSONDecoder().decode([T].self, from: data)
                DispatchQueue.main.async {
                    self.models = models
                }
            }
            catch {
                print("Error: \(error.localizedDescription)")
            }
        }
        task.resume()

    } //end fetchNetwork

}

extension SimpleNetworkStore {
    
    public func createModel(
        _ model:T,
        completion: ((Result<T, Error>) -> ())? = nil
    ) {
        
        guard let encoded = try? JSONEncoder().encode(model) else {
            print("Failed to encode model")
            return
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data else {
                if let error = error {
                    completion?(.failure(error))
                } else {
                    completion?(.failure(InternalError.unknown))
                }
                return
            }
            
            if let decodedModel = try? JSONDecoder().decode(T.self, from: data) {
                self.models.append(decodedModel)
                self.updateChanges()
                completion?(.success(decodedModel))
            } else {
                completion?(.failure(InternalError.invalidResponseFromServer))
            }
            
        }.resume()
    }
    
    public func deleteModel(
        id: String,
        completion: ((Result<T, Error>) -> ())? = nil
    ) {
        // TODO DeleteItem
        
    }
    
    func fetchItem(
        id: String,
        completion: ((Result<T, Error>) -> ())? = nil
    ) {
        
        let mockModel = T.mock
        guard let encoded = try? JSONEncoder().encode(mockModel) else {
            print("Failed to encode model")
            return
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data else {
                if let error = error {
                    completion?(.failure(error))
                } else {
                    completion?(.failure(InternalError.unknown))
                }
                return
            }
            
            if let decodedModel = try? JSONDecoder().decode(T.self, from: data) {
                completion?(.success(decodedModel))
            } else {
                completion?(.failure(InternalError.invalidResponseFromServer))
            }
            
        }.resume()
    }
    
    // TODO updateModel
//    public func updateModel(
//        _ model:T,
//        completion: ((Result<T, Error>) -> ())? = nil
//    ) {
//
//        guard let encoded = try? JSONEncoder().encode(model) else {
//            print("Failed to encode model")
//            return
//        }
//
//        let url = URL(string: "https://reqres.in/api/cupcakes")!
//        var request = URLRequest(url: url)
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpMethod = "POST"
//        request.httpBody = encoded
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//
//            guard let data = data else {
//                if let error = error {
//                    completion?(.failure(error))
//                } else {
//                    completion?(.failure(InternalError.unknown))
//                }
//                return
//            }
//
//            if let decodedModel = try? JSONDecoder().decode(T.self, from: data) {
//                self.models.append(decodedModel)
//                self.updateChanges()
//                completion?(.success(decodedModel))
//            } else {
//                completion?(.failure(InternalError.invalidResponseFromServer))
//            }
//
//        }.resume()
//    }
    
}
