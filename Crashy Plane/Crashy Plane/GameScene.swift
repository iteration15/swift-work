//
//  GameScene.swift
//  Crashy Plane
//
//  Created by Kuhta, Dean on 4/9/16.
//  Copyright (c) 2016 Dean Kuhta. All rights reserved.
//

import GameplayKit
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player: SKSpriteNode!
    
    override func didMoveToView(view: SKView) {
        
        createPlayer()
        createSky()
        createBackground()
        createGround()
        //initRocks()
        
        physicsWorld.gravity = CGVectorMake(0.0, -5.0)
        physicsWorld.contactDelegate = self
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        player.physicsBody?.velocity = CGVectorMake(0, 0)
        player.physicsBody?.applyImpulse(CGVectorMake(0, 20))
       
    }
   
    override func update(currentTime: CFTimeInterval) {
        let value = player.physicsBody!.velocity.dy * 0.001
        let rotate = SKAction.rotateByAngle(value, duration: 0.1)
        player.runAction(rotate)
    }
    
    func createPlayer() {
        let playerTexture = SKTexture(imageNamed: "player-1")
        player = SKSpriteNode(texture: playerTexture)
        player.zPosition = 10
        player.position = CGPoint(x: frame.width / 6, y: frame.height * 0.75)
        
        addChild(player)
        
        player.physicsBody = SKPhysicsBody(texture: playerTexture, size: playerTexture.size())
        player.physicsBody!.contactTestBitMask = player.physicsBody!.collisionBitMask
        player.physicsBody?.dynamic = true
        
        player.physicsBody?.collisionBitMask = 0
        
        let frame2 = SKTexture(imageNamed: "player-2")
        let frame3 = SKTexture(imageNamed: "player-3")
        let animation = SKAction.animateWithTextures([playerTexture, frame2, frame3, frame2], timePerFrame: 0.01)
        let runForever = SKAction.repeatActionForever(animation)
        
        player.runAction(runForever)
    }
    
    func createSky() {
        let topSky = SKSpriteNode(color: UIColor(hue: 0.55, saturation: 0.14, brightness: 0.97, alpha: 1), size: CGSize(width: frame.width, height: frame.height * 0.67))
        topSky.anchorPoint = CGPoint(x: 0.5, y: 1)
        
        let bottomSky = SKSpriteNode(color: UIColor(hue: 0.55, saturation: 0.16, brightness: 0.96, alpha: 1), size: CGSize(width: frame.width, height: frame.height * 0.33))
        topSky.anchorPoint = CGPoint(x: 0.5, y: 1)
        
        topSky.position = CGPoint(x: CGRectGetMidX(frame), y: frame.size.height)
        bottomSky.position = CGPoint(x: CGRectGetMidX(frame), y: bottomSky.frame.height / 2)
        
        addChild(topSky)
        addChild(bottomSky)
        
        bottomSky.zPosition = -40
        topSky.zPosition = -40
    }
    
    func createBackground() {
        let backgroundTexture = SKTexture(imageNamed: "background")
        
        for i in 0 ... 1 {
            let background = SKSpriteNode(texture: backgroundTexture)
            background.zPosition = -30
            background.anchorPoint = CGPointZero
            background.position = CGPoint(x: (backgroundTexture.size().width * CGFloat(i)) - CGFloat(1 * i), y: 100)
            
            let moveLeft = SKAction.moveByX(-backgroundTexture.size().width, y: 0, duration: 20)
            let moveReset = SKAction.moveByX(backgroundTexture.size().width, y: 0, duration: 0)
            let moveLoop = SKAction.sequence([moveLeft, moveReset])
            let moveForever = SKAction.repeatActionForever(moveLoop)
            
            background.runAction(moveForever)
            
            addChild(background)
        }
    }
    
    func createGround() {
        let groundTexture = SKTexture(imageNamed: "ground")
        
        for i in 0 ... 1 {
            let ground = SKSpriteNode(texture: groundTexture)
            ground.zPosition = -10
            ground.position = CGPoint(x: (groundTexture.size().width / 2.0 + (groundTexture.size().width * CGFloat(i))), y: groundTexture.size().height / 2)
            
            ground.physicsBody = SKPhysicsBody(texture: ground.texture!, size: ground.texture!.size())
            ground.physicsBody?.dynamic = false
            
            addChild(ground)
            
            let moveLeft = SKAction.moveByX(-groundTexture.size().width, y: 0, duration: 5)
            let moveReset = SKAction.moveByX(groundTexture.size().width, y: 0, duration: 0)
            let moveLoop = SKAction.sequence([moveLeft, moveReset])
            let moveForever = SKAction.repeatActionForever(moveLoop)
            
            ground.runAction(moveForever)
        }
    }
    
    func createRocks() {
        // 1
        let rockTexture = SKTexture(imageNamed: "rock")
        
        let topRock = SKSpriteNode(texture: rockTexture)
        topRock.physicsBody = SKPhysicsBody(texture: rockTexture, size: rockTexture.size())
        topRock.physicsBody?.dynamic = false
        
        topRock.zRotation = CGFloat(M_PI)
        topRock.xScale = -1.0
        
        let bottomRock = SKSpriteNode(texture: rockTexture)
        bottomRock.physicsBody = SKPhysicsBody(texture: rockTexture, size: rockTexture.size())
        bottomRock.physicsBody?.dynamic = false
        
        topRock.zPosition = -20
        bottomRock.zPosition = -20
        
        
        // 2
        let rockCollision = SKSpriteNode(color: UIColor.clearColor(), size: CGSize(width: 32, height: frame.height))
        rockCollision.physicsBody = SKPhysicsBody(rectangleOfSize: rockCollision.size)
        rockCollision.physicsBody?.dynamic = false
        rockCollision.name = "scoreDetect"
        
        addChild(topRock)
        addChild(bottomRock)
        addChild(rockCollision)
        
        
        // 3
        let xPosition = frame.width + topRock.frame.width
        
        let max = Int(frame.height / 3)
        let rand = GKRandomDistribution(lowestValue: -100, highestValue: max)
        let yPosition = CGFloat(rand.nextInt())
        
        // this next value affects the width of the gap between rocks
        // make it smaller to make your game harder – if you're feeling evil!
        let rockDistance: CGFloat = 70
        
        // 4
        topRock.position = CGPoint(x: xPosition, y: yPosition + topRock.size.height + rockDistance)
        bottomRock.position = CGPoint(x: xPosition, y: yPosition - rockDistance)
        rockCollision.position = CGPoint(x: xPosition + (rockCollision.size.width * 2), y: CGRectGetMidY(frame))
        
        let endPosition = frame.width + (topRock.frame.width * 2)
        
        let moveAction = SKAction.moveByX(-endPosition, y: 0, duration: 5.8)
        let moveSequence = SKAction.sequence([moveAction, SKAction.removeFromParent()])
        topRock.runAction(moveSequence)
        bottomRock.runAction(moveSequence)
        rockCollision.runAction(moveSequence)
    }
    
    func initRocks() {
        let create = SKAction.runBlock({ ()-> Void in self.createRocks()}, queue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0))
        
        let wait = SKAction.waitForDuration(3)
        let sequence = SKAction.sequence([create, wait])
        let repeatForever = SKAction.repeatActionForever(sequence)
        
        runAction(repeatForever)
    }

}