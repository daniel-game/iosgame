//
//  StartScene.swift
//  SpriteDance
//
//  Created by Daniel Ng on 9/16/18.
//  Copyright © 2018 Personal. All rights reserved.
//

import SpriteKit
import GameplayKit

class StartScene: SKScene {

    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        let myShader = SKShader(fileNamed: "myShader.fsh")
        let spriteSize = vector_float2(
            Float(background.frame.size.width),  // x
            Float(background.frame.size.height)  // y
        )
        
        myShader.uniforms = [
            SKUniform(name: "iResolution", vectorFloat2: spriteSize)
        ]
        
        background.shader = myShader
        background.zPosition = -1.0
        addChild(background)
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let scene = GameScene(fileNamed: "GameScene") {
            scene.scaleMode = SKSceneScaleMode.resizeFill
            self.view?.presentScene(scene, transition: SKTransition.flipHorizontal(withDuration: 1.0))
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

