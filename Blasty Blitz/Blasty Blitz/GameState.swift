//
//  GameState.swift
//  Blasty Blitz
//
//  Created by Kuhta, Dean on 4/11/16.
//  Copyright © 2016 Dean Kuhta. All rights reserved.
//

import Foundation

class GameState {
    var score: Int = 0
    var highScore: Int = 0
    var stars: Int = 0
    
    class var sharedInstance: GameState {
        struct Singleton {
            static let instance = GameState()
        }
        
        return Singleton.instance
    }
    
    init() {
        // Init
        score = 0
        highScore = 0
        stars = 0
        
        // Load game state
        let defaults = NSUserDefaults.standardUserDefaults()
        
        highScore = defaults.integerForKey("highScore")
        stars = defaults.integerForKey("stars")
    }
    
    func saveState() {
        // Update highScore if the current score is greater
        highScore = max(score, highScore)
        
        // Store in user defaults
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(highScore, forKey: "highScore")
        defaults.setInteger(stars, forKey: "stars")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}