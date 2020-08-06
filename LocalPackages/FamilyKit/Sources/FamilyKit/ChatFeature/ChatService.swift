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
    
    var didChange = PassthroughSubject<Void, Never>()
    
    //@Published var realTimeMessages = DataSource.messages
    
    @Published public private (set) var chatMessageService: CKPrivateModelService<CKChatMessageModel>
    
//    @Published public private (set) var currentPlayer: Player = Player.none {
//        didSet {
//            print( "did update the current player")
//            // TODO: fire off an update to the device service to udpate the current CKDeviceModel
//        }
//    }
    
    public init(
        container: CKContainer
    ) {
        
        self.container = container
        chatMessageService = CKPrivateModelService<CKChatMessageModel>(container: container)
        
//        anyCancellable = Publishers.CombineLatest(kidService.$models,adultService.$models).sink(receiveValue: {_ in
//            self.objectWillChange.send()
//        })
        
    }
    
    private func updateChanges() {
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
    
    func sendMessage(_ chatMessageModel: CKChatMessageModel) {
        // TODO Send Message
        print( "TODO send the message")
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
                    self.updateChanges()
                }
            }
        }
        
        didChange.send(())
    }
}

// MARK: - StartupServices
extension ChatService {
    
    public func onRefresh() {
        chatMessageService.fetch { (result) in
            print( "chatMessageService fetch \(result)")
            self.updateChanges()
        }
        self.updateChanges()
    }
}

