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
            HStack {
                VStack {
                    if showFilterOptions == false {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .padding()
                                .onTapGesture {
                                    self.showFilterOptions.toggle()
                            }
                            Text("Show Filter")
                            .onTapGesture {
                                self.showFilterOptions.toggle()
                            }
                        }
                    } else {
                        Image(systemName: "minus.square.fill")
                            .padding()
                            .onTapGesture {
                                self.showFilterOptions.toggle()
                        }
                    }
                }//end VStack
                
                if showFilterOptions {
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack {
                            VStack {
                                Text("🏡")
                                    .font(.body)
                                Spacer()
                                Text("Family")
                                    .modifier(PrimarySmallBoldLabel(color: .white))
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
                                        .modifier(PrimarySmallRegularLabel(color: .black))
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
        }//end HStack
    }//end body
}

struct MainFamilyPlayerFilterView_Previews: PreviewProvider {
    static var previews: some View {
        MainFamilyPlayerFilterView(
            currentFilter: .constant(MainFamilyPlayerFilterView.PlayerFilter.none),
            showFilterOptions: .constant(true)
        )
    }
}
