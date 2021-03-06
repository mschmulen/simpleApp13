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

public class ChatService: ObservableObject {
    
    private let container: CKContainer
    public let objectWillChange = ObservableObjectPublisher()
    // var anyCancellable: AnyCancellable? = nil
    
    // var didChange = PassthroughSubject<Void, Never>()
    
    //@Published public private (set) var chatMessageService: CKPrivateModelService<CKChatMessageModel>
    
    private var chatMessageService: CKPrivateModelService<CKChatMessageModel>
    static var familyChatSessionModel: CKChatSessionModel?
    
    public var chatSessionModel: CKChatSessionModel? {
        didSet {
            onRefetchFromServer(afterDelay: 0.001)
        }
    }
    
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
        chatMessageService = CKPrivateModelService<CKChatMessageModel>(container: CloudKitContainer.CloudContainer(container))
        chatSessionService = CKPrivateModelService<CKChatSessionModel>(container: CloudKitContainer.CloudContainer(container))
        activityService = CKPrivateModelService<CKActivityModel>(container: CloudKitContainer.CloudContainer(container))
    }
    
    private func updateChanges() {
        DispatchQueue.main.async {
            //self.didChange.send()
            self.objectWillChange.send()
        }
    }
    
    public func onStartUp() {
        if ChatService.familyChatSessionModel == nil {
            self.findOrMakeFamilySession { (result) in
                switch result {
                case .failure(let error):
                    print( "error \(error)")
                case .success(let sessionModel):
                    ChatService.familyChatSessionModel = sessionModel
                    self.onRefetchFromServer()
                }
            }
        } else {
            self.onRefetchFromServer()
        }
    }
    
    // TODO: make use of the ChatSessions ...
    public func sendMessage(_ chatMessageModel: CKChatMessageModel, sessionModel: CKChatSessionModel) {
        
        guard let chatMessage = chatMessageModel.message else {
            self.updateChanges()
            return
        }
        
        if chatMessage.isEmpty == true {
            self.updateChanges()
            return
        }
        
        chatMessages.insert(chatMessageModel, at: 0)
        chatMessageService.pushUpdateCreate(model: chatMessageModel) { (result) in
            switch result {
            case .failure(_):
                break
            case .success(let record):
                if let recordID = record.ckRecord?.recordID {
                    
                    let chatRecoredReference = CKRecord.Reference(recordID: recordID, action: .deleteSelf)
                    sessionModel.chatMessages.append(chatRecoredReference)
                    
                    self.chatSessionService.pushUpdateCreate(model: sessionModel) { (resultSession) in
                        switch resultSession {
                        case .failure(_):
                            break
                        case .success(_):
                            self.onRefetchFromServer(afterDelay:2)
                            break
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
            let newChatSession = CKChatSessionModel()
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
        } else {
            chatSessionService.fetchByName(name:"Family Chat") { fetchResult in
                switch fetchResult {
                case .success(let fetchResultModel):
                    completion(.success(fetchResultModel))
                case .failure(_):
                    let newChatSession = CKChatSessionModel()
                    newChatSession.name = "Family Chat"
                    self.chatSessionService.pushUpdateCreate(model: newChatSession) { (newChatSessionResult) in
                        switch newChatSessionResult {
                        case .failure(_):
                            completion(newChatSessionResult)
                        case .success(let resultSession):
                            ChatService.familyChatSessionModel = resultSession
                            completion(.success(resultSession))
                            self.onRefetchFromServer()
                        }
                    }
                }
            }//end fetchByName
        }
    }// end findOrMakeSession
}

// MARK: - StartupServices
extension ChatService {
    
    public func onRefetchFromServer( afterDelay: Double = 0.01) {
        
        guard let chatSessionModel = chatSessionModel else {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + afterDelay) {
            
            guard let chatSessionModelRecordID = chatSessionModel.recordID else {
                return
            }
            //let chatSessionReference = CKRecord.Reference(recordID: chatSessionModelRecordID, action: .none)
            // let searchPredicate = CKPrivateModelService<CKChatMessageModel>.SearchPredicate.predicateTrue
            
            let searchPredicate = SearchPredicate.customEqualsSearch(
                searchKey: "sessionReferenceID",
                searchValue: chatSessionModelRecordID.recordName
            )
            
            self.chatMessageService.fetch (
                sortDescriptor: .custom(key: "creationDate", ascending: false),
                searchPredicate: searchPredicate
                )
            { (result) in
                switch result {
                case .success( let models):
                    self.chatMessages = models
                    self.updateChanges()
                case .failure(_):
                    self.updateChanges()
                }
            }
        }
    }
    
    public func onDelete( model:CKChatMessageModel ) {
        self.chatMessageService.pushDelete(model: model) { (result) in
            switch result {
            case .failure(_):
                break
            case .success(_):
                self.onRefetchFromServer(afterDelay: 0.01)
            }
        }
    }
}

