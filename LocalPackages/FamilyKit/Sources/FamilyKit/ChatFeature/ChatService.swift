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
    
    private var activityService: CKPrivateModelService<CKActivityModel>
    
    private var familyChatSessionModel: CKChatSessionModel?
    
    public init(
        container: CKContainer
    ) {
        self.container = container
        chatMessageService = CKPrivateModelService<CKChatMessageModel>(container: container)
        chatSessionService = CKPrivateModelService<CKChatSessionModel>(container: container)
        activityService = CKPrivateModelService<CKActivityModel>(container: container)
        //        anyCancellable = Publishers.CombineLatest(kidService.$models,adultService.$models).sink(receiveValue: {_ in
        //            self.objectWillChange.send()
        //        })
        
    }
    
    enum CustomError: Error {
        case unknown
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
    
    
    public func findOrMakeSession(
        model: CKActivityModel,
        completion: @escaping ((Result<CKChatSessionModel,Error>) -> Void)
    ) {
        if let chatSessionReference = model.chatSession  {
            chatSessionService.fetchByReference(modelReference: chatSessionReference) { (result) in
                completion(result)
            }
        } else {
            var newChatSession = CKChatSessionModel()
            newChatSession.name = "\(model.name ?? "~")"
            chatSessionService.pushUpdateCreate(model: newChatSession) { (result) in
                switch result {
                case .failure(let error):
                    completion(result)
                case .success(let resultSession):
                    if let recordRef = resultSession.ckRecord {
                        model.chatSession = CKRecord.Reference(recordID: recordRef.recordID, action: .deleteSelf)
                        self.activityService.pushUpdateCreate(model: model) { (activityResult) in
                            switch activityResult {
                            case .failure(let error):
                                completion(.failure(error))
                            case .success(_):
                                completion(result)
                            }
                        }
                    } else {
                        completion(.failure(CustomError.unknown))
                    }
                }
            }
        }
    }// end findOrMakeSession
    
    
    public func findOrMakeFamilySession(
        completion: @escaping ((Result<CKChatSessionModel,Error>) -> Void)
    ) {
//        if let familyChatSessionModel = familyChatSessionModel  {
//            completion(.success(familyChatSessionModel))
//        }
//        else {
//
//            //find the chat session
//            chatSessionService.fetchByName(name:"Family Chat") { result in
//                switch self{
//                case .success(let resultSession):
//                    completion(result)
//
//                case .failure(let error):
//                    // TRY and Make it !
//                    completion(.failure(CustomError.unknown))
//
//                    var newChatSession = CKChatSessionModel()
//                    newChatSession.name = "Family Chat"
//
//                    chatSessionService.pushUpdateCreate(model: newChatSession) { (newChatSessionResult) in
//                        switch newChatSessionResult {
//                        case .failure(let error):
//                            completion(newChatSessionResult)
//                        case .success(let resultSession):
//                            self.familyChatSessionModel = resultSession
//                            completion(.success(resultSession))
//                        }
//                    }
//                }
//            }
//        }
        
        completion(.failure(CustomError.unknown))
    }// end findOrMakeSession
}

// MARK: - StartupServices
extension ChatService {
    
    public func onRefresh() {
        chatMessageService.fetch ( sortDescriptor: .none)
        { (result) in
            //print( "chatMessageService fetch \(result)")
            self.updateChanges()
        }
    }
}

