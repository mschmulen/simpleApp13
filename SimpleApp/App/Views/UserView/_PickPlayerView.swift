//
//  LoginView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 7/19/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

//import SwiftUI
//
//struct PickPlayerView: View {
//    
//    @Environment(\.window) var window: UIWindow?
//    @Environment(\.presentationMode) var presentationMode
//    
//    @EnvironmentObject var appState: AppState
//    
//    @State var errorMessage: String?
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                
//                Text("Pick Player")
//                
//                Spacer()
//                
//                if errorMessage != nil {
//                    Text(errorMessage!)
//                        .foregroundColor(.red)
//                    Spacer()
//                }
//                
//                
//                // TODO Clean up
////                List {
////                    ForEach(self.appState.userStore.models) { model in
////                        Button(action: {
////                            self.appState.signIn(user: model)
////                            self.appState.topView = .mainView
////                            self.presentationMode.wrappedValue.dismiss()
////                        }) {
////                            Text("\(model.name)")
////                        }
////                    }
////                }
//            }
//            .navigationBarItems(trailing: addButton)
//        }//end Navigation
//    }//end body
//    
//    private var addButton: some View {
//        NavigationLink(destination: NewPlayerView() ) {
//            Image(systemName: "plus")
//        }
//    }
//}
//
//struct PickPlayerView_Previews: PreviewProvider {
//    static var previews: some View {
//        PickPlayerView()
//    }
//}
