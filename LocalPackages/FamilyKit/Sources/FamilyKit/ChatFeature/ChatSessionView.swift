//
//  ChatSessionView.swift
//  
//
//  Created by Matthew Schmulen on 8/1/20.
//

import SwiftUI
import CloudKit

public struct ChatSessionView: View {
    
    @EnvironmentObject var familyKitAppState: FamilyKitAppState

    @ObservedObject private var keyboard = KeyboardResponder()
    
    @State private var chatService: ChatService = ChatService(container: CKContainer(identifier: CKContainerIdentifier))
    
    @State private var typingMessage: String = ""
    
    @State private var devMessage: String?
    
    private var chatSessionModel: CKChatSessionModel
    
    public init( chatSession: CKChatSessionModel ) {
        self.chatSessionModel = chatSession
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().tableFooterView = UIView()
    }
    
    public var headerView: some View {
        VStack {
            //Text("\(self.chatSessionModel.recordID?.recordName ?? "~")")
                //.font(.caption)
            Text("# \(self.chatService.chatMessages.count)")
        }
    }
    
    public var body: some View {
        NavigationView {
            VStack {
                if devMessage != nil {
                    Text("\(devMessage!)")
                        .font(.caption)
                        .foregroundColor(.red)
                        .onTapGesture {
                            self.devMessage = nil
                    }
                }
                headerView
                List {
                    ForEach( self.chatService.chatMessages ) { model in
                        ChatMessageView(
                            currentMessage: model,
                            chatService: self.$chatService
                        )
                            .flip()
                    }
                }.flip()
                HStack {
                    TextField("Message...", text: $typingMessage)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(minHeight: CGFloat(30))
                    Button(action: sendMessage) {
                        Text("Send")
                    }
                }.frame(minHeight: CGFloat(50)).padding()
            }//.navigationBarTitle(Text("\(DataSource.firstUser.emoji) \(DataSource.firstUser.name)"), displayMode: .inline)
                .navigationBarTitle("\(chatSessionModel.title ?? "~")")
                //.navigationBarItems(trailing: Text("\(model.status.friendlyName)"))
                
            .padding(.bottom, keyboard.currentHeight)
            .edgesIgnoringSafeArea(keyboard.currentHeight == 0.0 ? .leading: .bottom)
        }.onTapGesture {
                self.endEditing(true)
        }.onAppear {
            self.chatService.chatSessionModel = self.chatSessionModel
            self.chatService.onStartUp()
        }.onReceive(NotificationCenter.default.publisher(for: FamilyKitNotifications.CKRemoteModelChangedNotification)) { _ in
            self.devMessage = "silent Push! DB changed"
            self.chatService.onRefetchFromServer()
        }
        .onReceive(self.chatService.$chatMessages) { (publisher) in
            self.devMessage = "\(UUID().uuidString)"
            print("\(UUID().uuidString)")
        }
    }
    
    func sendMessage() {
        guard let chatSessionModelRecordID = chatSessionModel.recordID else {
            print( "early out on no chatSessionModel !!! ")
            return
        }

        var newMessage = CKChatMessageModel()
        newMessage.message = typingMessage
        newMessage.ownerEmoji = familyKitAppState.currentPlayerModel?.emoji ?? "🌞"
        newMessage.ownerName = familyKitAppState.currentPlayerModel?.name ?? "none"
        newMessage.ownerReference = familyKitAppState.currentPlayer.recordReference
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


// reference https://stackoverflow.com/questions/57258846/how-to-make-a-swiftui-list-scroll-automatically

extension View {
    public func flip() -> some View {
        return self
            .rotationEffect(.radians(.pi))
            .scaleEffect(x: -1, y: 1, anchor: .center)
    }
}
