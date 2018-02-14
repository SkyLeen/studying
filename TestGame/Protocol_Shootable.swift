//
//  Protocol_Shootable.swift
//  TestGame
//
//  Created by Natalya on 14/02/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import Foundation
import SpriteKit

protocol Shootable {
    func shoot(withBullet: SKSpriteNode, by: SKSpriteNode,  onScene: SKScene)
}

extension Shootable {
    
    func shoot(withBullet: SKSpriteNode, by: SKSpriteNode,  onScene: SKScene) {
        let myScene = onScene as! GameScene
        let newBullet = withBullet.copy() as! SKSpriteNode
        var yPosition: CGFloat = myScene.size.height/2
        
        myScene.addChild(newBullet)
        newBullet.position.x = by.position.x
        newBullet.position.y = by.position.y
        
        if newBullet.position.y > 0 {
            yPosition *= -1
        }
        let bulletFlight = SKAction.move(to: CGPoint(x: newBullet.position.x,y: yPosition), duration: 1)
        newBullet.run(
            SKAction.sequence([
                bulletFlight,
                SKAction.removeFromParent()
                ])
        )
    }
}

