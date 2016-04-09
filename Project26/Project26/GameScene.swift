//
//  GameScene.swift
//  Project26
//
//  Created by Kuhta, Dean on 4/9/16.
//  Copyright (c) 2016 Dean Kuhta. All rights reserved.
//

import SpriteKit

enum CollisionTypes: UInt32 {
    case Player = 1
    case Wall = 2
    case Star = 4
    case Vortex = 8
    case Finish = 16
}

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        
        loadLevel()
        
    }
    
    func loadLevel() {
        if let levelPath = NSBundle.mainBundle().pathForResource("level1", ofType: "txt") {
            if let levelString = try? String(contentsOfFile: levelPath, usedEncoding: nil) {
                let lines = levelString.componentsSeparatedByString("\n")
                
                for (row, line) in lines.reverse().enumerate() {
                    for (column, letter) in line.characters.enumerate() {
                        let position = CGPoint(x: (64 * column) + 32, y: (64 * row) + 32)
                        
                        if letter == "x" {
                            let node = SKSpriteNode(imageNamed: "block")
                            node.position = position
                            
                            node.physicsBody = SKPhysicsBody(rectangleOfSize: node.size)
                            node.physicsBody!.categoryBitMask = CollisionTypes.Wall.rawValue
                            node.physicsBody!.dynamic = false
                            addChild(node)
                        } else if letter == "v" {
                            let node = SKSpriteNode(imageNamed: "vortex")
                            node.name = "vorex"
                            node.position = position
                            node.runAction(SKAction.repeatActionForever(SKAction.rotateByAngle(CGFloat(M_PI), duration: 1)))
                            node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
                            node.physicsBody!.dynamic = false
                            
                            node.physicsBody!.categoryBitMask = CollisionTypes.Vortex.rawValue
                            node.physicsBody!.contactTestBitMask = CollisionTypes.Player.rawValue
                            node.physicsBody!.collisionBitMask = 0
                            addChild(node)
                        } else if letter == "s" {
                            //load star
                        } else if letter == "f" {
                            //load finish
                        }
                    }
                }
            }
        }
    }

    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
}
