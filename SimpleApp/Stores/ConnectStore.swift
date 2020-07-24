//
//  ConnectStore.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 7/23/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import Combine

public final class ConnectStore: ObservableObject {
    
    public let objectWillChange = ObservableObjectPublisher()
    
    private var storeConfig: StoreConfig
    
    @Published public var models: [ConnectModel] = load("connectData.json")

    
//    @Published public var models: [T] = [] {
//        willSet {
//            updateChanges()
//        }
//    }
    
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
