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
    //var anyCancellable: AnyCancellable? = nil
    
//    var didChange = PassthroughSubject<Void, Never>()
    
    //@Published public private (set) var chatMessageService: CKPrivateModelService<CKChatMessageModel>
    private var chatMessageService: CKPrivateModelService<CKChatMessageModel>
    static var familyChatSessionModel: CKChatSessionModel?
    
    @Published public private (set) var chatSessionService: CKPrivateModelService<CKChatSessionModel> {
        willSet {
            updateChanges()
        }
    }
    
    @Published public private (set) var chatMessages:[CKChatMessageModel] = [CKChatMessageModel]() {
        willSet {
            updateChanges()
        }
    }
    
    private var activityService: CKPrivateModelService<CKActivityModel>
    
    public init(
        container: CKContainer
    ) {
        self.container = container
        chatMessageService = CKPrivateModelService<CKChatMessageModel>(container: container)
        chatSessionService = CKPrivateModelService<CKChatSessionModel>(container: container)
        activityService = CKPrivateModelService<CKActivityModel>(container: container)
        
//        anyCancellable = Publishers.CombineLatest(chatSessionService.$models,familyChatSessionModel).sink(receiveValue: {_ in
//            self.objectWillChange.send()
//        })
    }
    
    enum CustomError: Error {
        case unknown
    }
    
    private func updateChanges() {
        DispatchQueue.main.async {
            //self.didChange.send()
            self.objectWillChange.send()
        }
    }
    
    public func onStartUp() {
        self.findOrMakeFamilySession { (result) in
            switch result {
            case .failure(let error):
                print( "error \(error)")
            case .success(let sessionModel):
                DispatchQueue.main.async {
                    ChatService.familyChatSessionModel = sessionModel
                }
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: 500)) {
                    self.onRefresh()
                }
            }
        }
    }
    
    // TODO: make use of the ChatSessions ...
    public func sendMessage(_ chatMessageModel: CKChatMessageModel, sessionModel: CKChatSessionModel) {
        
        chatMessages.append(chatMessageModel)
        guard let chatMessage = chatMessageModel.message else {
            self.onRefresh()
            return
        }
        
        if chatMessage.isEmpty == true {
            self.onRefresh()
            return
        }
        
        chatMessageService.pushUpdateCreate(model: chatMessageModel) { (result) in
            switch result {
            case .failure(let error):
                print("save error\(error.localizedDescription)")
            case .success(let record):
                print( "success \(record)")
                
                if let recordID = record.ckRecord?.recordID {
                    
                    let chatRecoredReference = CKRecord.Reference(recordID: recordID, action: .deleteSelf)
                    sessionModel.chatMessages.append(chatRecoredReference)
                    
                    self.chatSessionService.pushUpdateCreate(model: sessionModel) { (resultSession) in
                        switch resultSession {
                        case .failure(let error):
                            print( "failure \(error)")
                        case .success(let sessionResult):
                            print( "session Result \(sessionResult)")
                            
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
                case .failure(_):
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
        if let familyChatSessionModel = ChatService.familyChatSessionModel  {
            completion(.success(familyChatSessionModel))
        }
        else {
            chatSessionService.fetchByName(name:"Family Chat") { fetchResult in
                switch fetchResult {
                case .success(let fetchResultModel):
                    completion(.success(fetchResultModel))
                case .failure(_):
                    completion(.failure(CustomError.unknown))
                    var newChatSession = CKChatSessionModel()
                    newChatSession.name = "Family Chat"
                    self.chatSessionService.pushUpdateCreate(model: newChatSession) { (newChatSessionResult) in
                        switch newChatSessionResult {
                        case .failure(_):
                            completion(newChatSessionResult)
                        case .success(let resultSession):
                            ChatService.familyChatSessionModel = resultSession
                            completion(.success(resultSession))
                        }
                    }
                }
            }//end fetchByName
        }
        completion(.failure(CustomError.unknown))
    }// end findOrMakeSession
}

// MARK: - StartupServices
extension ChatService {
    
    // TODO: Rename onRefresh onRefetchFromServer
    public func onRefresh() {
        chatMessageService.fetch ( sortDescriptor: .creationDateAscending)
        { (result) in
            switch result {
            case .success( let models):
                print( "onRefresh.models: \(models.count)")
                self.chatMessages = models
                self.updateChanges()
            case .failure( let error):
                print( "onRefresh.error: \(error)")
                self.updateChanges()
            }
        }
    }
    
    public func onDelete( model:CKChatMessageModel ) {
        self.chatMessageService.pushDelete(model: model) { (result) in
            print("delete result \(result)")
        }
    }
}

