
import GameplayKit
import SpriteKit

class GameScene: SKScene {
    override func didMove(to _: SKView) {}
}

// because the scene recieves mouse events (not the view), macos won't display context menu on right click (though it does for control+command clicks).
// Must handle ourselves
extension GameScene {
    override func rightMouseDown(with _: NSEvent) {
        if let context = self.view?.menu {
            context.popUp(positioning: context.item(at: 0), at: NSEvent.mouseLocation, in: nil)
        }
    }
}
