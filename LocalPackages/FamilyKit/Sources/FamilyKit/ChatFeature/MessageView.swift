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
        HStack(alignment: .bottom, spacing: 15) {
            if currentMessage.ownerReference == familyKitAppState.currentPlayer.recordReference {
                Spacer()
            } else {
                Text("\(currentMessage.ownerEmoji ?? "")\(currentMessage.ownerName ?? "~"):")
                    .font(.body)
            }
            //            if !currentMessage.user.isCurrentUser {
            //                Text(currentMessage.ownerEmoji)
            //                    .font(.largeTitle)
            //                //Image(systemName: "person")
            //                //Image(currentMessage.user.avatar)
            //                //.resizable()
            //                //.frame(width: 40, height: 40, alignment: .center)
            //                .cornerRadius(20)
            //            } else {
            //                Spacer()
            //            }
            ChatContentMessageView(contentMessage: currentMessage.message ?? "~",
                               isCurrentUser: false)
        }.padding()
    }
}

//struct MessageView_Previews: PreviewProvider {
//    static var previews: some View {
//        MessageView(currentMessage: ChatMessage(content: "There are a lot of premium iOS templates on iosapptemplates.com", user: DataSource.secondUser))
//    }
//}
