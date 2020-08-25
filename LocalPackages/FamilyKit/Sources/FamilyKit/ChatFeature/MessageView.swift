//
//  File.swift
//  
//
//  Created by Matthew Schmulen on 8/1/20.
//

import SwiftUI

public struct MessageView : View {
    
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    var currentMessage: CKChatMessageModel
    
    public init( currentMessage: CKChatMessageModel ){
        self.currentMessage = currentMessage
    }
    
    public var body: some View {
        VStack {
            HStack(alignment: .bottom, spacing: 15) {
                if currentMessage.ownerReference == familyKitAppState.currentPlayer.recordReference {
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
                if currentMessage.ownerReference == familyKitAppState.currentPlayer.recordReference {
                    Spacer()
                    ChatContentMessageView(
                        contentMessage: currentMessage.message ?? "~",
                        isCurrentUser: false
                    )
                } else {
                    ChatContentMessageView(
                        contentMessage: currentMessage.message ?? "~",
                        isCurrentUser: false
                    )
                    Spacer()
                }
            }
        }//end VStack
            
            .contextMenu {
                
                if currentMessage.ownerReference == familyKitAppState.currentPlayer.recordReference {
                    Button(action: {
                        // TODO: fix the delete
//                        self.chatService.chatMessageService.pushDelete(model: self.currentMessage) { (result) in
//                            print("delete result \(result)")
//                        }
                        print("todo delete")
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
        //.border(Color.gray)
        //.padding()
    }
    
}

//struct MessageView_Previews: PreviewProvider {
//    static var previews: some View {
//        MessageView(currentMessage: ChatMessage(content: "There are a lot of premium iOS templates on iosapptemplates.com", user: DataSource.secondUser))
//    }
//}
