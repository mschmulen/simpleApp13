//
//  AgentService.swift
//  
//
//  Created by Matthew Schmulen on 9/23/20.
//

import Combine
import CloudKit

public final class AgentService: ObservableObject {
    
    public let objectWillChange = ObservableObjectPublisher()
    
    internal var container: CKContainer
    
    public private (set) var name: String
    public private (set) var emoji: String
    
    private var agentConfig: AgentConfig
    private var publicActivityDescriptionService: CKPublicModelService<CKPublicActivityDescription>
    
    @Published public var models: [CKPublicActivityDescription] = [CKPublicActivityDescription]() {
        willSet {
            updateChanges()
        }
    }
    
    public init(
        container: CloudKitContainer
    ) {
        
        switch container {
        case .CloudContainer(let container):
            self.container = container
        case .MockContainer(let container):
            self.container = container
        }
        
        publicActivityDescriptionService = CKPublicModelService<CKPublicActivityDescription>(
            container: container
        )
        
        agentConfig = .random
        name = "random"
        emoji = "🦑"
        
    }
    
    internal func updateChanges() {
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
}

extension AgentService {
    
    enum AgentConfig {
        case random
    }
}


extension AgentService {
    public func pushNew(model: CKPublicActivityDescription) {
        publicActivityDescriptionService.pushUpdateCreate(model: model) { (result) in
            switch result {
            case .failure(let error) :
                print( "error \(error)")
            case .success(let model):
                print( "success \(model)")
            }
        }
    }
}

extension AgentService {
    
    public struct AgentInput {
        
        public let adultAges: [Int] = [35,37]
        public let childAges: [Int] = [12,5,8]
        
        public init() {
        }
    }
    
    public func upateRecommendations(agentInput: AgentInput) {
        publicActivityDescriptionService.fetch(sortDescriptor: .none, searchPredicate: .predicateTrue) { result in
            switch result {
            case .success( let models):
                print( "fetchReccomendations publicActivityDescriptionService \(models.count)")
                self.models.removeAll()
                self.models.append(contentsOf: models)
                self.agentFilter( agentInput: agentInput, config: self.agentConfig)
            case .failure( let error):
                print( "fetchReccomendations publicActivityDescriptionService error \(error)")
                self.models.removeAll()
                self.models.append(CKPublicActivityDescription.mock)
                self.models.append(CKPublicActivityDescription.mock)
                self.models.append(CKPublicActivityDescription.mock)
            }
        }
    }
    
    private func agentFilter( agentInput: AgentInput, config: AgentConfig ) {
        switch self.agentConfig {
        case .random:
            self.models.shuffle()
        }
    }
    
}
