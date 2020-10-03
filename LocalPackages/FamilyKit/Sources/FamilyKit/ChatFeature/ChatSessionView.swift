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
    
    @State var messageIdToScrollToo: UUID?
    
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

                    ScrollView {
                        ScrollViewReader { (scrollProxy) in
                            LazyVStack {
                                ForEach( self.chatService.chatMessages.reversed() ) { model in
                                    ChatMessageView(
                                        currentMessage: model,
                                        chatService: self.$chatService
                                    )
                                    .id(model.id)
                                }
//                                .onAppear {
//                                    print("appear")
//                                    scrollProxy.scrollTo(self.chatService.chatMessages.count - 1, anchor: .center)
//                                }
                            }
                            //.onChange(of: self.messageCount) { target in
                            .onChange(of: self.messageIdToScrollToo ) { id in
                                guard id != nil else { return }
                                print( "messageIdToSetVisible \(id)")
                                print( "self.chatService.chatMessages.count: \(self.chatService.chatMessages.count)")
                                withAnimation {
                                    //scrollProxy.scrollTo(self.chatService.chatMessages.count, anchor: .center)
                                    scrollProxy.scrollTo(id)
                                }
                            }
                        }//end ScrollView
                        //                            .onChange(of: self.chatService.chatMessages) { target in
                        //                                print( "change")
                        //                                //withAnimation {
                        //                                proxy.scrollTo(self.chatService.chatMessages.count - 1, anchor: .center)
                        //                                //}
                        //                            }
                        
                        .padding()
                    }//end ScrollViewReader
                    
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
//                            TextField("Message...", text: $typingMessage)
//                                .textFieldStyle(RoundedBorderTextFieldStyle())
//                                .frame(minHeight: CGFloat(30))
                            
                            
                            //GeometryReader { geo in
                                ZStack {
//                                    Rectangle()
//                                        .fill(Color.gray)
//                                        .frame(width: geo.size.width, height: geo.size.height)
//                                        .border(Color.gray)
                                    
                                    if typingMessage.isEmpty {
                                        Text("New Message ...")
                                        // .padding(.all)
                                    }
                                    
                                    TextEditor(text: $typingMessage)
                                        .foregroundColor(.black)
                                        .opacity(typingMessage.isEmpty ? 0.5 : 1)
                                        //.frame(minHeight: CGFloat(30))
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 30, maxHeight: 30)
                                        .padding(1)
                                        //.border(Color.purple, width: 2)// , cornerRadius: 20)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 5)
                                                .stroke(Color.blue, lineWidth: 2)
                                        )
                                }
//                            }//end Geo
                            
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
            //self.devMessage = "silent Push! DB changed"
            self.chatService.onRefetchFromServer()
        }
        .onReceive(self.chatService.$chatMessages) { (publisher) in
            self.messageCount = self.chatService.chatMessages.count
            
            if let lastMessage = self.chatService.chatMessages.first {
                print( "scroll to message ID \(lastMessage.id.uuidString)" )
                print( "message: \(lastMessage.message)")
                self.messageIdToScrollToo = lastMessage.id
            }
            
            // self.devMessage = "\(self.messageCount) \(UUID().uuidString)"
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
//extension View {
//    public func flip() -> some View {
//        return self
//            .rotationEffect(.radians(.pi))
//            .scaleEffect(x: -1, y: 1, anchor: .center)
//    }
//}



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



struct ChatSessionView_Previews: PreviewProvider {
    static var previews: some View {
        ChatSessionView(
            chatSession: CKChatSessionModel.mock,
            showTextField: true)
    }
}



/*
 // TODO Custom TextField
struct CustomTextField: View {
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }

    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty { placeholder }
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
        }
    }
}

// usage (TextField with placeholder):

struct ContentView: View {
    @State var text = ""

    var body: some View {
        CustomTextField(
            placeholder: Text("placeholder").foregroundColor(.red),
            text: $text
        )
    }
}

*/
