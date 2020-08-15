//
//  KidUserView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/6/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit
import CloudKit
import SimpleGames

struct KidUserView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var privateChoreService: CKPrivateModelService<CKActivityDescriptionModel>
    @EnvironmentObject var privateActiveChoreService: CKPrivateModelService<CKActivityModel>
    @EnvironmentObject var chatService: ChatService
    
    @State var devMessage: String?
    
    var body: some View {
        List{
            DevMessageView(devMessage: $devMessage)
            
            Section(header: Text("Current Player")) {
                Text("\(familyKitAppState.currentPlayer.name)")
                
                NavigationLink(destination: PlayerOnboardingView()) {
                    Text("Change Current Player")
                        .foregroundColor(.blue)
                }
            }
            
            NavigationLink(destination: ChatSessionView()) {
                Text("Show Chat")
                    .foregroundColor(.blue)
            }
            
        }.onAppear(perform: {
            self.familyKitAppState.onRefresh()
        })
        .navigationBarTitle("\(familyKitAppState.currentPlayer.name)")
    }
}


struct KidUserView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            KidUserView()
                //.environment(\.window, window)
                .environmentObject(AppState())
                .environmentObject(FamilyKitAppState(container: CKContainer(identifier: CKContainerIdentifier)))
                .previewDevice(PreviewDevice(rawValue: "iPad Air 2"))
            
            KidUserView()
                //.environment(\.window, window)
                .environmentObject(AppState())
                .environmentObject(FamilyKitAppState(container: CKContainer(identifier: CKContainerIdentifier)))
            .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
            .previewDisplayName("iPhone SE")
            
            KidUserView()
                //.environment(\.window, window)
                .environmentObject(AppState())
                .environmentObject(FamilyKitAppState(container: CKContainer(identifier: CKContainerIdentifier)))
            .previewDevice(PreviewDevice(rawValue: "iPhone XS Max"))
            .previewDisplayName("iPhone XS Max")

        }
    }
}

