//
//  LoginView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 7/19/20.
//  Copyright © 2020 jumptack. All rights reserved.
//


import SwiftUI

struct AutheticationView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
        
    @EnvironmentObject var appState: AppState
        
    @State var errorMessage: String?
    
    @State var userStore:UserStore = UserStore(storeConfig: StoreConfig.local)

    var body: some View {
        VStack {
            
            Text("Sign In")
            
            Spacer()
            
            if errorMessage != nil {
                Text(errorMessage!)
                    .foregroundColor(.red)
                Spacer()
            }
            
            List {
                ForEach(self.userStore.models) { model in
                    Button(action: {
                        self.appState.signIn(user: model)
                        self.appState.topView = .mainView
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("User \(model.name)")
                    }
                }
            }
        }
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AutheticationView()
    }
}
