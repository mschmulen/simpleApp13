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
    
    @State var email: String = "eve.holt@reqres.in"
    @State var password: String = ""

    @State var errorMessage: String?

    var body: some View {
        VStack {
            
            Text("Authentication View")
            
            Spacer()
            
            if errorMessage != nil {
                Text(errorMessage!)
                    .foregroundColor(.red)
                Spacer()
            }
            
            
            VStack {
                TextField("email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }.padding()

            HStack {
                
                Button(action: {
                    self.appState.signIn(email: self.email, password: "cityslicka") { result in
                        switch result {
                        case .success( _ ):
                            self.appState.topView = .tabView
                            self.presentationMode.wrappedValue.dismiss()
                        case .failure( let error):
                            self.errorMessage = "Sign In Error \(error)"
                            //self.appState.topView = .tabView
                        }
                    }
                }) {
                    Text("Sign In")
                }.padding()
                
                Spacer()
                
                Button(action: {
                    self.appState.register(email: self.email, password: "pistol")  { result in
                        switch result {
                        case .success( _ ):
                            self.appState.topView = .tabView
                            self.presentationMode.wrappedValue.dismiss()
                        case .failure( let error):
                            self.errorMessage = "Register In Error \(error)"
                        }
                    }
                }) {
                    Text("Register")
                }.padding()
            }.padding()
            
            Spacer()
            
            Button(action: {
                self.appState.topView = .tabView
            }) {
                Text("Cancel")
            }.padding()
            
            Spacer()
        }
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AutheticationView()
    }
}
