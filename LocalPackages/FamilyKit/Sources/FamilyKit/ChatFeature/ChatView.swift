//
//  ChatView.swift
//  
//
//  Created by Matthew Schmulen on 8/1/20.
//

import SwiftUI

public struct ChatView: View {
    
    @State var typingMessage: String = ""
    
    @State var chatService = ChatService()
    //@EnvironmentObject var chatHelper: ChatHelper
    
    @ObservedObject private var keyboard = KeyboardResponder()
    
    public init() {
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().tableFooterView = UIView()
    }
    
    public var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(chatService.realTimeMessages, id: \.self) { msg in
                        MessageView(currentMessage: msg)
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
            }.navigationBarTitle(Text("\(DataSource.firstUser.emoji) \(DataSource.firstUser.name)"), displayMode: .inline)
            .padding(.bottom, keyboard.currentHeight)
            .edgesIgnoringSafeArea(keyboard.currentHeight == 0.0 ? .leading: .bottom)
        }.onTapGesture {
                self.endEditing(true)
        }
    }
    
    func sendMessage() {
        chatService.sendMessage(ChatMessage(content: typingMessage, user: DataSource.secondUser))
        typingMessage = ""
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}

