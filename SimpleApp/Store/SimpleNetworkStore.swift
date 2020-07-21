//
//  SimpleNetworkStore.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 7/19/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import Combine

public enum ServerConfig {
    case prod
    case stage
    case mock
}

public protocol NetworkModel: Codable, Identifiable {
    associatedtype ModelType
    static var mockJSON: ModelType { get }
    static var mock: ModelType { get }
}

/// Generic Network Store
public final class SimpleNetworkStore<T:NetworkModel>: ObservableObject {
    
    public let objectWillChange = ObservableObjectPublisher()
    
    private var serverConfig: ServerConfig
    private var url: URL {
        URL(string: "http://api.server.org/boats/")!
    }
    
    @Published public var models: [T] = [] {
        willSet {
            updateChanges()
        }
    }
    
    public init(serverConfig: ServerConfig) {
        self.serverConfig = serverConfig
    }
    
    private func updateChanges() {
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
}

extension SimpleNetworkStore {
    
    public func addModel(_ model:T) {
        models.append(model)
        updateChanges()
    }
    
}

extension SimpleNetworkStore {
    
    public func fetch() {
        switch serverConfig {
        case .prod:
            print( "TODO fetchNetwork")
            fetchNetwork()
        case .stage:
            print( "TODO fetchNetwork")
            fetchNetwork()
        case .mock:
            DispatchQueue.main.async {
                self.models = []
                self.models.append(T.mockJSON as! T)
                print( "models.count \(self.models.count)")
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
