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
    @EnvironmentObject var chatService: ChatService
    
//    @Binding var model: CKActivityModel
//    @State var chatSession: CKChatSessionModel
    
    @State var typingMessage: String = ""
    
    @State var devMessage: String?
    
    @ObservedObject private var keyboard = KeyboardResponder()
    
    public init() { //chatSessions: Binding<CKChatSessionModel>) {
//        self._model = model
//        self._chatService = chatService
        
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().tableFooterView = UIView()
    }
    
    public var body: some View {
        NavigationView {
            VStack {
                if devMessage != nil {
                    Text("\(devMessage!)")
                        .foregroundColor(.red)
                        .onTapGesture {
                            self.devMessage = nil
                    }
                }
                List {
                    ForEach( self.chatService.chatMessageService.models ) { model in
                        MessageView(currentMessage: model)
                    }
                }
                HStack {
                    TextField("Message...", text: $typingMessage)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(minHeight: CGFloat(30))
                    Button(action: sendMessage) {
                        Text("Send")
                    }
                }.frame(minHeight: CGFloat(50)).padding()
            }//.navigationBarTitle(Text("\(DataSource.firstUser.emoji) \(DataSource.firstUser.name)"), displayMode: .inline)
            .padding(.bottom, keyboard.currentHeight)
            .edgesIgnoringSafeArea(keyboard.currentHeight == 0.0 ? .leading: .bottom)
        }.onTapGesture {
                self.endEditing(true)
        }.onAppear {
            self.chatService.onRefresh()
        }.onReceive(NotificationCenter.default.publisher(for: FamilyKitNotifications.CKChangedNotification)) { _ in
            print("Notification.Name(CloudKitModelService) recieved")
            self.devMessage = "silent Push! DB changed"
            self.chatService.onRefresh()
        }
    }
    
    func sendMessage() {
        var newMessage = CKChatMessageModel()
        newMessage.message = typingMessage
        newMessage.ownerEmoji = familyKitAppState.currentPlayer.emoji
        newMessage.ownerName = familyKitAppState.currentPlayer.name
        newMessage.ownerReference = familyKitAppState.currentPlayer.recordReference
        chatService.sendMessage(newMessage)
        typingMessage = ""
    }
}

//struct ChatSessionView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatSessionView(chatService: .constant(ChatService(container: CKContainer(identifier: CKContainerIdentifier))))
//    }
//}

