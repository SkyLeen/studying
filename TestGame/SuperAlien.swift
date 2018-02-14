//
//  SuperAlien.swift
//  TestGame
//
//  Created by Natalya on 11/02/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import Foundation
import SpriteKit

class SuperAlien: Alien {
    
    override func setUp() {
        self.colorBlendFactor = 0.3
        self.color = .red
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody!.affectedByGravity = false
        
        self.physicsBody!.collisionBitMask = PhysicBodies.fighter
        self.physicsBody!.contactTestBitMask = PhysicBodies.fighter
        self.physicsBody!.categoryBitMask = PhysicBodies.alien
        
        self.run(SKAction.repeatForever(
            SKAction.group([
                SKAction.sequence([
                    SKAction.move(by: CGVector(dx: -20, dy: 0), duration: 1),
                    SKAction.move(by: CGVector(dx: 40, dy: 0), duration: 1),
                    SKAction.move(by: CGVector(dx: -20, dy: 0), duration: 1)
                    ]),
                SKAction.sequence([
                    SKAction.rotate(byAngle: 1, duration: 1),
                    SKAction.rotate(byAngle: -1, duration: 1)])
                ])
        ))
    }
    
    func attack() {
        self.physicsBody!.applyForce(CGVector(dx: 0, dy: 6))
        self.physicsBody!.affectedByGravity = true
    }
}
