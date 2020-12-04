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
    var targetNumber: String? = nil
    var score: Int = 0
    var scoreLabel = SKLabelNode()
    var difficulty: Int = 0
    var counter: Int = 0
    var badCounter: Int = 0
    let rand: [Int] = [1, 2, 3]
    var moveSpeed: Float = 4.0
    var testMode: Bool = false
    let defaults = UserDefaults.standard
    let gameOverSound = SKAction.playSoundFileNamed("gameOver.m4a", waitForCompletion: false)
    let tickSound = SKAction.playSoundFileNamed("impact.m4a", waitForCompletion: false)
    
    //MARK: makeShape()
    func makeShape(shape: String, color: UIColor, number: String) -> SKSpriteNode {
        let shapeConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .heavy, scale: .large)
        let image = UIImage(systemName: shape, withConfiguration: shapeConfig)!.withTintColor(color)
        let data = image.pngData()!
        let newImage = UIImage(data:data)!
        let texture = SKTexture(image: newImage)
        let shapeSize = size.height * 0.15
        let targetColoShape = SKSpriteNode(texture: texture, size: CGSize(width: shapeSize, height: shapeSize))
        
        let numberLabel = SKLabelNode(fontNamed: "Helvetica")
        numberLabel.text = number
        numberLabel.fontSize = 35
        numberLabel.fontColor = color
        numberLabel.position = CGPoint(x: -3, y: -12)
        numberLabel.zPosition = -1
        targetColoShape.addChild(numberLabel)
        
        return targetColoShape
    }
    
    //MARK: didMove(to view)
    override func didMove(to view: SKView) {
        
        backgroundColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        
        scoreLabel.text = ("Score: \(score)")
        scoreLabel.fontSize = 20
        scoreLabel.fontColor = SKColor.lightGray
        scoreLabel.position = CGPoint(x: size.width - 50, y: size.height - 50)
        addChild(scoreLabel)
        
        if difficulty == 0 {
            targetColor = UIColor.lightGray
            targetShape = ColoShape.shapes.randomElement()
            targetNumber = ""
        } else if difficulty == 1 {
            targetColor = ColoShape.colors.randomElement()
            targetShape = ColoShape.shapes.randomElement()
            targetNumber = ""
        } else if difficulty == 2 {
            targetColor = ColoShape.colors.randomElement()
            targetShape = ColoShape.shapes.randomElement()
            targetNumber = ColoShape.numbers.randomElement()
        }
        
        
        let targetColoShape = makeShape(shape: targetShape!, color: targetColor!, number: targetNumber!)
        targetColoShape.position = CGPoint(x: size.width / 2, y: size.height / 2)
        targetColoShape.alpha = 0.0
        addChild(targetColoShape)
        
        var waitDuration: Double
        switch difficulty {
        case 0:
            waitDuration = 0.7
        case 1:
            waitDuration = 0.8
        case 2:
            waitDuration = 0.9
        default:
            waitDuration = 0.8
        }
        
        let fadeIn = SKAction.fadeIn(withDuration: 1.0)
        let fadeOut = SKAction.fadeOut(withDuration: 1.0)
        let addShapes = SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addShape),
                SKAction.wait(forDuration: waitDuration)
            ])
        )
        let sequence = SKAction.sequence([fadeIn, fadeOut, addShapes])
        targetColoShape.run(sequence)
    }
    
    //MARK: addShape()
    func addShape() {
        counter+=1
        let chance = rand.randomElement()
        var colors: UIColor? = nil
        var shapes: String? = nil
        var numbers: String? = nil
        
        switch difficulty {
        case 0:
            colors = UIColor.lightGray
            shapes = ColoShape.shapes.randomElement()!
            numbers = ""
            //33% chance of target shape
            if counter % 2 == 0 && chance == 1 {
                shapes = targetShape
            }
            if badCounter == 5 {
                shapes = targetShape
            }
        case 1:
            colors = ColoShape.colors.randomElement()!
            shapes = ColoShape.shapes.randomElement()!
            numbers = ""
            if counter % 2 == 0 && chance == 1 {
                shapes = targetShape
            } else if counter % 3 == 0 && chance == 1 {
                colors = targetColor
            }
            if badCounter == 5 {
                switch chance {
                case 1:
                    shapes = targetShape
                case 2:
                    colors = targetColor
                case 3:
                    shapes = targetShape
                    colors = targetColor
                default:
                    shapes = targetShape
                    colors = targetColor
                }
            }
        case 2:
            colors = ColoShape.colors.randomElement()!
            shapes = ColoShape.shapes.randomElement()!
            numbers = ColoShape.numbers.randomElement()!
        default:
            let tempNode: SKNode? = nil
            gameOver(node: tempNode!)
        }
        
        if counter == 5 {
            moveSpeed*=0.95
        } else if counter == 10 {
            moveSpeed*=0.95
        }
        
        let shape = makeShape(shape: shapes!, color: colors!, number: numbers!)
        shape.isUserInteractionEnabled = false
        let startingX = CGFloat.random(in: size.width*0.15 ... size.width*0.85)
        shape.position = CGPoint(x: startingX, y: size.height + shape.size.height/2)
        
        if targetShape == shapes || (difficulty != 0 && targetColor == colors) || (difficulty == 2 && targetNumber == numbers) {
            shape.name = "good"
            badCounter = 0
        } else {
            shape.name = "bad"
            badCounter+=1
        }
        addChild(shape)
        
        let actionMove = SKAction.move(to: CGPoint(x: startingX, y: -shape.size.height/2),
                                       duration: TimeInterval(CGFloat(moveSpeed)))
        let actionMoveDone = SKAction.removeFromParent()
        shape.run(SKAction.sequence([actionMove, actionMoveDone]))
        //        {
        //            if shape.name == "good"{
        //                self.gameOver()
        //            }
        //        }
    }
    
    //MARK: update()
    override func update(_ currentTime: TimeInterval) {
        if testMode == false {
            if case let shape as SKSpriteNode = self.childNode(withName: "good") {
                if shape.position.y <= shape.size.height/2 {
                    self.gameOver(node: shape)
                }
            }
        }
    }
    
    //MARK: touchesBegan()
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if testMode == false {
                let location = touch.location(in: self)
                if (atPoint(location).name == "good") {
                    if defaults.bool(forKey: "Vibration") {
                        let generator = UIImpactFeedbackGenerator(style: .light)
                        generator.impactOccurred()
                    }
                    if defaults.bool(forKey: "Sound") {
                        run(tickSound)
                    }
                    atPoint(location).removeFromParent()
                    score += 1
                    scoreLabel.text = "Score: \(score)"
                } else if atPoint(location).name == "bad" {
                    gameOver(node: atPoint(location))
                }
            }
        }
    }
    
    //MARK: gameOver()
    func gameOver(node: SKNode) {
        if defaults.bool(forKey: "Sound") {
            run(gameOverSound)
        }
        node.run(SKAction.fadeOut(withDuration: 0.0)) { [self] in
            if self.defaults.bool(forKey: "Vibration") {
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.error)
            }
//            if self.defaults.bool(forKey: "Sound") {
//                run(gameOverSound)
//            }
            let reveal = SKTransition.fade(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: self.view!.bounds.size)
            gameOverScene.difficulty = self.difficulty
            gameOverScene.score = self.score
            self.view?.presentScene(gameOverScene, transition: reveal)
        }
    }
    
}
