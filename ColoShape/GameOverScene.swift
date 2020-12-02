//
//  GameOverScene.swift
//  ColoShape
//
//  Created by Davis Zarins on 26/10/2020.
//

import SpriteKit
import GameplayKit

class GameOverScene: SKScene {
    
    var difficulty: Int = 0
    var score: Int = 0
    let defaults = UserDefaults.standard
    
    override func didMove(to view: SKView) {
        backgroundColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        
        switch difficulty {
        case 0:
            if score > defaults.integer(forKey: "EasyHS") {
                defaults.set(score, forKey: "EasyHS")
            }
        case 1:
            if score > defaults.integer(forKey: "MediumHS") {
                defaults.set(score, forKey: "MediumHS")
            }
        case 2:
            if score > defaults.integer(forKey: "HardHS") {
                defaults.set(score, forKey: "HardHS")
            }
        default:
            print("??")
        }
        
        let scoreLabel = SKLabelNode(fontNamed: "Helvetica")
        scoreLabel.text = "Score: \(score)"
        scoreLabel.fontSize = 40
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: size.width/2, y: size.height/1.5)
        addChild(scoreLabel)
        
        let tryAgainButton = SKLabelNode(fontNamed: "Helvetica")
        tryAgainButton.name = "tryAgain"
        tryAgainButton.text = "Try again"
        tryAgainButton.fontSize = 30
        tryAgainButton.fontColor = SKColor.white
        tryAgainButton.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(tryAgainButton)
        
        let mainMenuButton = SKLabelNode(fontNamed: "Helvetica")
        mainMenuButton.name = "mainMenu"
        mainMenuButton.text = "Main menu"
        mainMenuButton.fontSize = 25
        mainMenuButton.fontColor = SKColor.white
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
                        let reveal = SKTransition.fade(withDuration: 0.0)
                        let scene = GameScene(size: self.size)
                        scene.difficulty = self.difficulty
                        self.view?.presentScene(scene, transition:reveal)
                    }
                ]))
            } else if (atPoint(location).name == "mainMenu") {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "NavigationController")
                vc.view.frame = (self.view?.frame)!
                vc.view.layoutIfNeeded()
                UIView.transition(with: self.view!, duration: 0.0, options: .transitionCrossDissolve, animations:
                                    { self.view?.window?.rootViewController = vc }, completion: { completed in })
            }
        }
    }
    
}
