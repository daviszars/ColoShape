//
//  GameOverScene.swift
//  ColoShape
//
//  Created by Davis Zarins on 26/10/2020.
//

import SpriteKit
import GameplayKit

class GameOverScene: SKScene {
  init(size: CGSize, score: Int) {
    super.init(size: size)
    
    // 1
    backgroundColor = SKColor.white
    
    // 2
    let message = "Score: \(score)"
    
    // 3
    let label = SKLabelNode(fontNamed: "Chalkduster")
    label.text = message
    label.fontSize = 40
    label.fontColor = SKColor.black
    label.position = CGPoint(x: size.width/2, y: size.height/2)
    addChild(label)
    
    // 4
    run(SKAction.sequence([
      SKAction.wait(forDuration: 3.0),
      SKAction.run() { [weak self] in
        // 5
        guard let `self` = self else { return }
        let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
        let scene = GameScene(size: size)
        self.view?.presentScene(scene, transition:reveal)
      }
      ]))
   }
  
  // 6
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
