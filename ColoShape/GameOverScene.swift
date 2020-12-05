//
//  GameOverScene.swift
//  ColoShape
//
//  Created by Davis Zarins on 26/10/2020.
//

import SpriteKit
import GameplayKit
import SwiftConfettiView

class GameOverScene: SKScene {
    
    var difficulty: Int = 0
    var score: Int = 0
    let defaults = UserDefaults.standard
    var confettiView: SwiftConfettiView? = nil
    
    override func didMove(to view: SKView) {
        backgroundColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        
        confettiView = SwiftConfettiView(frame: self.view!.bounds)
        self.view!.addSubview(confettiView!)
        
        switch difficulty {
        case 0:
            if score > defaults.integer(forKey: "EasyHS") {
                defaults.set(score, forKey: "EasyHS")
                confettiView!.startConfetti()
            }
        case 1:
            if score > defaults.integer(forKey: "MediumHS") {
                defaults.set(score, forKey: "MediumHS")
                confettiView!.startConfetti()
            }
        default:
            if score > defaults.integer(forKey: "HardHS") {
                defaults.set(score, forKey: "HardHS")
                confettiView!.startConfetti()
            }
        }
        
        let scoreLabel = SKLabelNode(fontNamed: "Comfortaa-Regular")
        if confettiView!.isActive() {
            scoreLabel.text = "NEW High Score: \(score)"
        } else {
            scoreLabel.text = "Score: \(score)"
        }
        scoreLabel.fontSize = 27
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height / 1.5)
        addChild(scoreLabel)
        
        let tryAgainButton = SKLabelNode(fontNamed: "Comfortaa-Regular")
        tryAgainButton.name = "tryAgain"
        tryAgainButton.text = "Try Again"
        tryAgainButton.fontSize = 25
        tryAgainButton.fontColor = SKColor.white
        tryAgainButton.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(tryAgainButton)
        
        let mainMenuButton = SKLabelNode(fontNamed: "Comfortaa-Regular")
        mainMenuButton.name = "mainMenu"
        mainMenuButton.text = "Main Menu"
        mainMenuButton.fontSize = 20
        mainMenuButton.fontColor = SKColor.white
        mainMenuButton.position = CGPoint(x: size.width / 2, y: size.height / 2.6)
        addChild(mainMenuButton)
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if (atPoint(location).name == "tryAgain") {
                confettiView?.stopConfetti()
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
