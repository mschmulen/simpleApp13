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
    
    @State var errorMessage: String?
    
    @State var chatSessions: [UUID] = [UUID]()
    
    public init() {
        // UITableView.appearance().separatorStyle = .none
        // UITableView.appearance().tableFooterView = UIView()
    }
    
    public var body: some View {
            VStack {
                Button(action: {
                    self.chatSessions.append(UUID())
                }) {
                    Text("NEW CHAT")
                }
                
                // TODO: Fix this 
//                List {
//                    Section(header: Text("Sessions")) {
//                        ForEach(self.chatSessions, id: \.self) { session in
//                            NavigationLink(destination: ChatSessionView()) {
//                                HStack {
//                                    Text("\(session)")
//                                }
//                            }
//                        }
//                    }
//                }
                //            }.navigationBarTitle(Text("\(DataSource.firstUser.emoji) \(DataSource.firstUser.name)"), displayMode: .inline)
            }
        }    
}

struct ChatsView_Previews: PreviewProvider {
    static var previews: some View {
        ChatsView()//chatService: .constant(ChatService(container: CKContainer(identifier: CKContainerIdentifier))))
    }
}

