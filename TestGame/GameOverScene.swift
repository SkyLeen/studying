//
//  GameOverScene.swift
//  TestGame
//
//  Created by Natalya on 11/02/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameOverScene: SKScene {
    
    var gameOverLabel: SKLabelNode!
    
    override func didMove(to view: SKView) {
        initLabel()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let onScene = SKScene(fileNamed: "GameScene")!
        Functions().goToNextScene(fromScene: self, onScene: onScene)
    }
    
    func initLabel() {
        gameOverLabel = self.childNode(withName: "gameOver") as! SKLabelNode
        let newGameLabel = SKLabelNode(fontNamed: "Gill Sans")
        newGameLabel.text = "Touch the screen if you want to restart"
        newGameLabel.position = CGPoint(x: 0, y: -100)
        newGameLabel.fontSize = 45
        self.addChild(newGameLabel)
    }
}
