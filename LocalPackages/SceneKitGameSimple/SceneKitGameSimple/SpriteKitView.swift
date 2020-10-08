//
//  SpriteKitView.swift
//  SceneKitGameSimple
//
//  Created by Matthew Schmulen on 10/7/20.
//

import SwiftUI
import SpriteKit

public struct SpriteKitView: View {
    
    //@Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    //@EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    let sceneSizeWidth: CGFloat = 300
    let sceneSizeHeight: CGFloat = 400
    
    public enum Games {
        case simple
        case blocks
    }
    
    let game:Games
    
    public init(game: Games) {
        self.game = game
    }
    
    var scene: SKScene {
        let scene = SimpleGameScene()
        scene.size = CGSize(width: sceneSizeWidth, height: sceneSizeHeight)
        scene.scaleMode = .fill
        return scene
    }
    
    public var body: some View {
        ZStack {
            SpriteView(scene: scene)
                .frame(width: sceneSizeWidth, height: sceneSizeHeight)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Rectangle()
                    .fill(Color.green)
                HStack  {
                    Spacer()
                    Button(action: {
                        print( "reset scene TODO")
                    }) {
                        Text("RESET")
                            .padding()
                    }
                    
                    Button(action: {
                        print( "close")
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("CLOSE")
                            .padding()
                    }
                }//end HStack
                Spacer()
            }//end VStack
        }
    }
}

struct SpriteKitView_Previews: PreviewProvider {
    static var previews: some View {
        SpriteKitView(game: SpriteKitView.Games.simple)
    }
}
