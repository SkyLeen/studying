//
//  Fighter.swift
//  TestGame
//
//  Created by Natalya on 11/02/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import Foundation
import SpriteKit

class Fighter: SKSpriteNode, Moveable, Shootable {
    
    func setUp() {
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody!.affectedByGravity = false
        
        self.physicsBody!.collisionBitMask = PhysicBodies.alien | PhysicBodies.alienBullet
        self.physicsBody!.contactTestBitMask = PhysicBodies.alien | PhysicBodies.alienBullet
        self.physicsBody!.categoryBitMask = PhysicBodies.fighter
        
    }
    
    func move(atShift: CGFloat) {
        self.position.x += atShift
    }
}
