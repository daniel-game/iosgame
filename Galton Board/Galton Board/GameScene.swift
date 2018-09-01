//
//  GameScene.swift
//  Galton Board
//
//  Created by Daniel Ng on 8/28/18.
//  Copyright © 2018 Personal. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var motionManager: CMMotionManager!
    var barHeight: CGFloat!
    var barWidth: CGFloat!
    var slotWidth: CGFloat!
    var leftBar: SKShapeNode!
    var rightBar: SKShapeNode!
    var prevDir: CGFloat = -1.0
    
    override func didMove(to view: SKView) {
        self.anchorPoint = .zero
        
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
        let sideWidth = self.size.width/2
        leftBar = SKShapeNode(rectOf: CGSize(width: sideWidth, height: 10.0))
        leftBar.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: sideWidth, height: 10.0))
        rightBar = SKShapeNode(rectOf: CGSize(width: sideWidth, height: 10.0))
        rightBar.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: sideWidth, height: 10.0))
        
        let numSlot = 10
        barHeight = self.size.height*0.1
        barWidth = 10.0
        slotWidth = (self.size.width - barWidth)/CGFloat(numSlot)
        for i in 0...numSlot {
            let xPos = barWidth/2 + slotWidth * CGFloat(i)
            var height: CGFloat!
            if (i > 0 && i < numSlot) {
                height = barHeight
            } else {
                height = self.size.height
            }
            let baseSlot = SKShapeNode(rectOf: CGSize(width: barWidth, height: height))
            baseSlot.position = CGPoint(x: xPos, y: height/2)
            baseSlot.fillColor = .red
            baseSlot.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: barWidth, height: height))
            baseSlot.physicsBody?.isDynamic = false
            addChild(baseSlot)
        }
        
        let top = SKShapeNode(rectOf: CGSize(width: self.size.width, height: barWidth))
        top.position = CGPoint(x: self.size.width/2, y: self.size.height-barWidth/2)
        top.fillColor = .red
        top.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width, height: barWidth))
        top.physicsBody?.isDynamic = false
        addChild(top)
        
        let bottom = SKShapeNode(rectOf: CGSize(width: self.size.width, height: barWidth))
        bottom.position = CGPoint(x: self.size.width/2, y: barWidth/2)
        bottom.fillColor = .red
        bottom.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width, height: barWidth))
        bottom.physicsBody?.isDynamic = false
        addChild(bottom)
        
        let numLayer = 8
        let nailSpace = (self.size.width - barWidth)/CGFloat(numLayer)
        for i in 0..<numLayer-1 {
            let yPos = barHeight*2.0 + nailSpace*CGFloat(i)
            for j in 0..<(numLayer-i-1) {
                let xPos = (nailSpace/2)*CGFloat(i+2) + (nailSpace*CGFloat(j))
                let nail = SKShapeNode(circleOfRadius: 3.0)
                nail.position = CGPoint(x: xPos, y: yPos)
                nail.fillColor = .red
                nail.physicsBody = SKPhysicsBody(circleOfRadius: 3.0)
                nail.physicsBody?.isDynamic = false
                addChild(nail)
            }
        }
        
        let yPos = barHeight*2.0 + slotWidth*11.0
        var xPos = slotWidth * 2.3
        leftBar.position = CGPoint(x: xPos, y: yPos)
        leftBar.fillColor = .red
        leftBar.physicsBody?.isDynamic = false
        leftBar.zRotation = -0.45
        addChild(leftBar)
        
        xPos = self.size.width - slotWidth * 2.3
        rightBar.position = CGPoint(x: xPos, y: yPos)
        rightBar.fillColor = .red
        rightBar.physicsBody?.isDynamic = false
        rightBar.zRotation = 0.45
        addChild(rightBar)
        
        let numBall = 150
        let delay = 10.0
        for i in 0..<numBall {
            DispatchQueue.main.asyncAfter(deadline: .now() + (delay / Double(numBall) * Double(i))) { [unowned self] in self.addBall(CGPoint(x: self.size.width*0.49, y: self.size.height - 10.0)) }

        }
        
    }
    
    func addBall(_ pos : CGPoint) {
        let bean = SKShapeNode(circleOfRadius: 10.0)
        bean.position = CGPoint(x: pos.x, y: pos.y)
        bean.fillColor = .white
        bean.physicsBody = SKPhysicsBody(circleOfRadius: 10.0)
        bean.physicsBody?.restitution = 0.0
        bean.physicsBody?.linearDamping = 0.8
        bean.physicsBody?.angularDamping = 0.8
        bean.physicsBody?.friction = 0.8
        addChild(bean)
    }
    
    func touchDown(atPoint pos : CGPoint) {
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    func rotateSideBar(_ angle: CGFloat) {
        let leftRotate = SKAction.rotate(byAngle: angle, duration: 0.1)
        leftBar.run(leftRotate)
        let rightRotate = SKAction.rotate(byAngle: -angle, duration: 0.1)
        rightBar.run(rightRotate)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if let accelerometerData = motionManager.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.x * 50, dy: accelerometerData.acceleration.y * 50)
            if physicsWorld.gravity.dy > 0.0 && prevDir < 0.0  {
                self.rotateSideBar(0.9)
            } else if physicsWorld.gravity.dy < 0.0 && prevDir > 0.0 {
                self.rotateSideBar(-0.9)
            }
            prevDir = physicsWorld.gravity.dy
        }
    }
}
