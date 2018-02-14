//
//  ShootingAlien.swift
//  TestGame
//
//  Created by Natalya on 13/02/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import Foundation
import SpriteKit

class ShootingAlien: Alien, Shootable {
    
    override func setUp() {
        self.colorBlendFactor = 0.6
        self.color = .red
        
        self.run(SKAction.repeatForever(SKAction.sequence([
            SKAction.move(by: CGVector(dx: -20, dy: 0), duration: 1),
            SKAction.move(by: CGVector(dx: 40, dy: 0), duration: 1),
            SKAction.move(by: CGVector(dx: -20, dy: 0), duration: 1)
            ])))
    }
}
