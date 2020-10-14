//
//  SpriteKitView.swift
//  SceneKitGameSimple
//
//  Created by Matthew Schmulen on 10/7/20.
//

import SwiftUI
import SpriteKit

public struct StartData {
    
    public init() {
        
    }
}

public struct CloseData {
}

public struct SpriteKitView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    let sceneSizeWidth: CGFloat = 300
    let sceneSizeHeight: CGFloat = 400
    
    public enum Games {
        case simple
        case blocks
        case player
        
        public var name:String {
            switch self {
            case .simple: return "simple"
            case .blocks: return "blocks"
            case .player: return "player"
            }
        }
    }

    let game: Games
    let startData: StartData
    let closeCallback: (_ closeData: CloseData)->Void
    
    public init(
        game: Games,
        startData: StartData,
        closeCallback: @escaping (_ closeData: CloseData)->Void) {
        self.game = game
        self.startData = startData
        self.closeCallback = closeCallback
    }
    
    public var body: some View {
        ZStack {
            //            Rectangle()
            //                .fill(Color.green)
            //                .edgesIgnoringSafeArea(.all)
            
            LinearGradient(gradient: Gradient(colors: [Color.gray, Color.gray.opacity(0.8), Color.gray]),
                           startPoint: .top,
                           endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                switch game {
                case .blocks:
                    BlocksGameView(
                        startData: startData,
                        closeCallback: closeCallback
                    )
                case .simple:
                    SimpleGameView(
                        startData: startData,
                        closeCallback: closeCallback
                    )
                case .player:
                    PlayerGameView(
                        startData: startData,
                        closeCallback: closeCallback
                    )
                }
            }
            
            VStack {
                HStack  {
                    Spacer()
                    Button(action: {
                        self.closeCallback(CloseData())
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("CLOSE")
                            .padding(.top, 40)
                            .padding(.trailing, 10)
                    }
                }//end HStack
                Spacer()
            }//end VStack
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.red)
        .edgesIgnoringSafeArea(.all)
    }
}

struct SpriteKitView_Previews: PreviewProvider {
    static var previews: some View {
        SpriteKitView(
            game: SpriteKitView.Games.simple,
            startData: StartData()) { (closeData) in
            print("close Data")
        }
    }
}
