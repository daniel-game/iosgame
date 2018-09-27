//
//  GameScene.swift
//  SpriteDance
//
//  Created by Daniel Ng on 9/5/18.
//  Copyright © 2018 Personal. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var dog: SKSpriteNode!
    var ground: [SKSpriteNode] = [SKSpriteNode]()
    var cnt = 0
    var dogIsTired = false
    var dogSpeed = 0
    var numScroll = 100
    override func didMove(to view: SKView) {
        self.anchorPoint = .zero

        let dogAtlas = SKTextureAtlas(named: "dog")
        let dogIdle1 = dogAtlas.textureNamed("Idle (1)")
        dog = SKSpriteNode(texture: dogIdle1)
        dog.anchorPoint = .zero
        dog.position = CGPoint(x: self.size.width*0.3, y: self.size.height*0.1)
        addChild(dog)
        dog.run(SKAction.scale(by: 0.3, duration: 0.0))
        
        let groundAtlas = SKTextureAtlas(named: "background")
        let groundTexture = groundAtlas.textureNamed("desert_BG")
        for i in 0 ... 1 {
            ground.append(SKSpriteNode(texture: groundTexture))
            ground[i].anchorPoint = .zero
            ground[i].size = self.size
            ground[i].position = CGPoint(x: CGFloat(i)*(self.size.width), y: 0.0)
            ground[i].zPosition = -10
            addChild(ground[i])
        }
        
        let dogIdle2 = dogAtlas.textureNamed("Idle (2)")
        let dogIdle3 = dogAtlas.textureNamed("Idle (3)")
        let dogIdle4 = dogAtlas.textureNamed("Idle (4)")
        let dogIdle5 = dogAtlas.textureNamed("Idle (5)")
        let dogIdle6 = dogAtlas.textureNamed("Idle (6)")
        let dogIdle7 = dogAtlas.textureNamed("Idle (7)")
        let dogIdle8 = dogAtlas.textureNamed("Idle (8)")
        let dogIdle9 = dogAtlas.textureNamed("Idle (9)")
        let dogIdle10 = dogAtlas.textureNamed("Idle (10)")
        let dogIdleSequence = [dogIdle1, dogIdle2, dogIdle3, dogIdle4, dogIdle5, dogIdle6, dogIdle7, dogIdle8, dogIdle9, dogIdle10]
        let dogIdleAction = SKAction.animate(with: dogIdleSequence, timePerFrame: 1.0/10)

        var dogRunSequence: [SKTexture] = [SKTexture]()
        for i in 1...8 {
            dogRunSequence.append(dogAtlas.textureNamed("Run (" + String(i) + ")"))
        }
        let dogRunAction = SKAction.animate(with: dogRunSequence, timePerFrame: 1.0/8)
        let dogRunFasterAction = SKAction.animate(with: dogRunSequence, timePerFrame: 0.5/8)
        let dogRunFastestAction = SKAction.animate(with: dogRunSequence, timePerFrame: 0.2/8)
        
        var dogHurtSequence: [SKTexture] = [SKTexture]()
        for i in 1...10 {
            dogHurtSequence.append(dogAtlas.textureNamed("Hurt (" + String(i) + ")"))
        }
        let dogHurtAction = SKAction.animate(with: dogHurtSequence, timePerFrame: 0.5/10)
        
        let dogRun = SKAction.repeat(dogRunAction, count: 2)
        let dogRunFaster = SKAction.repeat(dogRunFasterAction, count: 4)
        let dogRunFastest = SKAction.repeat(dogRunFastestAction, count: 10)
        let dogHurt = SKAction.repeat(dogHurtAction, count: 2)
        
        let label = SKLabelNode(text: "Welcome to IOS Appventure Club!")
        label.fontName = "Chalkduster"
        label.fontSize = 28
        label.fontColor = UIColor.green
        label.position = CGPoint(x: self.size.width/2, y: self.size.height*1.5)
        addChild(label)
        let moveLabel = SKAction.move(to: CGPoint(x: self.size.width/2, y: self.size.height/2), duration: 0.5)
        let bigLabel = SKAction.scale(by: 2.0, duration: 0.5)
        let smallLabel = SKAction.scale(by: 0.5, duration: 0.5)
        let scaleAction = SKAction.repeat(SKAction.sequence([bigLabel, smallLabel]), count: 3)
        let labelAction = SKAction.sequence([moveLabel, scaleAction])

        dog.run(dogIdleAction, completion: {
            self.dogSpeed = 1
            self.dog.run(dogRun, completion: {
                self.dogSpeed = 2
                self.dog.run(dogRunFaster, completion: {
                    self.dogSpeed = 3
                    self.dog.run(dogRunFastest, completion: {
                        self.dogIsTired = true
                        self.dog.run(dogHurt, completion: {
                            label.run(labelAction)
                        })
                    })
                })
            })
        })
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if dogSpeed > 0 && dogIsTired == false {
            if dogSpeed == 1 {
                numScroll = 180
            } else if dogSpeed == 2 {
                numScroll = 120
            } else if dogSpeed == 3 {
                numScroll = 60
            }
            cnt = (cnt + 1) % numScroll
            for i in 0 ... 1 {
                let moveLeft = SKAction.move(to: CGPoint(x: CGFloat(i*numScroll-cnt)/CGFloat(numScroll)*self.size.width, y: 0.0), duration: 0.0)
                ground[i].run(moveLeft)
            }
        }
    }
}
