//
//  ChatService.swift
//  
//
//  Created by Matthew Schmulen on 8/1/20.
//

import Foundation
import SwiftUI
import Combine
import CloudKit

public class ChatService : ObservableObject {
    
    private let container: CKContainer
    
    // public let objectWillChange = ObservableObjectPublisher()
    // var anyCancellable: AnyCancellable? = nil
    
    //var didChange = PassthroughSubject<Void, Never>()
    
    @Published public private (set) var chatMessageService: CKPrivateModelService<CKChatMessageModel>
    
    @Published public private (set) var chatSessionService: CKPrivateModelService<CKChatSessionModel>
    
    public init(
        container: CKContainer
    ) {
        self.container = container
        chatMessageService = CKPrivateModelService<CKChatMessageModel>(container: container)
        chatSessionService = CKPrivateModelService<CKChatSessionModel>(container: container)
        
//        anyCancellable = Publishers.CombineLatest(kidService.$models,adultService.$models).sink(receiveValue: {_ in
//            self.objectWillChange.send()
//        })
        
    }
    
    private func updateChanges() {
        DispatchQueue.main.async {
            self.objectWillChange.send()
            //self.didChange.send(())
        }
    }
    
    // TODO: make use of the ChatSessions ...
    public func sendMessage(_ chatMessageModel: CKChatMessageModel) {
        // TODO Send Message
        print( "TODO fix this update")
        //realTimeMessages.append(chatMessage)
        
        chatMessageService.pushUpdateCreate(model: chatMessageModel) { (result) in
            switch result {
            case .failure(let error):
                print("save error\(error.localizedDescription)")
            case .success(let record):
                print( "success \(record)")
                DispatchQueue.main.async {
                    //self.presentationMode.wrappedValue.dismiss()
//                    self.privateActiveChoreService.fetch { (result) in
//                        print( "result")
//                    }
                    self.onRefresh()
                }
            }
        }
    }
    
    func makeSession(_ sessionName: String) {
        // TODO find the chat session, specifically the global chat session
    }
}

// MARK: - StartupServices
extension ChatService {
    
    public func onRefresh() {
        chatMessageService.fetch ( sortDescriptor: .creationDateAscending)
        { (result) in
            print( "chatMessageService fetch \(result)")
            self.updateChanges()
        }
    }
}

