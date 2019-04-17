//
//  GameViewController.swift
//  Example-iOS
//
//  Created by Todd Denlinger on 4/17/19.
//  Copyright © 2019 Todd. All rights reserved.
//

import GameplayKit
import SpriteKit
import UIKit

class GameViewController: UIViewController {
    enum SampleTiles: Int, CaseIterable {
        case normal = 0, strange = 2
    }

    private var selected: SampleTiles = .normal
    private var skScene: SKScene!

    let tileCache = TextureCache(atlasNamed: "RoundedCornerTile.atlas")
    let TileMapNodeName = "TileMapNode"
    
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
    override func viewDidLoad() {
        super.viewDidLoad()

        if let view = self.view as! SKView? {
            if let scene = SKScene(fileNamed: "GameScene") as? GameScene {
                scene.scaleMode = .aspectFill
                scene.gameSceneDelegate = self
                skScene = scene
                view.presentScene(scene)
                tileCache.load { [weak self] in
                    guard let self = self else { return }
                    self.createMap(scene: scene, tiles: self.tiles)
                }
            }

            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return false
    }

    func displaySample() {
        switch selected {
        case .normal:
            createMap(scene: skScene, tiles: strange)
            selected = .strange
        case .strange:
            createMap(scene: skScene, tiles: tiles)
            selected = .normal
        }
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
        } catch {
            print(error)
            return
        }

        if let node = scene.childNode(withName: TileMapNodeName) {
            scene.removeChildren(in: [node])
        }
        
        if let map = RoundedCornerTileMapNode.create(tileSet: tileSet, grid: grid) {
            map.name = TileMapNodeName
            scene.addChild(map)
        }
    }
}

extension GameViewController: GameSceneDelegate {
    func touch() {
        displaySample()
    }
}
