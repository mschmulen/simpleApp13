//
//  UserStore.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 7/23/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import Combine

public final class UserStore: ObservableObject {
    
    public let objectWillChange = ObservableObjectPublisher()
    
    private var storeConfig: StoreConfig
    
    @Published public var models: [UserModel] = load("userData.json")
    
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

extension UserStore {
    
    func addPlayer( model:UserModel) {
        models.append(model)
        updateChanges()        
    }
}
