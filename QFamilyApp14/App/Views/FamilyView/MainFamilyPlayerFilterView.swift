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
    
    struct PlayerFilterViewData: Identifiable {
        let id: UUID = UUID()
        var playerFilter: PlayerFilter
        var isSelected: Bool
    }
    
    @Binding var currentFilter: PlayerFilter {
        didSet {
            print( "did update playerFilter")
            
            buildFilterCards()
            
//            for card in filterCards {
//                switch card.playerFilter {
//                case .none:
//                    switch currentFilter {
//                    case .none:
//                        card.isSelected = true
//                    default:
//                        card.isSelected = false
//                    }
//                case .person(let thisCardModel):
//                    switch currentFilter {
//                    case .none:
//                        card .isSelected = false
//                    case .person(let filterModel):
//                        if filterModel == thisCardModel {
//                            card.isSelected = true
//                        } else {
//                            card.isSelected = false
//                        }
//                    }
//                }
//            }
        }
    }
    
    @State var filters:[PlayerFilterViewData] = [PlayerFilterViewData]()
    
    var body: some View {
        HStack {
            HStack {
                ScrollView(.horizontal, showsIndicators: false){
                    HStack {
//                        PlayerFilterCardView(
//                            playerFilter: PlayerFilter.none,
//                            name: "Family",
//                            emoji: "🏡",
//                            isSelected: true,
//                            onTapCallback: {
//                            self.currentFilter = PlayerFilter.none
//                        })
//
//                        ForEach( self.familyKitAppState.playerService.models ) { player in
//
//                            PlayerFilterCardView(
//                                playerFilter: PlayerFilter.person(player),
//                                name: player.name ?? "",
//                                emoji: player.emoji ?? "",
//                                isSelected: false,
//                                onTapCallback: {
//                                self.currentFilter = PlayerFilter.person( player )
//                                // self.currentFilter = PlayerFilter.none
//                            })
//                        }
                        
                        ForEach(filters) { filter in
                            PlayerFilterCardView(playerFilterViewData: filter, onTapCallback: {
                                self.currentFilter = filter.playerFilter
                            })
                            
//                            PlayerFilterCardView(
//                                playerFilterViewData: filter,
//                                onTapCallback: {
//                                    self.currentFilter = filter
//                                    // self.currentFilter = PlayerFilter.none
//                                })
//                                name: player.name ?? "",
//                                emoji: player.emoji ?? "",
//                                isSelected: false,
//                                onTapCallback: {
//                                self.currentFilter = PlayerFilter.person( player )
//                                // self.currentFilter = PlayerFilter.none
//                            })
                        }
                    }.padding()
                }//end ScrollView
            }
        }//end HStack
        .onAppear {
            
            buildFilterCards()
        }
    }//end body
    
    func buildFilterCards() {
        filters.removeAll()
        filters.append(
            PlayerFilterViewData(
                playerFilter: PlayerFilter.none,
                isSelected: (currentFilter.name == PlayerFilter.none.name) ? true : false
            )
        )
        
        for player in self.familyKitAppState.playerService.models {
            switch currentFilter {
            case .none:
                filters.append(
                    PlayerFilterViewData(
                        playerFilter: PlayerFilter.person(player),
                        isSelected: false
                    )
                )
            case .person(let currentFilterPlayer):
                filters.append(
                    PlayerFilterViewData(
                        playerFilter: PlayerFilter.person(player),
                        isSelected: (currentFilterPlayer.name == player.name) ? true : false
                    )
                )
            }
        }
    }
    
    struct PlayerFilterCardView: View {
        
        let cardSize: CGFloat = 60
        let cardRadius: CGFloat = 20
        let selectedBackgroundColor = Color.blue
        let normalBackgroundColor = Color.green
        
        var playerFilterViewData: PlayerFilterViewData
        
        var onTapCallback: ()->Void
        
        var currentColor: Color {
            if playerFilterViewData.isSelected == true {
                return Color.blue
            } else {
                return Color.green
            }
        }
        
        var name: String {
            switch playerFilterViewData.playerFilter {
            case .none:
                return "Family"
            case .person(let model) :
                return model.name ?? "?"
            }
        }
        
        var emoji: String {
            switch playerFilterViewData.playerFilter {
            case .none:
                return "🏡"
            case .person(let model) :
                return model.emoji ?? "?"
            }
        }
        
        var body: some View {
            VStack {
                Text("\(emoji)")
                Spacer()
                Text("\(name)")
                    .modifier(PrimarySmallRegularLabel(color: .black))
            }
            .frame(width: self.cardSize, height: self.cardSize)
            .padding()
            .background( currentColor)
            .cornerRadius(self.cardRadius)
            .shadow(radius: 10)
            .onTapGesture {
                onTapCallback()
                //isSelected.toggle()
            }
        } //end var body
    }//end PlayerFilterCardView
}

struct MainFamilyPlayerFilterView_Previews: PreviewProvider {
    static var previews: some View {
        MainFamilyPlayerFilterView(
            currentFilter: .constant(MainFamilyPlayerFilterView.PlayerFilter.none)
        )
    }
}
