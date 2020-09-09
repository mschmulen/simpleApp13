//
//  ChatSessionView.swift
//  
//
//  Created by Matthew Schmulen on 8/1/20.
//

import SwiftUI
import CloudKit

public struct ChatSessionView: View {
    //    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @ObservedObject private var keyboard = KeyboardResponder()
    
    @State private var chatService: ChatService = ChatService(container: CKContainer(identifier: CKContainerIdentifier))
    
    @State private var typingMessage: String = ""
    
    @State private var devMessage: String?
    
    @State private var messageCount: Int = 0
    private var chatSessionModel: CKChatSessionModel
    
    let showTextField: Bool
    let enableBorder: Bool
    let enableDismiss: Bool
    let dismissCallback: (()->Void)?
    
    @State private var showPhotoUpload: Bool = false
    @State private var showAudioUpload: Bool = false
    @State private var showAdditionalOptions: Bool = false
    
    public init(
        chatSession: CKChatSessionModel,
        showTextField: Bool,
        enableDismiss:Bool = true,
        dismissCallback: (()->Void)? = nil,
        enableBorder:Bool = true
    ) {
        self.chatSessionModel = chatSession
        
        UITableView.appearance().separatorStyle = .none
        //UITableView.appearance().tableFooterView = UIView()
        //UITableViewCell.appearance().backgroundColor = backgroundUIColor ?? .white
        //UITableView.appearance().backgroundColor = backgroundUIColor ?? .white
        
        self.showTextField = showTextField
        self.enableBorder = enableBorder
        
        self.enableDismiss = enableDismiss
        self.dismissCallback = dismissCallback
    }
    
    public var body: some View {
        //NavigationView {
        VStack{
            VStack {
                if devMessage != nil {
                    Text("\(devMessage!)")
                        .font(.caption)
                        .foregroundColor(.red)
                        .onTapGesture {
                            self.devMessage = nil
                    }
                }
                VStack {
                    HStack {
                        
                        Text("Messages: (\(messageCount))")
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .padding()
                        
                        if enableDismiss {
                            Spacer()
                            Button(action: {
                                self.dismissCallback?()
                                self.presentationMode.wrappedValue.dismiss()
                            }) {
                                Text("CLOSE")
                            }.padding()
                        }
                    }
                    
                    List {
                        ForEach( self.chatService.chatMessages ) { model in
                            ChatMessageView(
                                currentMessage: model,
                                chatService: self.$chatService
                            ).flip()
                        }
                    }.flip()
                    
                    if showTextField == true {
                        HStack {
                            if typingMessage.isEmpty {
                                Button(action: showAdditional) {
                                    Image(systemName: "plus")
                                }.sheet(isPresented: $showAdditionalOptions) {
                                    ChatUploadAdditionalView()
                                }.padding(2.0)
                            }
                            
                            // TODO: Change to TextEditor(text: $typingMessage) for iOS14
                            TextField("Message...", text: $typingMessage)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(minHeight: CGFloat(30))
                            if typingMessage.isEmpty {
                                Button(action: showPhoto) {
                                    Image(systemName: "photo")
                                }
                                .padding(2.0)
                                .sheet(isPresented: $showPhotoUpload) {
                                    ChatUploadPhotoView()
                                }
                                Button(action: showAudio) {
                                    Image(systemName: "mic")
                                }
                                .padding(2.0)
                                .sheet(isPresented: $showAudioUpload) {
                                    ChatUploadAudioView()
                                }
                            } else {
                                Button(action: sendMessage) {
                                    Image(systemName: "paperplane.fill")
                                }
                            }
                        }.frame(minHeight: CGFloat(30)).padding()
                    }
                }
            }
            .if(enableBorder) { $0.overlay( RoundedRectangle(cornerRadius: 16).stroke(Color(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)), lineWidth: 3)) }
            .padding(.bottom, keyboard.currentHeight)
            .edgesIgnoringSafeArea(keyboard.currentHeight == 0.0 ? .leading: .bottom)
        }.onTapGesture {
            self.endEditing(true)
        }.onAppear {
            self.chatService.chatSessionModel = self.chatSessionModel
            self.chatService.onStartUp()
            self.messageCount = self.chatService.chatMessages.count
        }.onReceive(NotificationCenter.default.publisher(for: FamilyKitNotifications.CKRemoteModelChangedNotification)) { _ in
            self.devMessage = "silent Push! DB changed"
            self.chatService.onRefetchFromServer()
        }
        .onReceive(self.chatService.$chatMessages) { (publisher) in
            self.messageCount = self.chatService.chatMessages.count
            //            self.devMessage = "\(self.messageCount) \(UUID().uuidString)"
        }
    }
    
    func showAudio() {
        showAudioUpload.toggle()
    }
    
    func showPhoto() {
        print( "sendPhoto")
        showPhotoUpload.toggle()
    }
    
    func showAdditional() {
        print( "additionalOptions")
        showAdditionalOptions.toggle()
    }
    
    func sendMessage() {
        guard let chatSessionModelRecordID = chatSessionModel.recordID else {
            self.devMessage = "no chatSessionModel !"
            return
        }
        
        guard let currentPlayerRecord = familyKitAppState.currentPlayerModel?.ckRecord else {
            self.devMessage = "no current player"
            return
        }
        
        var newMessage = CKChatMessageModel()
        newMessage.message = typingMessage
        newMessage.ownerEmoji = familyKitAppState.currentPlayerModel?.emoji ?? "🌞"
        newMessage.ownerName = familyKitAppState.currentPlayerModel?.name ?? "none"
        newMessage.ownerReference = CKRecord.Reference(recordID: currentPlayerRecord.recordID, action: .deleteSelf)
        newMessage.sessionReferenceID = chatSessionModelRecordID.recordName
        chatService.sendMessage(newMessage, sessionModel: chatSessionModel)
        typingMessage = ""
    }
}


/**
 flip()
 View extension hack for bottom to top scrolling
 reference https://stackoverflow.com/questions/57258846/how-to-make-a-swiftui-list-scroll-automatically
 */
extension View {
    public func flip() -> some View {
        return self
            .rotationEffect(.radians(.pi))
            .scaleEffect(x: -1, y: 1, anchor: .center)
    }
}



/**
 // https://fivestars.blog/swiftui/conditional-modifiers.html
 // Conditional modifiers
 */

extension View {
    @ViewBuilder
    func `if`<Transform: View>(
        _ condition: Bool,
        transform: (Self) -> Transform
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

//extension View {
//  @ViewBuilder
//  func `if`<TrueContent: View, FalseContent: View>(
//    _ condition: Bool,
//    if ifTransform: (Self) -> TrueContent,
//    else elseTransform: (Self) -> FalseContent
//  ) -> some View {
//    if condition {
//      ifTransform(self)
//    } else {
//      elseTransform(self)
//    }
//  }
//}
//
//extension View {
//  @ViewBuilder
//  func ifLet<V, Transform: View>(
//    _ value: V?,
//    transform: (Self, V) -> Transform
//  ) -> some View {
//    if let value = value {
//      transform(self, value)
//    } else {
//      self
//    }
//  }
//}
