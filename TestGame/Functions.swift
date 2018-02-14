//
//  Functions.swift
//  TestGame
//
//  Created by Natalya on 13/02/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import Foundation
import SpriteKit

class Functions: GameScene {
    
    func goToNextScene(fromScene: SKScene, onScene: SKScene) {
        onScene.scaleMode = .aspectFill
        fromScene.view!.presentScene(onScene)
    }
    
}
