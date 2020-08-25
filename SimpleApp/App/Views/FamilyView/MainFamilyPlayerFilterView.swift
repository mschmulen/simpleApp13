//
//  MainFamilyViewPlayerFilter.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/18/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit
import CloudKit

struct MainFamilyPlayerFilterView: View {
    
    @Environment(\.window) var window: UIWindow?
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    public enum PlayerFilter {
        case none
        case person( CKPlayerModel)
        
        var name:String {
            switch self {
            case .none:
                return "All Family"
            case .person( let playerModel):
                return "\(playerModel.name ?? "~")"
            }
        }
    }
    
    @Binding var currentFilter: PlayerFilter
    @Binding var showFilterOptions:Bool
    
    let cardSize: CGFloat = 60
    let cardRadius: CGFloat = 20
    
    var body: some View {
        HStack {
            if showFilterOptions == false {
                //Image(systemName: "plus.circle.fill")
                Text("show filter options")
                .padding()
                    .onTapGesture {
                        self.showFilterOptions.toggle()
                }
            }
            
            if showFilterOptions {
                
//                Image(systemName: "minus.circle.fill")
//                    .padding()
//                    .onTapGesture {
//                        self.showFilterOptions.toggle()
//                }
                
                ScrollView(.horizontal, showsIndicators: false){
                    HStack {
                        VStack {
                            Text("🏡")
                                .font(.body)
                            Spacer()
                            Text("Family")
                                .font(.system(size: 15, weight: .bold, design: .rounded))
                                .foregroundColor(Color(.white))
                        }
                        .frame(width: cardSize, height: cardSize)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(cardRadius)
                        .shadow(radius: 10)
                        
                        .onTapGesture {
                            self.currentFilter = PlayerFilter.none
                        }
                        
                        ForEach( self.familyKitAppState.playerService.models ) { player in
                            VStack {
                                Text("\(player.emoji ?? "")")
                                Spacer()
                                Text("\(player.name ?? "")")
                                    .font(.system(size: 15, weight: .medium, design: .rounded))
                            }
                            .frame(width: self.cardSize, height: self.cardSize)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(self.cardRadius)
                            .shadow(radius: 10)
                            .onTapGesture {
                                self.currentFilter = PlayerFilter.person( player )
                            }
                        }
                    }.padding()
                }//end ScrollView
            }
        }

    }//end playerPickerView
}
