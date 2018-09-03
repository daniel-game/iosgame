//
//  GameScene.swift
//  Space Shooter
//
//  Created by Daniel Ng on 9/1/18.
//  Copyright © 2018 Personal. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    enum CollisionTypes: UInt32 {
        case ship = 1
        case meteor = 2
        case missile = 4
    }
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var levelLabel: SKLabelNode!
    var level = 1 {
        didSet {
            levelLabel.text = "Level: \(level)"
        }
    }

    var motionManager: CMMotionManager!
    var ship: SKSpriteNode!
    let shipTexture = SKTexture(imageNamed: "ship")
    let shipLeftTexture = SKTexture(imageNamed: "ship_left1")
    let shipRightTexture = SKTexture(imageNamed: "ship_right1")
    var missileCnt = 0
    var meteorCnt = 0
    var maxMeteorOnScreen = 3
    var totalMeteor = 0
    var gameOver: SKSpriteNode!
    var backgroundMusic: SKAudioNode!

    override func didMove(to view: SKView) {
        self.anchorPoint = .zero
        
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
        physicsWorld.contactDelegate = self
        
        ship = SKSpriteNode(texture: shipTexture, size:shipTexture.size())
        ship.setScale(0.8)
        ship.position = CGPoint(x: self.size.width*0.2, y: self.size.height/2)
        ship.physicsBody = SKPhysicsBody(texture: shipTexture, size: shipTexture.size())
        ship.physicsBody?.affectedByGravity = false
        ship.physicsBody?.isDynamic = true
        ship.physicsBody?.categoryBitMask = CollisionTypes.ship.rawValue
        ship.physicsBody?.contactTestBitMask = CollisionTypes.meteor.rawValue
        ship.physicsBody?.collisionBitMask = 0
        ship.zPosition = 0.0
        ship.name = "ship"
        addChild(ship)
        
        gameOver = SKSpriteNode(imageNamed: "gameover")
        gameOver.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        gameOver.alpha = 0
        addChild(gameOver)
        
        if let musicURL = Bundle.main.url(forResource: "battle", withExtension: "mp3") {
            backgroundMusic = SKAudioNode(url: musicURL)
            addChild(backgroundMusic)
        }
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.fontSize = 24
        scoreLabel.fontColor = UIColor.cyan
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: self.size.width*0.95, y: self.size.height*0.90)
        scoreLabel.zPosition = 1.0
        addChild(scoreLabel)
        print (scoreLabel)
        
        levelLabel = SKLabelNode(fontNamed: "Chalkduster")
        levelLabel.fontSize = 24
        levelLabel.fontColor = UIColor.cyan
        levelLabel.text = "Level: 1"
        levelLabel.horizontalAlignmentMode = .right
        levelLabel.position = CGPoint(x: self.size.width*0.75, y: self.size.height*0.90)
        levelLabel.zPosition = 1.0
        addChild(levelLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if missileCnt < 8 {
            let missileTexture = SKTexture(imageNamed: "missile")
            let missile = SKSpriteNode(texture: missileTexture, size:missileTexture.size())
            missile.physicsBody = SKPhysicsBody(rectangleOf: missile.size)
            missile.physicsBody?.affectedByGravity = false
            missile.physicsBody?.isDynamic = true
            missile.physicsBody?.categoryBitMask = CollisionTypes.missile.rawValue
            missile.physicsBody?.contactTestBitMask = CollisionTypes.meteor.rawValue
            missile.physicsBody?.collisionBitMask = 0
            missile.zPosition = 0.0
            missile.name = "missile"
            missile.position = ship.position
            addChild(missile)
            missileCnt += 1
            let moveAction = SKAction.moveTo(x: self.size.width, duration: 1.0)
            let action = SKAction.sequence([moveAction, SKAction.removeFromParent()])
            missile.run(action, completion: {self.missileCnt -= 1})
            let sound = SKAction.playSoundFileNamed("laser.m4a", waitForCompletion: false)
            run(sound)
        }
    }
    
    func createMeteor() {
        let Texture: SKTexture!
        let m = arc4random_uniform(4)
        if m == 0 {
            Texture = SKTexture(imageNamed: "meteorBrown_big1")
        } else if m == 1 {
            Texture = SKTexture(imageNamed: "meteorBrown_med1")
        } else if m == 2 {
            Texture = SKTexture(imageNamed: "meteorGrey_big2")
        } else {
            Texture = SKTexture(imageNamed: "meteorGrey_med2")
        }
        let meteor = SKSpriteNode(texture: Texture, size:Texture.size())
        meteor.physicsBody = SKPhysicsBody(circleOfRadius: Texture.size().height/2)
        meteor.physicsBody?.affectedByGravity = false
        meteor.physicsBody?.isDynamic = true
        meteor.physicsBody?.categoryBitMask = CollisionTypes.meteor.rawValue
        meteor.physicsBody?.contactTestBitMask = CollisionTypes.ship.rawValue | CollisionTypes.missile.rawValue
        meteor.physicsBody?.collisionBitMask = 0
        meteor.zPosition = 0.0
        meteor.name = "meteor"
        meteor.position = CGPoint(x: self.size.width, y: CGFloat(arc4random_uniform(UInt32(self.size.height))))
        addChild(meteor)
        meteorCnt += 1
        
        var randTime = Double(arc4random_uniform(5) + 2) - Double(level)*0.3
        randTime = (randTime < 1.0) ? 1.0 : randTime
        let moveAction = SKAction.moveTo(x: 0, duration: TimeInterval(randTime))
        let rotateAction = SKAction.rotate(byAngle: 20.0, duration: randTime)
        let moveRotate = SKAction.group([moveAction, rotateAction])
        let action = SKAction.sequence([moveRotate, SKAction.removeFromParent()])
        meteor.run(action, completion: {self.meteorCnt -= 1})
        totalMeteor += 1
        if totalMeteor%25 == 0 {
            maxMeteorOnScreen += 1
            level += 1
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        let rand = arc4random_uniform(10) > 5
        if (rand && meteorCnt < maxMeteorOnScreen) {
            createMeteor()
        }
        if let accelerometerData = motionManager.accelerometerData {
            var turn: SKAction!
            var action: SKAction

            let deltaX : CGFloat!
            if accelerometerData.acceleration.y < -0.3 {
                deltaX = self.size.width * 0.05
            } else if accelerometerData.acceleration.y > 0.3 {
                deltaX = -self.size.width * 0.05
            } else {
                deltaX = 0.0
            }
            let deltaY : CGFloat!
            if accelerometerData.acceleration.x > 0.3 {
                deltaY = self.size.height * 0.05
            } else if accelerometerData.acceleration.x < -0.3 {
                deltaY = -self.size.height * 0.05
            } else {
                deltaY = 0.0
            }

            var nextPoint = CGPoint(x: ship.position.x + deltaX, y: ship.position.y + deltaY)
            if nextPoint.x < 0 {
                nextPoint.x = 0
            }
            else if nextPoint.x > self.size.width {
                nextPoint.x = self.size.width
            }
            if nextPoint.y < 0 {
                nextPoint.y = 0
            }
            else if nextPoint.y > self.size.height {
                nextPoint.y = self.size.height
            }
            let move = SKAction.move(to: nextPoint, duration: 0.05)

            if deltaY > 0.0 {
                turn = SKAction.animate(with: [shipLeftTexture], timePerFrame: 0.0)
                action = SKAction.sequence([turn, move])
            } else if deltaY < 0.0 {
                turn = SKAction.animate(with: [shipRightTexture], timePerFrame: 0.0)
                action = SKAction.sequence([turn, move])
            } else {
                action = move
            }
            ship.run(action, completion: {self.ship.texture = self.shipTexture})
        }
    }
    
    func stopGame() {
        gameOver.alpha = 1;
        backgroundMusic.run(SKAction.stop())
        ship.removeFromParent();
        speed = 0
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.node?.name == "meteor" && contact.bodyB.node?.name == "missile") || (contact.bodyB.node?.name == "meteor" && contact.bodyA.node?.name == "missile") {
            if let explosion = SKEmitterNode(fileNamed: "ExplosionParticle") {
                explosion.position = (contact.bodyA.node?.position)!
                addChild(explosion)
                let sound = SKAction.playSoundFileNamed("Explosion.wav", waitForCompletion: false)
                run(sound)
            }
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            meteorCnt -= 1
            missileCnt -= 1
            score += 1
            return
        }
        if (contact.bodyA.node?.name == "meteor" && contact.bodyB.node?.name == "ship") || (contact.bodyB.node?.name == "meteor" && contact.bodyA.node?.name == "ship") {
            if let explosion = SKEmitterNode(fileNamed: "ExplosionParticle") {
                explosion.position = (ship.position)
                addChild(explosion)
                let sound = SKAction.playSoundFileNamed("Explosion.wav", waitForCompletion: false)
                run(sound, completion: {self.stopGame()})
            }
        }
    }
}
