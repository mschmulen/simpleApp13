//
//  WizardView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 9/25/20.
//  Copyright © 2020 jumptack. All rights reserved.
//


import SwiftUI
import CloudKit
import FamilyKit

public struct WizardView: View {
    
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
    
    @State private var currentPage = 0
    
    public var body: some View {
        
        PagerView(pageCount: 3, currentIndex: $currentPage) {
            Color.blue
            Color.red
            Color.green
        }
    }
}
