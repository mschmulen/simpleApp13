//
//  MainFamilyViewStatusFilterView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/18/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit

struct MainFamilyViewStatusFilterView: View {
    
    @Environment(\.window) var window: UIWindow?
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    public enum ActivityStatusFilter {
        case none
        case status( ActivityStatus )
        
        var name:String {
            switch self {
            case .none:
                return "All"
            case .status( let status):
                return "\(status.friendlyName)"
            }
        }
    }
    
    @Binding var activityStatusFilter: ActivityStatus
    @Binding var showFilterOptions:Bool
    
    let cardSize:CGFloat = 50
    let cardRadius:CGFloat = 20
    
    var body: some View {
        VStack {
            if showFilterOptions == false {
                Text("show filter options")
                .padding()
                    .onTapGesture {
                        self.showFilterOptions.toggle()
                }
            } else {
                Picker(selection: $activityStatusFilter, label: Text("Status")) {
                    ForEach(ActivityStatus.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }.pickerStyle(SegmentedPickerStyle())
                    .padding()
            }
            
        }.padding()
    }
}

