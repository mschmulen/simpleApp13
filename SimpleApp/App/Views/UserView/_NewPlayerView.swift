//
//  NewPlayerView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 7/28/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

//import SwiftUI
//
//struct NewPlayerView: View {
//
//    @Environment(\.window) var window: UIWindow?
//    @Environment(\.presentationMode) var presentationMode
//
//    @EnvironmentObject var appState: AppState
//
//    @State var errorMessage: String?
//
//    @State var newPlayerName:String = ""
//
//    var body: some View {
//
//        VStack {
//            Text("New Player")
//
//            if errorMessage != nil {
//                Text(errorMessage!)
//                    .foregroundColor(.red)
//            }
//
//            TextField("name", text: $newPlayerName)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//            Button(action: {
//                print( "save ")
//                if self.newPlayerName.isEmpty {
//                    self.errorMessage = "Player name cannot be empty"
//                } else {
//                    let newModel = UserModel(
//                        name: self.newPlayerName
//                    )
//                    self.appState.addPlayer(model: newModel)
//                    self.presentationMode.wrappedValue.dismiss()
//                }
//            }) {
//                Text("SAVE")
//            }
//            Spacer()
//
//        }
//    }//end body
//
//}
//
////struct NewPlayerView_Previews: PreviewProvider {
////    static var previews: some View {
////        NewPlayerView(userStore: UserStore(storeConfig: StoreConfig.local))
////    }
////}
