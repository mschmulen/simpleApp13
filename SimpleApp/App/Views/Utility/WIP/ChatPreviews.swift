//
//  ChatPreviews.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/21/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView(
            currentMessage: CKChatMessageModel.mock
        )
    }
}


//struct ContentMessageView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatContentMessageView(contentMessage: "Hi, how are you doing", isCurrentUser: false)
//    }
//}

