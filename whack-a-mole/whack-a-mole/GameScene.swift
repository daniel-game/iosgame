//
//  GameScene.swift
//  whack-a-mole
//
//  Created by Daniel Ng on 8/24/18.
//  Copyright © 2018 Personal. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    let ouchSound = SKAction.playSoundFileNamed("ouch", waitForCompletion: false)
    let coinSound = SKAction.playSoundFileNamed("coin", waitForCompletion: false)
    var moles : [Mole] = [Mole]()
    var minTouchHeight : CGFloat!
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        self.anchorPoint = .zero
        self.backgroundColor = UIColor(red: 0.4, green: 0.6, blue: 0.4, alpha: 1.0)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: self.size.width*0.95, y: self.size.height*0.90)
        addChild(scoreLabel)
        
        let initHeight = self.size.height*0.2
        // Add the ground to the scene:
        for i in 0...2 {
            let mole = Mole()
            moles.append(mole)
            moles[i].position = CGPoint(x: self.size.width*0.25*(CGFloat)(i+1), y: initHeight)
            moles[i].name = "mole" + String(i)
            self.addChild(moles[i])
            
            if i == 0 {
                minTouchHeight = initHeight + (moles[0].size.height*0.45)
            }
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {

    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        
        if let body = physicsWorld.body(at: touchLocation) {
            for i in 0...2 {
                let name = "mole" + String(i)
                if body.node!.name == name && touchLocation.y >= minTouchHeight {
                    if moles[i].happy {
                        score += 1
                        run(coinSound)
                    } else {
                        score -= 1
                        run(ouchSound)
                    }
                    moles[i].turnAngry()
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func update(_ currentTime: TimeInterval) {
        let num = Int(arc4random_uniform(3))
        moles[num].popUp()
    }
}
