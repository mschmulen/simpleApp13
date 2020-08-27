//
//  ChatMessageView.swift
//  
//
//  Created by Matthew Schmulen on 8/1/20.
//

import SwiftUI

public struct ChatMessageView : View {
    
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    var currentMessage: CKChatMessageModel
    @Binding var chatService: ChatService
    
    public init(
        currentMessage: CKChatMessageModel,
        chatService: Binding<ChatService>
    ){
        self.currentMessage = currentMessage
        self._chatService = chatService
    }
    
    public var body: some View {
        VStack {
            HStack(alignment: .bottom, spacing: 15) {
                if currentMessage.ownerReference == familyKitAppState.currentPlayerModel?.recordReference {
                    Spacer()
                    Text("\(currentMessage.ownerEmoji ?? "")")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                    Text("\(currentMessage.ownerName ?? "~")")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                } else {
                    Text("\(currentMessage.ownerEmoji ?? "")")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                    Text("\(currentMessage.ownerName ?? "~"):")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                    Spacer()
                }
            }
            .padding(.leading, 5)
            .padding(.trailing, 5)
            HStack {
                if currentMessage.ownerReference == familyKitAppState.currentPlayerModel?.recordReference {
                    Spacer()
                    ChatContentMessageView(
                        contentMessage: currentMessage.message ?? "~"
                    )
                } else {
                    ChatContentMessageView(
                        contentMessage: currentMessage.message ?? "~"
                    )
                    Spacer()
                }
            }
        }//end VStack
            .contextMenu {
                if currentMessage.ownerReference == familyKitAppState.currentPlayerModel?.recordReference {
                    Button(action: {
                        self.chatService.onDelete(model: self.currentMessage)
                    }) {
                        Text("Delete")
                        Image(systemName: "trash")
                    }
                } else {
                    VStack {
                    Button(action: {
                        print("todo Like")
                    }) {
                        Text("Like")
                        Image(systemName: "trash")
                    }
                    
                    Button(action: {
                        print("todo Like")
                    }) {
                        Text("No Like")
                        Image(systemName: "trash")
                    }
                    }
                }
        }
    }
    
}

//struct ChatMessageView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatMessageView(currentMessage: ChatMessage(content: "There are a lot of premium iOS templates on iosapptemplates.com", user: DataSource.secondUser))
//    }
//}
