//
//  Alien.swift
//  TestGame
//
//  Created by Natalya on 11/02/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import Foundation
import SpriteKit

class Alien: SKSpriteNode {

        convenience init() {
            self.init(imageNamed: "alien")
            self.name = "alien"
            setUp()
        }
    
    func setUp() {
        self.run(SKAction.repeatForever(SKAction.sequence([
            SKAction.move(by: CGVector(dx: -20, dy: 0), duration: 1),
            SKAction.move(by: CGVector(dx: 40, dy: 0), duration: 1),
            SKAction.move(by: CGVector(dx: -20, dy: 0), duration: 1)
        ])))
    }
    
    func blowUp() {
        self.run(SKAction.sequence([
            SKAction.fadeOut(withDuration: 0.1),
            SKAction.fadeIn(withDuration: 0.1),
            SKAction.fadeOut(withDuration: 0.1),
            SKAction.fadeIn(withDuration: 0.1),
            SKAction.removeFromParent()
            ]))
    }
}
