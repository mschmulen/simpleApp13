//
//  ChatsView.swift
//  
//
//  Created by Matthew Schmulen on 8/2/20.
//

import SwiftUI
import CloudKit

public struct ChatsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var chatService: ChatService
    
    @State var errorMessage: String?
    
    @State var chatSessions: [UUID] = [UUID]()
    
    public init(chatService: Binding<ChatService>) {
        self._chatService = chatService
        
        //        UITableView.appearance().separatorStyle = .none
        //        UITableView.appearance().tableFooterView = UIView()
    }
    
    public var body: some View {
            VStack {
                Button(action: {
                    self.chatSessions.append(UUID())
                }) {
                    Text("NEW CHAT")
                }
                
                List {
                    Section(header: Text("Sessions")) {
                        ForEach(self.chatSessions, id: \.self) { session in
                            NavigationLink(destination: ChatSessionView(chatService: self.$chatService)) {
                                HStack {
                                    Text("\(session)")
                                }
                            }
                        }
                    }
                }
                
                //                List {
                //                    Section(header: Text("kids")) {
                //                        ForEach(self.familyKitAppState.kidService.models) { model in
                //                            NavigationLink(destination: ChatView()) {
                //                                HStack {
                //                                    Text("\(model.emoji ?? "~")")
                //                                    Text("\(model.name ?? "~")")
                //                                }
                //
                //                            }
                //                        }
                //                    }
                //
                //                    Section(header: Text("adults")) {
                //                        ForEach(self.familyKitAppState.adultService.models) { model in
                //                            NavigationLink(destination: ChatView()) {
                //                                HStack {
                //                                    Text("\(model.emoji ?? "~")")
                //                                    Text("\(model.name ?? "~")")
                //                                }
                //
                //                            }
                //                        }
                //                    }//end Section
                //                }//end List
                //            }.navigationBarTitle(Text("\(DataSource.firstUser.emoji) \(DataSource.firstUser.name)"), displayMode: .inline)
            }
        }    
}

struct ChatsView_Previews: PreviewProvider {
    static var previews: some View {
        ChatsView(chatService: .constant(ChatService(container: CKContainer(identifier: CKContainerIdentifier))))
    }
}

