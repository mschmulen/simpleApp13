//
//  ViewExperimental.swift
//  QFamilyApp14
//
//  Created by Matthew Schmulen on 10/7/20.
//

import Foundation
import SwiftUI
import FamilyKit
import CloudKit
import SceneKitGameSimple

struct ViewExperimental: View {
    
    @Environment(\.window) var window: UIWindow?
    
//    @EnvironmentObject var appState: AppState
//    @EnvironmentObject var familyKitAppState: FamilyKitAppState
//
//    @EnvironmentObject var activityDescriptionService: CKPrivateModelService<CKActivityDescriptionModel>
//    @EnvironmentObject var activityService: CKPrivateModelService<CKActivityModel>
    
    @State var devMessage: String?
    
    @State var showAgent = false
    @State var showNewActivityDescriptionWizardViewSheet = false
    
    let columns = [
        // make the grid to fit in as many items per row as possible, using a minimum size of 80 points each
        GridItem(.adaptive(minimum: 150))
    ]
    
    //let data = (1...100).map { "Item \($0)" }
    let games:[SpriteKitView.Games] = [
        SpriteKitView.Games.simple,
        SpriteKitView.Games.blocks,
        SpriteKitView.Games.player
    ]
    
    @State var showFullScreenGame = false
    @State var activeGame = SpriteKitView.Games.simple
    
    var body: some View {
        NavigationView {
            VStack {
                DevMessageView(devMessage: $devMessage)
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(games, id: \.self) { game in
                            Button(action: {
                                activeGame = game
                                showFullScreenGame.toggle()
                            }){
                                Text("SHOW GAME \(game.name)")
                            }
                        }
                    }
                }
                
//                ScrollView {
//                    LazyVGrid(columns: columns, spacing: 20) {
//                        ForEach(data, id: \.self) { item in
//                            NavigationLink(
//                                destination: SpriteKitView(
//                                    game: SpriteKitView.Games.simple
//                                )
//                            ) {
//                                SimpleCard(text:item)
//                            }
//                        }
//                    }
//                    .padding(.horizontal)
//                }
            }//end VStack
            .fullScreenCover(
                isPresented: $showFullScreenGame) {
                SpriteKitView(
                    game: activeGame,
                    startData: StartData()) { (closeData) in
                    print("close Data")
                }
            }
//            .sheet(isPresented: $showFullScreenGame) {
//                SpriteKitView(
//                    game: activeGame,
//                    closeCallback: {
//                        print("close callback")
//                    })
//            }
//            .sheet(isPresented: $showNewActivityDescriptionWizardViewSheet) {
//                NewActivityDescriptionWizardView (
//                    model: CKActivityDescriptionModel()
//                )
//            }
            .onReceive(NotificationCenter.default.publisher(for: FamilyKitNotifications.CKRemoteModelChangedNotification)) { _ in
                print("Notification.Name(CloudKitModelService) recieved")
            }
            .navigationBarTitle("none")
            .navigationBarTitleDisplayMode(NavigationBarItem.TitleDisplayMode.inline)
            .toolbar{
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Text("")
                        trailingButton
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        Text("")
                        leadingButton
                    }
                }
            }//end .toolbar
        }//end NavView
    }//end body
    
    var agentView: some View {
        VStack {
            if showAgent {
                HStack {
                    Spacer()
                    Text("Agent ?")
                        .padding()
                }
            } else {
                EmptyView()
            }
        }
    }
    
    var wizardView: some View {
        VStack  {
            Button(action: {
                showNewActivityDescriptionWizardViewSheet.toggle()
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("New Activity Description")
                }
                .padding()// .trailing, 20)
            }
        }
    }
    
    private var trailingButton: some View {
        Group {
            HStack {
                Text("none")
                Text("🌞")
                Text("0")
            }
        }
    }
    
    private var leadingButton: some View {
        Text("change")
    }
}

struct ViewExperimental_Previews: PreviewProvider {
    
    static let container = CKContainer(identifier: CKContainerIdentifier)
    
    static var previews: some View {
        ViewExperimental()
    }
}

struct SimpleCard: View {
    
    var text: String
    let cardSize: CGFloat = 100
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                Rectangle()
                    .fill(SemanticAppColor.random)
                    //.frame(width: cardSize, height: cardSize)
                    .cornerRadius(5)
                
                HStack {
                    Spacer()
                    Text(text)
                        .lineLimit(3)
                        .modifier(PrimarySmallRegularLabel(color: .white))
                        .padding()
                    Spacer()
                }
                
                VStack {
                    HStack {
                        //Spacer()
                        Text("🦖")
                            //.padding()
                    }
                    Spacer()
                }
                
            }
        }
        .cornerRadius(5)
        .shadow(radius: 10)
        .padding()
        .frame(minWidth: 200, minHeight: 200)
        .onAppear {
            
        }
    }
}

