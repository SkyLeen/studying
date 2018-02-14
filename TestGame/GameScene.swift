//
//  GameScene.swift
//  TestGame
//
//  Created by Natalya on 11/02/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import SpriteKit
import GameplayKit

enum PhysicBodies {
    static let fighter: UInt32 = 0x1 << 0
    static let alien: UInt32 = 0x1 << 1
    static let alienBullet: UInt32 = 0x1 << 2
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    public var winnerLabel: SKLabelNode!
    
    public var fighter: Fighter!
    public var bullet: SKSpriteNode!
    
    public var alien: Alien!
    public var superAliens = [SuperAlien]()
    public var shootingAliens = [ShootingAlien]()
    public var aliensBullet: SKSpriteNode!
    
    let alienRows: UInt = 4
    let alienCols: UInt = 10
    
    public var isTouched: Bool = false
    
    public var previousTime: TimeInterval = 0
    public var passedTimeSinceShoot: TimeInterval = 0
    public var passedTimeSinceAlienAttack: TimeInterval = 0
    public var passedTimeSinceAlienShoot: TimeInterval = 0
    
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        initFighter()
        initBullet()
        initAliens()
        initLabel()
        initAliensBullet()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouched = true
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let shift = getShift(touches)
        fighter.move(atShift: shift)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouched = false
    }
    
    override func update(_ currentTime: TimeInterval) {
        getPassedTime(currentTime)
        checkFighterShoot()
        checkHit()
        checkSuperAliens()
        checkAlienAttack()
        checkAlienShoot()
        checkAliensExist()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var nextScene: SKScene!
        
        let contactBitMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        let contactAlienFighterNeeded = PhysicBodies.alien | PhysicBodies.fighter
        
        let contactAlienBulletFighterNeeded = PhysicBodies.alienBullet | PhysicBodies.fighter
        
        if (contactBitMask == contactAlienFighterNeeded) || (contactBitMask == contactAlienBulletFighterNeeded) {
            nextScene = SKScene(fileNamed: "GameOverScene")
        } else {
            nextScene = SKScene(fileNamed: "GameScene")
        }
        Functions().goToNextScene(fromScene: self, onScene: nextScene)
    }
    
    func initFighter() {
        fighter = self.childNode(withName: "fighter") as! Fighter
        fighter.setUp()
    }
    
    func initBullet() {
        bullet = self.childNode(withName: "bullet") as! SKSpriteNode
        bullet.removeFromParent()
    }
    
    func initAliens() {
        alien = self.childNode(withName: "alien") as! Alien
        addAliens(rows: alienRows, cols: alienCols)
        alien.removeFromParent()
    }
    
    func initAliensBullet() {
        aliensBullet = self.childNode(withName: "aliensBullet") as! SKSpriteNode
        aliensBullet.removeFromParent()
        
        aliensBullet.physicsBody = SKPhysicsBody(rectangleOf: aliensBullet.size)
        aliensBullet.physicsBody!.affectedByGravity = false
        
        aliensBullet.physicsBody!.collisionBitMask = PhysicBodies.fighter
        aliensBullet.physicsBody!.contactTestBitMask = PhysicBodies.fighter
        aliensBullet.physicsBody!.categoryBitMask = PhysicBodies.alienBullet
    }
    
    func initLabel() {
        winnerLabel = self.childNode(withName: "winnerLabel") as! SKLabelNode
        winnerLabel.removeFromParent()
    }
    
    func addAliens(rows: UInt, cols: UInt) {
        for r in 1...rows {
            for c in 1...cols {
                let newAlien: SKSpriteNode
                
                if arc4random() % 3 == 1 {
                    newAlien = SuperAlien()
                    superAliens.append(newAlien as! SuperAlien)
                } else if arc4random() % 5 == 1 {
                    newAlien = ShootingAlien()
                    shootingAliens.append(newAlien as! ShootingAlien)
                } else {
                    newAlien = Alien()
                }
                self.addChild(newAlien)
                newAlien.position = getAlienPosition(row: r, col: c)
            }
        }
    }
    
    private func getAlienPosition(row: UInt, col: UInt) -> CGPoint {
        var point: CGPoint = alien.position
        let screenWidth = self.size.width
        let alienWidth = screenWidth / CGFloat(alienCols)
        
        point.x = alienWidth * CGFloat(col) - screenWidth/2 - alienWidth/2
        point.y += CGFloat(row - 1) * 50.0
        
        return point
    }
    
    func getPassedTime (_ currentTime: TimeInterval) {
        guard previousTime > 0 else {
            self.previousTime = currentTime
            return
        }
        
        self.passedTimeSinceShoot += (currentTime - previousTime)
        self.passedTimeSinceAlienAttack += (currentTime - previousTime)
        self.passedTimeSinceAlienShoot += (currentTime - previousTime)
        
        previousTime = currentTime
    }
    
    func getShift(_ touches: Set<UITouch>) -> CGFloat {
        let touch = touches.first!
        let touchLocation = touch.location(in: self)
        let touchPreviousLocation = touch.previousLocation(in: self)
        
        return touchLocation.x - touchPreviousLocation.x
    }
    
    func checkFighterShoot() {
        guard self.passedTimeSinceShoot > 0.3 else { return }
        self.passedTimeSinceShoot = 0
        guard isTouched else { return }
        fighter.shoot(withBullet: bullet, by: fighter, onScene: self)
    }
    
    func checkHit() {
        let bullets = self.children.filter({ $0.name == "bullet" })
        for bullet in bullets {
            let nodes = self.nodes(at: bullet.position)
            let aliens = nodes.filter({ $0.name == "alien" })
            if let hitAlien = aliens.first as? Alien {
                hitAlien.blowUp()
                bullet.removeFromParent()
                guard hitAlien is ShootingAlien else { continue }
                dropShootingAliens(alien: hitAlien as! ShootingAlien)
            }
        }
    }
    
    private func dropShootingAliens(alien: ShootingAlien) {
        guard shootingAliens.contains(alien) else { return }
        shootingAliens.remove(at: shootingAliens.index(of: alien)!)
    }
    
    func checkAlienAttack() {
        guard self.passedTimeSinceAlienAttack > 2 else { return }
        self.passedTimeSinceAlienAttack = 0
        let attackingAlien = superAliens.randomItem()
        attackingAlien.attack()
    }
    
    func checkSuperAliens() {
        let bottomBoundery = -self.size.height/2
        for (index,alien) in superAliens.enumerated().reversed() {
            guard alien.position.y < bottomBoundery else { continue }
            superAliens.remove(at: index)
            alien.removeFromParent()
        }
    }
    
    func checkAlienShoot() {
        guard !shootingAliens.isEmpty else { return }
        guard self.passedTimeSinceAlienShoot > 5 else { return }
        self.passedTimeSinceAlienShoot = 0
        let shootingAlien = shootingAliens.randomItem()
        shootingAlien.shoot(withBullet: aliensBullet, by: shootingAlien, onScene: self)
    }
    
    func checkAliensExist() {
        let aliensCount = self.children.filter({ $0.name == "alien" }).count
        guard aliensCount == 0 else { return }
        self.addChild(winnerLabel)
        self.isPaused = true
    }
    
}
