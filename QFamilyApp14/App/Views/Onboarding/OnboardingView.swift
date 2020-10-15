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

    @State var initialTasks: [CKPublicActivityDescription] = [CKPublicActivityDescription]()

    @State var parentName: String = ""
    @State var parentEmoji: String = "🦉"
    @State var isValidiCloudAccount: Bool = true

    @State var devMessage: String?
    
    enum TabViewPage:Int {
        case welcome = 0
        case icloud
        case adultInfo
        case childInfo
        case taskPicker
        case done
        
    }
    
    public var body: some View {
        
        VStack {
            DevMessageView(devMessage: $devMessage)
            
            
            TabView(selection: $currentTabIndex){
                OnboardingWelcomeView() {
                    currentTabIndex = TabViewPage.icloud.rawValue
                }.tag(TabViewPage.welcome.rawValue)
                
                OnboardingiCloudView() {
                    currentTabIndex = TabViewPage.adultInfo.rawValue
                }.tag(TabViewPage.icloud.rawValue)
                
                OnboardingAdultInfoView(
                    parentName: $parentName,
                    parentEmoji: $parentEmoji
                ) {
                    currentTabIndex = TabViewPage.done.rawValue
                }.tag(TabViewPage.adultInfo.rawValue)
                
                //            OnboardingChildInfoView(
                //            ) {
                //                currentTabIndex = TabViewPage.taskPicker.rawValue
                //            }.tag(TabViewPage.childInfo.rawValue)
                //
                //            OnboardingTaskPickerView(
                //            ){
                //                currentTabIndex = TabViewPage.done.rawValue
                //            }.tag(TabViewPage.taskPicker.rawValue)
                
                OnboardingAllDoneView() {
                    
                    if self.parentName.isEmpty {
                        devMessage = "Parent Name is empty"
                        return
                    }
                    
                    if self.parentEmoji.isEmpty {
                        devMessage = "Parent Emoji is empty"
                        return
                    }
                    
                    if self.isValidiCloudAccount == false {
                        devMessage = "invalid iCloud account"
                        return
                    }
                    
                    self.close()
                }.tag(TabViewPage.done.rawValue)
            }
            .tabViewStyle(PageTabViewStyle())
        }
    }
    
    func close() {
        self.appState.topView = TopView.mainView
    }
}

