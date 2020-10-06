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
    @State var networkStateViewModel: NetworkStateViewModel = NetworkStateViewModel()
    @State var cloudKitStateViewModel: CloudKitStateViewModel = CloudKitStateViewModel()
    
    public var body: some View {
        TabView {
            OnboardingWelcomeView()
            OnboardingInfoView()
            OnboardingGetStartedView() {
                self.close()
            }
        }
        .tabViewStyle(PageTabViewStyle())
    }
    
    func close() {
        self.appState.topView = TopView.mainView
    }
}

struct OnboardingWelcomeView: View {
    var backgroundColor = SemanticAppColor.random
    
    var body: some View {
        ZStack {
            backgroundColor
            VStack {
                Text("Welcome to Family App").padding()
                Text("Lets get started").padding()
                Spacer()
            }.foregroundColor(.white)
        }
    }
}

struct OnboardingInfoView: View {
    
    var backgroundColor = SemanticAppColor.random
    
    var body: some View {
        ZStack {
            backgroundColor
            VStack {
                Text("Some info Family").padding()
                Text("Some info Family").padding()
                Text("Some info Family").padding()
                Text("Some info Family").padding()
                Spacer()
            }.foregroundColor(.white)
        }
    }
}

struct OnboardingGetStartedView: View {
    
    var closeCallback: ()->Void
    
    var backgroundColor = SemanticAppColor.random
    
    var body: some View {
        ZStack {
            backgroundColor
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        self.closeCallback()
                    }) {
                        Text("CLOSE !")
                    }.padding()
                }
                Text("Get Started").padding()
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        self.closeCallback()
                    }) {
                        Text("DONE !")
                    }.padding()
                }
            }.foregroundColor(.white)
        }
    }
}

