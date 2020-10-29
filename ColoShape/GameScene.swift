//
//  GameScene.swift
//  ColoShape
//
//  Created by Davis Zarins on 21/10/2020.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var targetColor: UIColor? = nil
    var targetShape: String? = nil
    var score = 0
    var scoreLabel = SKLabelNode()
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.white
        
        scoreLabel.text = ("Score: \(score)")
        scoreLabel.fontSize = 20
        scoreLabel.fontColor = SKColor.black
        scoreLabel.position = CGPoint(x: size.width - 50, y: size.height - 50)
        addChild(scoreLabel)
        
        targetColor = ColoShape.colors.randomElement()
        targetShape = ColoShape.shapes.randomElement()
        
        let shapeConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .black, scale: .large)
        let image = UIImage(systemName: targetShape!, withConfiguration: shapeConfig)!.withTintColor(targetColor!)
        let data = image.pngData()!
        let newImage = UIImage(data:data)!
        let texture = SKTexture(image: newImage)
        let targetColoShape = SKSpriteNode(texture: texture, size: CGSize(width: 120, height: 120))
        targetColoShape.position = CGPoint(x: size.width / 2, y: size.height / 2)
        targetColoShape.alpha = 0.0
        addChild(targetColoShape)
        
        let fadeIn = SKAction.fadeIn(withDuration: 2.5)
        let fadeOut = SKAction.fadeOut(withDuration: 2.5)
        let addShapes = SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addShape),
                SKAction.wait(forDuration: 0.8)
            ])
        )
        let sequence = SKAction.sequence([fadeIn, fadeOut, addShapes])
        targetColoShape.run(sequence)
    }
    
    func addShape() {
        let colors = ColoShape.colors.randomElement()!
        let shapes = ColoShape.shapes.randomElement()!
        
        let shapeConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .black, scale: .large)
        let image = UIImage(systemName: shapes, withConfiguration: shapeConfig)!.withTintColor(colors)
        let data = image.pngData()!
        let newImage = UIImage(data:data)!
        let texture = SKTexture(image: newImage)
        let shape = SKSpriteNode(texture: texture, size: CGSize(width: 120, height: 120))
        shape.isUserInteractionEnabled = false
        let startingX = [size.width * 0.2, size.width * 0.3, size.width * 0.4, size.width * 0.5, size.width * 0.6, size.width * 0.7, size.width * 0.8].randomElement()
        shape.position = CGPoint(x: startingX!, y: size.height + shape.size.height/2)
        if targetShape == shapes || targetColor == colors {
            shape.name = "good"
        } else {
            shape.name = "bad"
        }
        addChild(shape)
        
        let actionMove = SKAction.move(to: CGPoint(x: startingX!, y: +shape.size.height/2),
                                       duration: TimeInterval(CGFloat(2.5)))
        let actionMoveDone = SKAction.removeFromParent()
        shape.run(SKAction.sequence([actionMove, actionMoveDone])) {
            if shape.name == "good"{
                self.gameOver()
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if (atPoint(location).name == "good") {
                atPoint(location).removeFromParent()
                score += 1
                scoreLabel.text = "Score: \(score)"
            } else if atPoint(location).name == "bad" {
                gameOver()
            }
        }
    }
    
    func gameOver() {
        let reveal = SKTransition.fade(withDuration: 1.0)
        let gameOverScene = GameOverScene(size: view!.bounds.size, score: score)
        self.view?.presentScene(gameOverScene, transition: reveal)
    }
    
}
