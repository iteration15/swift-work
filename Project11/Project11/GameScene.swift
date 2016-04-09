//
//  GameScene.swift
//  Project11
//
//  Created by Kuhta, Dean on 4/9/16.
//  Copyright (c) 2016 Dean Kuhta. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .Replace
        background.zPosition = -1
        addChild(background)
        
        physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
        
        makeSlotAt(CGPoint(x: 384, y: 0), isGood: true)
        
        makeBouncerAt(CGPoint(x: 512, y: 0))
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.locationInNode(self)
            
            let ball = SKSpriteNode(imageNamed: "ballRed")
            ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
            ball.physicsBody!.restitution = 0.4
            ball.position = location
            ball.name = "ball"
            addChild(ball)
        }
       
    }
    
    func makeBouncerAt(position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
        bouncer.physicsBody!.dynamic = false
        addChild(bouncer)
    }
    
    func makeSlotAt(position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        
        slotBase.position = position
        slotGlow.position = position
        
        slotBase.physicsBody = SKPhysicsBody(rectangleOfSize: slotBase.size)
        slotBase.physicsBody!.dynamic = false
        
        addChild(slotBase)
        addChild(slotGlow)
        
        let spin = SKAction.rotateByAngle(CGFloat(M_PI_2), duration: 10)
        let spinForever = SKAction.repeatActionForever(spin)
        slotGlow.runAction(spinForever)
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
