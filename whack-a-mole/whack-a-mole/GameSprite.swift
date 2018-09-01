import SpriteKit

protocol GameSprite {
    var textureAtlas:SKTextureAtlas { get set }
    func onTap()
}
