//
//  GameObjectNode.swift
//  Blasty Blitz
//
//  Created by Kuhta, Dean on 4/10/16.
//  Copyright © 2016 Dean Kuhta. All rights reserved.
//

import SpriteKit

let starSound = SKAction.playSoundFileNamed("StarPing.wav", waitForCompletion: false)

enum StarType: Int {
    case Normal = 0
    case Special
}

enum PlatformType: Int {
    case Normal = 0
    case Break
}

struct CollisionCategoryBitmask {
    static let Player: UInt32 = 0x00
    static let Star: UInt32 = 0x01
    static let Platform: UInt32 = 0x02
}

class GameObjectNode: SKNode {
    func collisionWithPlayer(player: SKNode) -> Bool {
        return false
    }
    
    func checkNodeRemoval(playerY: CGFloat) {
        if playerY > self.position.y + 300.0 {
            self.removeFromParent()
        }
    }
}

class StarNode: GameObjectNode {
    var starType: StarType!
    
    override func collisionWithPlayer(player: SKNode) -> Bool {
        // Boost the player up
        player.physicsBody?.velocity = CGVector(dx: player.physicsBody!.velocity.dx, dy: 400.0)
        
        // Play sound
        runAction(starSound, completion: {
            // Remove this Star
            self.removeFromParent()
        })
        
        // Award score
        GameState.sharedInstance.score += (starType == .Normal ? 20 : 100)
        
        // The HUD needs updating to show the new stars and score
        return true
    }
}

class PlatformNode: GameObjectNode {
    var platformType: PlatformType!
    
    override func collisionWithPlayer(player: SKNode) -> Bool {
        // 1
        // Only bounce the player if he's falling
        if player.physicsBody?.velocity.dy < 0 {
            // 2
            player.physicsBody?.velocity = CGVector(dx: player.physicsBody!.velocity.dx, dy: 250.0)
            
            // 3
            // Remove if it is a Break type platform
            if platformType == .Break {
                self.removeFromParent()
            }
        }
        
        // 4
        // No stars for platforms
        return false
    }
}