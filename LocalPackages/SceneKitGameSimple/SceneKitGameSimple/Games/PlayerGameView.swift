//
//  PlayerGameView.swift
//  SceneKitGameSimple
//
//  Created by Matthew Schmulen on 10/8/20.
//

import Foundation
import SwiftUI
import SpriteKit

public struct PlayerGameView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    let sceneSizeWidth: CGFloat = 300
    let sceneSizeHeight: CGFloat = 400
    
    let startData: StartData
    let closeCallback: (_ closeData: CloseData)->Void
    
    @State private var currentDirection = PlayerDirection.stop

    public init(
        startData: StartData,
        closeCallback: @escaping (_ closeData: CloseData)->Void) {
        self.startData = startData
        self.closeCallback = closeCallback
    }
    
    var scene: SKScene {
            let scene = PlayerGameScene($currentDirection)
            scene.size = CGSize(width: sceneSizeWidth, height: sceneSizeHeight)
            scene.scaleMode = .fill
            return scene
    }
    
    public var body: some View {
        ZStack {
            VStack {
                SpriteView(scene: scene)
                    .frame(width: sceneSizeWidth, height: sceneSizeHeight)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 10) {
                    HStack {
                        Spacer()
                        directionalButton(.up)
                        Spacer()
                    }
                    HStack {
                        directionalButton(.left)
                        directionalButton(.down)
                        directionalButton(.right)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.red)
        .edgesIgnoringSafeArea(.all)
    }
    
    
    func directionalButton(_ direction: PlayerDirection) -> some View {
        VStack {
            Button(action: { self.currentDirection = direction }, label: {
                Image(systemName: "arrow.\(direction.rawValue)")
                    .frame(width: 50, height: 50, alignment: .center)
                    .foregroundColor(.black)
                    .background(Color.white.opacity(0.6))
            })
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
            .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
        }
    }
    
    func redButtonForTesting() -> some View {
        Button(action: {}) {
            Circle()
                .frame(width: 50, height: 50)
                .foregroundColor(.red)
                .overlay(Circle()
                            .foregroundColor(.red)
                            .padding(10)
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                            .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5))
                .background(RoundedRectangle(cornerRadius: 10)
                                .frame(width: 80, height: 80)
                                .foregroundColor(Color.black.opacity(0.4))
                                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                                .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5))
        }
        .padding()
    }
}

struct PlayerGameView_Previews: PreviewProvider {
    static var previews: some View {
        SpriteKitView(
            game: SpriteKitView.Games.simple,
            startData: StartData()) { (closeData) in
            print("close Data")
        }
        
    }
}
