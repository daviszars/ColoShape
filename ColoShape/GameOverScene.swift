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
        backgroundColor = SKColor.white
        
        let scoreLabel = SKLabelNode(fontNamed: "Helvetica")
        scoreLabel.text = "Score: \(score)"
        scoreLabel.fontSize = 40
        scoreLabel.fontColor = SKColor.black
        scoreLabel.position = CGPoint(x: size.width/2, y: size.height/1.5)
        addChild(scoreLabel)
        
        let tryAgainButton = SKLabelNode(fontNamed: "Helvetica")
        tryAgainButton.name = "tryAgain"
        tryAgainButton.text = "Try again"
        tryAgainButton.fontSize = 30
        tryAgainButton.fontColor = SKColor.black
        tryAgainButton.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(tryAgainButton)
        
        let mainMenuButton = SKLabelNode(fontNamed: "Helvetica")
        mainMenuButton.name = "mainMenu"
        mainMenuButton.text = "Main menu"
        mainMenuButton.fontSize = 25
        mainMenuButton.fontColor = SKColor.black
        mainMenuButton.position = CGPoint(x: size.width / 2, y: size.height / 2.5)
        addChild(mainMenuButton)
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if (atPoint(location).name == "tryAgain") {
                run(SKAction.sequence([
                    SKAction.wait(forDuration: 0.1),
                    SKAction.run() { [weak self] in
                        guard let `self` = self else { return }
                        let reveal = SKTransition.fade(withDuration: 0.5)
                        let scene = GameScene(size: self.size)
                        self.view?.presentScene(scene, transition:reveal)
                    }
                ]))
            } else if (atPoint(location).name == "mainMenu") {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "GameViewController")
                vc.view.frame = (self.view?.frame)!
                vc.view.layoutIfNeeded()
                UIView.transition(with: self.view!, duration: 0.0, options: .transitionCrossDissolve, animations:
                                    { self.view?.window?.rootViewController = vc }, completion: { completed in })
            }
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
