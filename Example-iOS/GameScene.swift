//
//  GameScene.swift
//  Example-iOS
//
//  Created by Todd Denlinger on 4/17/19.
//  Copyright © 2019 Todd. All rights reserved.
//

import GameplayKit
import SpriteKit

private var label: SKLabelNode?

protocol GameSceneDelegate {
    func touch()
}

class GameScene: SKScene {
    var gameSceneDelegate: GameSceneDelegate?
    private var label: SKLabelNode?

    override func didMove(to view: SKView) {
        label = childNode(withName: "//touchMeLabel") as? SKLabelNode
        if let label = self.label {
            let yPos = self.size.height * 0.5 - (label.frame.height * 2)
            label.alpha = 0.0
            label.run(SKAction.move(to: CGPoint(x: 0.0, y: yPos), duration: 0.0))
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        gameSceneDelegate?.touch()
    }
}
