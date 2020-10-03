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
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    let rectangleColor: Color = Color.white
    
    @State var chatService: ChatService = ChatService( container: CKContainer(identifier: CKContainerIdentifier) )
    
    @State var showChatSession: Bool = false
    @State var chatSessionModel: CKChatSessionModel
    
    let updateCallback: (()->Void)
    
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
            .sheet(isPresented: $showChatSession, onDismiss: onSheetDismiss) {
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
    
    func onSheetDismiss() {
        print( "onSheetDismiss")
        updateCallback()
    }
    
    func onDismissReload() {
        print( "onDismissReload")
        updateCallback()
    }
    
}
