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
    
    @EnvironmentObject var appState: AppState
    
    @State var email: String = "matt@matt.com"
    @State var password: String = "password"

    var body: some View {
        VStack {
            
            Text("SignIn")
            
            Spacer()
            
            VStack {
                TextField("email", text: $email)
                TextField("password", text: $password)
            }.padding()

            HStack {
                
                Button(action: {
                    self.appState.signIn(email: self.email, password: self.password)
                }) {
                    Text("Sign In")
                }.padding()
                
                Spacer()
                
                Button(action: {
                    self.appState.register(email: self.email, password: self.password)
                }) {
                    Text("Register")
                }.padding()
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
