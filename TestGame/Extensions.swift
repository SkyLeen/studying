//
//  Extensions.swift
//  TestGame
//
//  Created by Natalya on 11/02/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import Foundation
import SpriteKit

extension Array {
    func randomItem() -> Element {
        let index = Int(arc4random_uniform(UInt32(self.count-1)))
        return self[index]
    }
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
