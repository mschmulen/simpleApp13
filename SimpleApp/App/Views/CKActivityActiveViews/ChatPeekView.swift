//
//  ChatPeekView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/26/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit
import CloudKit

struct ChatPeekView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    let rectangleColor: Color = Color.white
    // Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
    
    @State var showChatSession: Bool = false
    var chatSessionModel: CKChatSessionModel
    
    var body: some View {
        VStack {
            GeometryReader { geo in
                ZStack {
                    Rectangle()
                        .fill(self.rectangleColor)
                        .frame(width: geo.size.width, height: geo.size.height)
                        //.cornerRadius(5)
                        .onTapGesture {
                            self.showChatSession.toggle()
                    }
                    ChatSessionView(
                        chatSession: self.chatSessionModel,
                        showTextField: false,
                        enableDismiss: false
                    )
                        .frame(width: geo.size.width, height: geo.size.height)
                        .allowsHitTesting(false)
                }
            }
        }
        .padding()
            .sheet(isPresented: $showChatSession, onDismiss: onDismissReload) {
                ChatSessionView(
                    chatSession: self.chatSessionModel,
                    showTextField: true,
                    enableDismiss: true,
                    dismissCallback: {
                        self.onDismissReload()
                    },
                    enableBorder: false
                )
                    .environmentObject(self.familyKitAppState)
        }
    }
    
    func onDismissReload() {
        // TODO: Reload on Dismiss
    }
    
}
