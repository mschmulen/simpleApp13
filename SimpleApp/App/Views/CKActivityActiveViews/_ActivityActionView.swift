//
//  ActivityActionView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/6/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit
import SimpleGames
import DrawingKit
import CloudKit

struct ActivityActionView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var privateActiveChoreService: CKPrivateModelService<CKActivityModel>
    @EnvironmentObject var chatService: ChatService
    
    @State var devMessage: String? = nil    
    
    @Binding var model: CKActivityModel
    
    var isReadOnly:Bool = false
    
    @State var isChatFocus = false
    
    var body: some View {
        VStack {
            
            VStack {
                if model.moduleType == .photo {
                    PhotoActivityView(
                        model: $model
                    )
                }
                
                if model.moduleType == .audio {
                    ActivityAudioActionView(
                        model: $model
                    )
                }
                
                if model.moduleType == .drawing {
                    DrawView(
                        model: $model,
                        isReadOnly: isReadOnly
                    )
                }
                
//                if model.moduleType == .chat {
//                    ChatSessionView() // model: $model
//                }
                
//                if isChatFocus == true {
//                    ChatEmbeddedScrollView(
//                        model:$model,
//                        isChatFocus: $isChatFocus
//                    )
//                    .frame(height: 500)
//                    Spacer()
//                } else {
//                    Spacer()
//                    ChatEmbeddedScrollView(
//                        model:$model,
//                        isChatFocus: $isChatFocus
//                    )
//                        .frame(height: 200)
//                }
                
                NavigationLink(destination: ChatSessionView()) {
                    Text("Show Chat")
                        .foregroundColor(.blue)
                }
                
            }
        }
    }
}


struct ActivityActionView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityActionView(
            model: .constant(CKActivityModel.mock)
        )
    }
}

//struct ChatEmbeddedScrollView: View {
//
//    @EnvironmentObject var familyKitAppState: FamilyKitAppState
//    @EnvironmentObject var chatService: ChatService
//
//    @State var typingMessage: String = ""
//
//    @State var devMessage: String? = nil
//
//    @Binding var model: CKActivityModel
//    @Binding var isChatFocus: Bool
//
//    @ObservedObject private var keyboard = KeyboardResponder()
//
//    public init(
//        model: Binding<CKActivityModel>,
//        isChatFocus: Binding<Bool>
//    ) {
//        self._model = model
//        self._isChatFocus = isChatFocus
//
//        UITableView.appearance().separatorStyle = .none
//        UITableView.appearance().tableFooterView = UIView()
//    }
//
//    public var body: some View {
//        ScrollView(.vertical, showsIndicators: true) {
//            VStack {
//                if devMessage != nil {
//                    Text("\(devMessage!)")
//                        .foregroundColor(.red)
//                        .onTapGesture {
//                            self.devMessage = nil
//                    }
//                }
//                List {
//                    ForEach( self.chatService.chatMessageService.models ) { model in
//                        MessageView(currentMessage: model)
//                    }
//                }
//                HStack {
//                    TextField("Message...", text: $typingMessage)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                        .frame(minHeight: CGFloat(30))
//                    Button(action: sendMessage) {
//                        Text("Send")
//                    }
//                }.frame(minHeight: CGFloat(50)).padding()
//            }// end ScrollView
//            .background(Rectangle().fill(Color.blue))
//            .padding(.bottom, keyboard.currentHeight)
//            .edgesIgnoringSafeArea(keyboard.currentHeight == 0.0 ? .leading: .bottom)
//        }.onTapGesture {
//            self.isChatFocus.toggle()
//            self.endEditing(true)
//        }.onAppear {
//            self.chatService.onRefresh()
//        }.onReceive(NotificationCenter.default.publisher(for: FamilyKitNotifications.CKChangedNotification)) { _ in
//            print("Notification.Name(CloudKitModelService) recieved")
//            self.devMessage = "silent Push! DB changed"
//            self.chatService.onRefresh()
//        }
//    }
//
//    func sendMessage() {
//        var newMessage = CKChatMessageModel()
//        newMessage.message = typingMessage
//        newMessage.ownerEmoji = familyKitAppState.currentPlayer.emoji
//        newMessage.ownerName = familyKitAppState.currentPlayer.name
//        newMessage.ownerReference = familyKitAppState.currentPlayer.recordReference
//        chatService.sendMessage(newMessage)
//        typingMessage = ""
//    }
//
//}
//
//final class KeyboardResponder: ObservableObject {
//
//       private var notificationCenter: NotificationCenter
//       @Published private(set) var currentHeight: CGFloat = 0
//
//       init(center: NotificationCenter = .default) {
//           notificationCenter = center
//           notificationCenter.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//           notificationCenter.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//       }
//
//       deinit {
//           notificationCenter.removeObserver(self)
//       }
//
//       @objc func keyBoardWillShow(notification: Notification) {
//           if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//               currentHeight = keyboardSize.height
//           }
//       }
//
//       @objc func keyBoardWillHide(notification: Notification) {
//           currentHeight = 0
//       }
//   }
//
//   extension View {
//       func endEditing(_ force: Bool) {
//           UIApplication.shared.windows.forEach { $0.endEditing(force)}
//       }
//   }
