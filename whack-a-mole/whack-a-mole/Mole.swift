import SpriteKit

class Mole: SKSpriteNode, GameSprite {
    // We will store our size, texture atlas, and animations
    // as class wide properties.
    var textureAtlas:SKTextureAtlas = SKTextureAtlas(named: "Moles")
    var block: Bool = false
    var happy: Bool = true
    
    init() {
        let startTexture = textureAtlas.textureNamed("happy_mole")
        super.init(texture: startTexture, color: .clear,
                   size: CGSize(width: 80, height: 100))
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width*0.9, height: self.size.height*0.9))
        self.physicsBody?.affectedByGravity = false
    }
    
    func popUp() {
        if block == false {
            block = true
            if Int(arc4random_uniform(2)) == 0 {
                turnAngry()
            } else {
                turnHappy()
            }
            let action1 = SKAction.moveBy(x: 0, y: 100, duration: 0.5)
            let action2 = SKAction.moveBy(x: 0, y: -100, duration: 0.5)
            let t = TimeInterval(arc4random_uniform(3)) + 0.2
            let action3 = SKAction.wait(forDuration: t)
            let actionSequence = SKAction.sequence([action1, action2, action3])
            self.run(actionSequence, completion: {self.block = false})
        }
    }
    
    func turnHappy() {
        self.texture = textureAtlas.textureNamed("happy_mole")
        happy = true
    }
    
    func turnAngry() {
        self.texture = textureAtlas.textureNamed("angry_mole")
        happy = false
    }

    
    func onTap() {}
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
