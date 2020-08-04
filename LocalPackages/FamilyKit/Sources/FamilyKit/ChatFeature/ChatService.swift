//
//  ChatService.swift
//  
//
//  Created by Matthew Schmulen on 8/1/20.
//

import Foundation
import SwiftUI
import Combine

public class ChatService : ObservableObject {
    
    var didChange = PassthroughSubject<Void, Never>()
    
    @Published var realTimeMessages = DataSource.messages
    
    public init() {
    }
    
    func sendMessage(_ chatMessage: ChatMessage) {
        realTimeMessages.append(chatMessage)
        didChange.send(())
    }
}

