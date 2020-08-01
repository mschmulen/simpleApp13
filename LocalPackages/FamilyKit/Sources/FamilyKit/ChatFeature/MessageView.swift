//
//  File.swift
//  
//
//  Created by Matthew Schmulen on 8/1/20.
//

import SwiftUI

struct MessageView : View {
    var currentMessage: ChatMessage
    var body: some View {
        HStack(alignment: .bottom, spacing: 15) {
            if !currentMessage.user.isCurrentUser {
                Text(currentMessage.user.emoji)
                    .font(.largeTitle)
                //Image(systemName: "person")
                //Image(currentMessage.user.avatar)
                //.resizable()
                //.frame(width: 40, height: 40, alignment: .center)
                .cornerRadius(20)
            } else {
                Spacer()
            }
            ContentMessageView(contentMessage: currentMessage.content,
                               isCurrentUser: currentMessage.user.isCurrentUser)
        }.padding()
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView(currentMessage: ChatMessage(content: "There are a lot of premium iOS templates on iosapptemplates.com", user: DataSource.secondUser))
    }
}
