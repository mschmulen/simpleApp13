//
//  ChatContentMessageView.swift
//  
//
//  Created by Matthew Schmulen on 8/1/20.
//

import SwiftUI

struct ChatContentMessageView: View {
    var contentMessage: String
    var isCurrentUser: Bool
    
    var body: some View {
        Text(contentMessage)
            .font(.system(size: 12, weight: .medium, design: .rounded))
            .lineLimit(nil)
            .padding(10)
            .foregroundColor(isCurrentUser ? Color.white : Color.black)
            .background(isCurrentUser ? Color.blue : Color(UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)))
            .cornerRadius(10)
    }
}

struct ContentMessageView_Previews: PreviewProvider {
    static var previews: some View {
        ChatContentMessageView(contentMessage: "Hi, how are you doing", isCurrentUser: false)
    }
}
