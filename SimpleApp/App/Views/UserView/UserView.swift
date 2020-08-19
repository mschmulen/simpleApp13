//
//  UserView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/19/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit
import CloudKit
import SimpleGames

// TODO: use the UserView instead of the Kid and Adult View
struct UserView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var privateChoreService: CKPrivateModelService<CKActivityDescriptionModel>
    @EnvironmentObject var privateActiveChoreService: CKPrivateModelService<CKActivityModel>
    @EnvironmentObject var chatService: ChatService
    
    @State var devMessage: String?
    
    var body: some View {
        VStack {
            if (self.familyKitAppState.currentPlayerModel?.isAdult ?? false) {
                AdultUserView()
            } else {
                KidUserView()
            }
        }.onAppear(perform: {
            self.familyKitAppState.onRefresh()
        })
        .navigationBarTitle("\(familyKitAppState.currentPlayerModel?.name ?? "none")")
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            UserView()
                //.environment(\.window, window)
                .environmentObject(AppState())
                .environmentObject(FamilyKitAppState(container: CKContainer(identifier: CKContainerIdentifier)))
                .previewDevice(PreviewDevice(rawValue: "iPad Air 2"))
            
            UserView()
                //.environment(\.window, window)
                .environmentObject(AppState())
                .environmentObject(FamilyKitAppState(container: CKContainer(identifier: CKContainerIdentifier)))
            .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
            .previewDisplayName("iPhone SE")
            
            UserView()
                //.environment(\.window, window)
                .environmentObject(AppState())
                .environmentObject(FamilyKitAppState(container: CKContainer(identifier: CKContainerIdentifier)))
            .previewDevice(PreviewDevice(rawValue: "iPhone XS Max"))
            .previewDisplayName("iPhone XS Max")

        }
    }
}

