//
//  BlocksGameView.swift
//  SceneKitGameSimple
//
//  Created by Matthew Schmulen on 10/8/20.
//

import SwiftUI
import SpriteKit

public struct BlocksGameView: View {
    
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
        let scene = BlocksGameScene()
        scene.size = CGSize(width: sceneSizeWidth, height: sceneSizeHeight)
        scene.scaleMode = .fill
        return scene
    }
    
    public var body: some View {
        VStack  {
            Text("Blocks Game")
            SpriteView(scene: scene)
                .frame(width: sceneSizeWidth, height: sceneSizeHeight)
                .edgesIgnoringSafeArea(.all)

        }
    }
    
}

struct BlocksGameView_Previews: PreviewProvider {
    static var previews: some View {
        BlocksGameView(
            startData: StartData()) { (closeData) in
            print("close Data")
        }
        
    }
}
