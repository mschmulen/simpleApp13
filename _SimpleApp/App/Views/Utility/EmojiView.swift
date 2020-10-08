//
//  EmojiView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/2/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct EmojiPicker: View {
    
    @Binding var emoji:String // = "😀"
    
    var body: some View {
        ScrollView{
            Text("yack")
        }
    }
}

struct EmojiView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiPicker(emoji: .constant("😀"))
    }
}
