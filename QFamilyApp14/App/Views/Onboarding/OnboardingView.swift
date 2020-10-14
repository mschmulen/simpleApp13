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
    @State var currentTabIndex: Int = 0
    
    @State var adultName: String = ""
    @State var adultEmoji: String = ""
    
    @State var childName: String = ""
    @State var childEmoji: String = ""
    
    @State var initialTasks: [CKPublicActivityDescription] = [CKPublicActivityDescription]()
    
    public var body: some View {
        
        TabView(selection: $currentTabIndex){
            OnboardingWelcomeView() {
                currentTabIndex = 1
            }.tag(0)
            
//            OnboardingiCloudView() {
//                currentTabIndex = 2
//            }.tag(1)
            
            OnboardingAdultInfoView(
                
            ) {
                currentTabIndex = 2
            }.tag(1)
            OnboardingChildInfoView(
                
            ) {
                currentTabIndex = 3
            }.tag(2)
            OnboardingTaskPickerView(
                
            ){
                currentTabIndex = 4
            }.tag(3)
            OnboardingAllDoneView() {
                self.close()
            }.tag(4)
        }
        .tabViewStyle(PageTabViewStyle())
    }
    
    func close() {
        self.appState.topView = TopView.mainView
    }
}

