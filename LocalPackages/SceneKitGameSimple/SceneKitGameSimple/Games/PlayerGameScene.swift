//
//  PlayerGameScene.swift
//  SceneKitGameSimple
//
//  Created by Matthew Schmulen on 10/7/20.
//

import SwiftUI
import SpriteKit

// https://munirwanis.github.io/blog/2020/wwdc20-scenekit-swiftui/

public class PlayerGameScene: SKScene {
    
    var player = SKSpriteNode(color: .green, size: CGSize(width: 16, height: 16))
    
    @Binding var currentDirection: PlayerDirection
    
    init(_ direction: Binding<PlayerDirection>) {
        _currentDirection = direction
        super.init(size: CGSize(width: 414, height: 896)) // It's fixed to match scaled down iPhone resolutions for the sake of simplicity
        self.scaleMode = .fill
    }
    
    required init?(coder aDecoder: NSCoder) {
        _currentDirection = .constant(.up)
        super.init(coder: aDecoder)
    }
    
    public override func didMove(to view: SKView) {
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.affectedByGravity = false
        player.position = .init(x: size.width / 2, y: size.height / 2)
        player.physicsBody?.linearDamping = 0
        addChild(player)
        
        //physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
    }
    
    public override func update(_ currentTime: TimeInterval) {
        if player.physicsBody?.velocity.dx ?? 0 < 0, currentDirection.velocity.dx > 0 {
            // can't turn
        } else if player.physicsBody?.velocity.dx ?? 0 > 0, currentDirection.velocity.dx < 0 {
            // can't turn
        } else if player.physicsBody?.velocity.dy ?? 0 < 0, currentDirection.velocity.dy > 0 {
            // can't turn
        } else if player.physicsBody?.velocity.dy ?? 0 > 0, currentDirection.velocity.dy < 0 {
            // can't turn
        } else {
            player.physicsBody?.velocity = currentDirection.velocity
        }
        
        
        let playerHeightPadding = (player.size.height / 2) - 1
        let playerWidthPadding = (player.size.width / 2) - 1
        
        if player.position.x <= playerWidthPadding {
            player.position.x = player.size.width / 2
            currentDirection = .stop
        } else if player.position.x >= (self.size.width - playerWidthPadding) {
            player.position.x = self.size.width - (player.size.width / 2)
            currentDirection = .stop
        } else if player.position.y <= playerHeightPadding {
            player.position.y = player.size.height / 2
            currentDirection = .stop
        } else if player.position.y >= (self.size.height - playerHeightPadding) {
            player.position.y = self.size.height - (player.size.height / 2)
            currentDirection = .stop
        }
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let box = SKSpriteNode(color: UIColor.red, size: CGSize(width: 50, height: 50))
        box.position = location
        box.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 50))
        addChild(box)
    }
}
