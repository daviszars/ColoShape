//
//  GameScene.swift
//  ColoShape
//
//  Created by Davis Zarins on 21/10/2020.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    struct PhysicsCategory {
        static let none      : UInt32 = 0
        static let all       : UInt32 = UInt32.max
        static let shape   : UInt32 = 0b1
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.darkGray
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addShape),
                SKAction.wait(forDuration: 0.5)
            ])
        ))
    }
    
    func addShape() {
        let colors = ColoShape.colors.randomElement()!
        let shapes = ColoShape.shapes.randomElement()!
        
        let shapeConfig = UIImage.SymbolConfiguration(weight: .heavy)
        let image = UIImage(systemName: shapes, withConfiguration: shapeConfig)!.withTintColor(colors)
        let data = image.pngData()!
        let newImage = UIImage(data:data)!
        let texture = SKTexture(image: newImage)
        let shape = SKSpriteNode(texture: texture,size: CGSize(width: 120, height: 120))
        shape.isUserInteractionEnabled = false
        shape.name = shapes
        
        let sectorsX = [size.width * 0.2, size.width * 0.4, size.width * 0.6, size.width * 0.8]
        let actualX = sectorsX.randomElement()
        shape.position = CGPoint(x: actualX!, y: size.height + shape.size.height/2)
        
        addChild(shape)
        
        let actionMove = SKAction.move(to: CGPoint(x: actualX!, y: -shape.size.height/2),
                                       duration: TimeInterval(CGFloat(2.5)))
        let actionMoveDone = SKAction.removeFromParent()
        shape.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first as UITouch?
        let touchedNode = atPoint((touch?.location(in: self))!)
        if touchedNode.name == "circle" {
            touchedNode.removeFromParent()
        }
    }
}
