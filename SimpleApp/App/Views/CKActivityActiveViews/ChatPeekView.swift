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
    
    @State var showChatSession: Bool = false
    var chatSessionModel: CKChatSessionModel
    var showInLine:Bool
    
    var body: some View {
        VStack {
            if showInLine == true {
                GeometryReader { geo in
                    ZStack {
                        Rectangle()
                            .fill(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
                            .frame(width: geo.size.width, height: geo.size.height)
                            //.border(SemanticAppColor.random)
                            .cornerRadius(5)
                            .onTapGesture {
                                self.showChatSession.toggle()
                        }
                        ChatSessionView(
                            chatSession: self.chatSessionModel,
                            showTextField: false
                        )
                            .frame(width: geo.size.width, height: geo.size.height)
                            .allowsHitTesting(false)
                    }
                }
            } else {
                GeometryReader { geo in
                    ZStack {
                        Rectangle()
                            .fill(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
                            .frame(width: geo.size.width, height: geo.size.height)
                            .cornerRadius(5)
                            .onTapGesture {
                                self.showChatSession.toggle()
                        }
                        VStack {
                            Text("Chats: \(self.chatSessionModel.chatMessages.count)")
                                .font(.system(size: 15, weight: .medium, design: .rounded))
                                .foregroundColor(Color.black)
                            if self.chatSessionModel.chatMessages.count > 0 {
                                ScrollView(.vertical, showsIndicators: false) {
                                    ForEach( self.chatSessionModel.chatMessages.prefix(3), id: \.self ) { messageRef in
                                        MessageRefView(messageRef: messageRef)
                                            .padding(.horizontal, 6)
                                            .padding(.bottom, 3)
                                    }
                                }
                            } else {
                                Text("No Messages, be the first!")
                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                                    .foregroundColor(Color.white)
                            }
                        }
                        .allowsHitTesting(false)
                    }
                }
            }//end else
        }
        .padding()
            .sheet(isPresented: $showChatSession) { // }, onDismiss: loadImage) {
                ChatSessionView(
                    chatSession: self.chatSessionModel,
                    showTextField: true
                )
                    .environmentObject(self.familyKitAppState)
        }
    }
    
}

struct MessageRefView: View {
    
    var messageRef: CKRecord.Reference
    
    var chatMessageService: CKPrivateModelService<CKChatMessageModel> = CKPrivateModelService<CKChatMessageModel>(container: CKContainer(identifier: CKContainerIdentifier))
    
    @State var model: CKChatMessageModel? = nil
    
    var body: some View {
        VStack {
            if model != nil {
                VStack {
                    HStack(alignment: .bottom, spacing: 15) {
                        Text("\(model!.ownerEmoji ?? "")")
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                        Text("\(model!.ownerName ?? "~"):")
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                        Spacer()
                    }
                    .padding(.leading, 5)
                    .padding(.trailing, 5)
                    .padding(.bottom, 5)
                    
                    HStack {
                        ChatContentMessageView(
                            contentMessage: model!.message ?? "~"
                        )
                        Spacer()
                    }
                }//end VStack
            } else {
                Text("...")
            }
        }.onAppear {
            self.loadMessage()
        }
    }
    
    func loadMessage() {
        chatMessageService.fetchByReference(modelReference: messageRef) { (result) in
            switch result {
            case .failure(_):
                break
            case .success(let model):
                self.model = model
            }
        }
    }
}
