//
//  ChatSessionView.swift
//  
//
//  Created by Matthew Schmulen on 8/1/20.
//

import SwiftUI
import CloudKit

public struct ChatSessionView: View {
//    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @ObservedObject private var keyboard = KeyboardResponder()
    
    @State private var chatService: ChatService = ChatService(container: CKContainer(identifier: CKContainerIdentifier))
    
    @State private var typingMessage: String = ""
    
    @State private var devMessage: String?
    
    @State private var messageCount: Int = 0
    private var chatSessionModel: CKChatSessionModel
    //var backgroundColor:Color? = Color(#colorLiteral(red: 0.8661809816, green: 1, blue: 1, alpha: 1))
    var backgroundColor:Color? = nil
    //var backgroundUIColor:UIColor? = UIColor(#colorLiteral(red: 0.8661809816, green: 1, blue: 1, alpha: 1))
    
    let showTextField: Bool
    let enableBorder:Bool
    let enableDismiss:Bool
    
    public init(
        chatSession: CKChatSessionModel,
        showTextField: Bool,
        enableBorder:Bool = true,
        enableDismiss:Bool = true
    ) {
        self.chatSessionModel = chatSession
        
        UITableView.appearance().separatorStyle = .none
        //UITableView.appearance().tableFooterView = UIView()
        //UITableViewCell.appearance().backgroundColor = backgroundUIColor ?? .white
        //UITableView.appearance().backgroundColor = backgroundUIColor ?? .white
        
        self.showTextField = showTextField
        self.enableDismiss = enableDismiss
        self.enableBorder = enableBorder
    }
    
    public var body: some View {
        //NavigationView {
        VStack{
            VStack {
                if devMessage != nil {
                    Text("\(devMessage!)")
                        .font(.caption)
                        .foregroundColor(.red)
                        .onTapGesture {
                            self.devMessage = nil
                    }
                }
                VStack {
                    HStack {
                        
                        Text("\(self.chatSessionModel.name ?? "~") (\(messageCount))")
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .padding()
                        
                        if enableDismiss {
                            Spacer()
                            Button(action: {
                                // todo
                                self.presentationMode.wrappedValue.dismiss()
                            }) {
                                Text("CLOSE")
                            }.padding()
                        }
                        
                    }
                    
                    List {
                        ForEach( self.chatService.chatMessages ) { model in
                            ChatMessageView(
                                currentMessage: model,
                                chatService: self.$chatService
                            ).flip()
                        }.listRowBackground(backgroundColor ?? .white)
                    }.flip()
                        .background(backgroundColor ?? .white)
                    
                    if showTextField == true {
                        HStack {
                            // TODO: Change to TextEditor(text: $typingMessage) for iOS14
                            TextField("Message...", text: $typingMessage)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(minHeight: CGFloat(30))
                            Button(action: sendMessage) {
                                Text("Send")
                            }
                        }.frame(minHeight: CGFloat(30)).padding()
                    }
                }
            }
            //.border(Color.blue, width: 2)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)), lineWidth: 3)
                )
            .padding(.bottom, keyboard.currentHeight)
            .background(backgroundColor ?? .white)
            .edgesIgnoringSafeArea(keyboard.currentHeight == 0.0 ? .leading: .bottom)
        }.onTapGesture {
            self.endEditing(true)
        }.onAppear {
            self.chatService.chatSessionModel = self.chatSessionModel
            self.chatService.onStartUp()
            self.messageCount = self.chatService.chatMessages.count
        }.onReceive(NotificationCenter.default.publisher(for: FamilyKitNotifications.CKRemoteModelChangedNotification)) { _ in
            //self.devMessage = "silent Push! DB changed"
            self.chatService.onRefetchFromServer()
        }
        .onReceive(self.chatService.$chatMessages) { (publisher) in
            self.messageCount = self.chatService.chatMessages.count
            //            self.devMessage = "\(self.messageCount) \(UUID().uuidString)"
        }
    }
    
    func sendMessage() {
        guard let chatSessionModelRecordID = chatSessionModel.recordID else {
            self.devMessage = "no chatSessionModel !"
            return
        }
        
        guard let currentPlayerRecord = familyKitAppState.currentPlayerModel?.ckRecord else {
            self.devMessage = "no current player"
            return
        }
        
        var newMessage = CKChatMessageModel()
        newMessage.message = typingMessage
        newMessage.ownerEmoji = familyKitAppState.currentPlayerModel?.emoji ?? "🌞"
        newMessage.ownerName = familyKitAppState.currentPlayerModel?.name ?? "none"
        newMessage.ownerReference = CKRecord.Reference(recordID: currentPlayerRecord.recordID, action: .deleteSelf)
        newMessage.sessionReferenceID = chatSessionModelRecordID.recordName
        chatService.sendMessage(newMessage, sessionModel: chatSessionModel)
        typingMessage = ""
    }
}

//struct ChatSessionView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatSessionView(chatService: .constant(ChatService(container: CKContainer(identifier: CKContainerIdentifier))))
//    }
//}


/**
 flip()
 View extension hack for bottom to top scrolling
 reference https://stackoverflow.com/questions/57258846/how-to-make-a-swiftui-list-scroll-automatically
 */
extension View {
    public func flip() -> some View {
        return self
            .rotationEffect(.radians(.pi))
            .scaleEffect(x: -1, y: 1, anchor: .center)
    }
}
