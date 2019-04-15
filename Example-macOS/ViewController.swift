
import Cocoa
import SpriteKit

class ViewController: NSViewController {
    @IBOutlet var skView: SKView!
    @IBOutlet var popUpButton: NSPopUpButton!
    fileprivate var skScene: SKScene!

    let tileCache = TextureCache(atlasNamed: "RoundedCornerTile.atlas")

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let view = self.skView else { return }

        view.ignoresSiblingOrder = true
        view.showsFPS = true
        view.showsNodeCount = true

        // Load the SKScene from 'GameScene.sks'
        if let scene = SKScene(fileNamed: "GameScene") {
            skScene = scene
            scene.scaleMode = SKSceneScaleMode.aspectFit
            view.presentScene(scene)

            tileCache.load { [weak self] in
                guard let self = self else { return }
                self.createMap(scene: scene, tiles: self.tiles)
            }
        }
    }

    let tiles = [
        [0, 0, 1, 1, 1, 1, 1, 0, 0],
        [0, 1, 1, 1, 1, 1, 1, 1, 0],
        [1, 1, 1, 1, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 0, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 1, 1, 1, 1],
        [0, 1, 1, 1, 1, 1, 1, 1, 0],
        [0, 0, 1, 1, 1, 1, 1, 0, 0],
    ]

    let strange = [
        [0, 0, 0, 0, 1, 1, 1, 1, 1],
        [0, 1, 0, 0, 1, 1, 1, 1, 1],
        [0, 0, 0, 0, 0, 0, 1, 1, 1],
        [0, 1, 0, 0, 1, 0, 0, 1, 1],
        [0, 0, 1, 1, 0, 1, 0, 1, 1],
        [1, 1, 0, 0, 1, 0, 1, 1, 1],
        [1, 1, 1, 1, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 0, 1, 1, 1],
        [1, 1, 1, 1, 1, 1, 1, 1, 1],
    ]

    @IBAction func displaySample(_ sender: NSMenuItem) {
        let idx = sender.menu!.index(of: sender)

        switch idx {
        case 0:
            createMap(scene: skScene, tiles: tiles)
        default:
            createMap(scene: skScene, tiles: strange)
        }

        popUpButton.selectItem(at: idx)
    }

    @IBAction func popUpButton(_ sender: NSPopUpButton) {
        displaySample(sender.selectedItem!)
    }

    func createMap(scene: SKScene, tiles: [[Int]]) {
        var grid = Array2D<Any>(columns: 9, rows: 9)
        
        for (row, rowArray) in tiles.enumerated() {
            let cellRow = 9 - row - 1
            for (column, value) in rowArray.enumerated() {
                grid[column, cellRow] = (value == 0 ? nil : 1)
            }
        }
        
        let tileSet: SKTileSet
        
        do {
            tileSet = try RoundedCornerTileSet.create(textures: tileCache)
        }
        catch {
            print(error)
            return
        }
        
        scene.removeAllChildren()
        if let map = RoundedCornerTileMapNode.create(tileSet: tileSet, grid: grid) {
            scene.addChild(map)
        }
    }
}

extension ViewController: NSMenuItemValidation {
    func validateMenuItem(_: NSMenuItem) -> Bool { return true }
}
