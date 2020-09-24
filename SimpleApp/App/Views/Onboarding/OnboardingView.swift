//
//  OnboardingView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 9/24/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import CloudKit
import FamilyKit

public struct OnboardingView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var activityDescriptionService: CKPrivateModelService<CKActivityDescriptionModel>
    @EnvironmentObject var activityService: CKPrivateModelService<CKActivityModel>
    
    
    @State var errorMessage: String?
    @State var showNoiCloudConnection = false
    @State var showNoCurrentPlayer = false
    @State var networkStateViewModel: NetworkStateViewModel = NetworkStateViewModel()
    @State var cloudKitStateViewModel: CloudKitStateViewModel = CloudKitStateViewModel()
    
    @State var showNewPlayer: Bool = false
    
    public var body: some View {
        NavigationView {
            VStack {
                if errorMessage != nil {
                    Text(errorMessage!)
                        .foregroundColor(.red)
                }
                
                if familyKitAppState.isSimulator == true {
                    Text("SIMULATOR: SOME FEATURES NOT SUPPORTED")
                        .font(.caption)
                        .foregroundColor(.red)
                }
                
                Text("OnboardingView")
                Text("Welcome to QFamly")
                Text("TODO Ask some questions show some things")
                
                Button(action: {
                    self.appState.topView = TopView.mainView
                }) {
                    Text("START")
                }
            }//end VStack
                .onAppear(perform: {
                })
        }//end Navigation
    }//end body
    
//    public init() {
//    }
    
}
