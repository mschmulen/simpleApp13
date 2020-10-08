//
//  SimpleGameView.swift
//  SceneKitGameSimple
//
//  Created by Matthew Schmulen on 10/8/20.
//

import SwiftUI
import SpriteKit

public struct SimpleGameView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    let sceneSizeWidth: CGFloat = 300
    let sceneSizeHeight: CGFloat = 400
    
    let startData: StartData
    let closeCallback: (_ closeData: CloseData)->Void
    
    public init(
        startData: StartData,
        closeCallback: @escaping (_ closeData: CloseData)->Void) {
        self.startData = startData
        self.closeCallback = closeCallback
    }
    
    var scene: SKScene {
        let scene = SimpleGameScene()
        scene.size = CGSize(width: sceneSizeWidth, height: sceneSizeHeight)
        scene.scaleMode = .fill
        return scene
    }
    
    public var body: some View {
        SpriteView(scene: scene)
            .frame(width: sceneSizeWidth, height: sceneSizeHeight)
            .edgesIgnoringSafeArea(.all)
    }
}

struct SimpleGameView_Previews: PreviewProvider {
    static var previews: some View {
        SpriteKitView(
            game: SpriteKitView.Games.simple,
            startData: StartData()) { (closeData) in
            print("close Data")
        }
        
    }
}
