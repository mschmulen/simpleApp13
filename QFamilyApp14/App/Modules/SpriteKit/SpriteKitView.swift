//
//  SpriteKitView.swift
//  QFamilyApp14
//
//  Created by Matthew Schmulen on 10/7/20.
//

import SwiftUI
import SpriteKit

struct SpriteKitView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    //@EnvironmentObject var familyKitAppState: FamilyKitAppState

    
    let sceneSizeWidth: CGFloat = 300
    let sceneSizeHeight: CGFloat = 400

    
    var scene: SKScene {
        let scene = GameScene()
        scene.size = CGSize(width: sceneSizeWidth, height: sceneSizeHeight)
        scene.scaleMode = .fill
        return scene
    }
    
    var body: some View {
        ZStack {
            SpriteView(scene: scene)
                .frame(width: sceneSizeWidth, height: sceneSizeHeight)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack  {
                    Spacer()
                    Button(action: {
                        print( "close")
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("CLOSE")
                    }
                }//end HStack
                Spacer()
            }//end VStack
        }
    }
}

struct SpriteKitView_Previews: PreviewProvider {
    static var previews: some View {
        SpriteKitView()
    }
}
