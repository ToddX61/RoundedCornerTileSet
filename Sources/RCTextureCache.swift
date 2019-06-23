
import SpriteKit

public class RCTextureCache {
    fileprivate let _atlasNamed: String
    fileprivate var _textures = [String: SKTexture]()
    fileprivate var _atlas: SKTextureAtlas?
    fileprivate var _isIOS9 = false

    public init(atlasNamed: String) {
        _atlasNamed = atlasNamed

        #if os(iOS)
        if ProcessInfo().isOperatingSystemAtLeast(OperatingSystemVersion(majorVersion: 9, minorVersion: 0, patchVersion: 0)) {
                _isIOS9 = true
            }
        #endif
    }

    public var loaded: Bool { return _atlas != nil }

    public func load(completionHandler: @escaping () -> Void) {
        guard loaded == false else { return }
        
        let atlas = SKTextureAtlas(named: _atlasNamed)
        atlas.preload { completionHandler() }
        _atlas = atlas
    }

    public func unload() {
        _textures.removeAll(keepingCapacity: true)
        _atlas = nil
    }

    public subscript(named: String) -> SKTexture! {
        guard loaded else { return nil }

        if _isIOS9 {
            return _atlas?.textureNamed(named)
        }
        else {
            return _atlas?.textureNamed(named + ".png")
        }
    }

    public func create(_ spriteName: String) -> SKSpriteNode {
        return SKSpriteNode(texture: self[spriteName])
    }
}
