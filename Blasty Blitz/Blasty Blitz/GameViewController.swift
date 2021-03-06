//
//  GameViewController.swift
//  Blasty Blitz
//
//  Created by Kuhta, Dean on 4/10/16.
//  Copyright (c) 2016 Dean Kuhta. All rights reserved.
//

import UIKit
import SpriteKit
import SceneKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let skView = self.view as! SKView
        
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        let scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .AspectFit
        
        skView.presentScene(scene)
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
