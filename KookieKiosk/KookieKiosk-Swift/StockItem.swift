//
//  StockItem.swift
//  KookieKiosk-Swift
//
//  Created by Barbara Reichart on 14/07/14.
//  Copyright (c) 2014 Barbara Reichart. All rights reserved.
//

import SpriteKit

class StockItem : SKNode {

    let type : String
    let flavor : String
    private var amount : Int
    
    private let maxAmount : Int
    private let relativeX : Float
    private let relativeY : Float
    private let stockingSpeed : Float
    private let sellingSpeed : Float
    private let stockingPrice : Int
    private let sellingPrice : Int
    
    private var gameStateDelegate : GameStateDelegate
    
    private var stockingTimer = SKLabelNode(fontNamed: "TrebuchetMS-Bold")
    private var progressBar : ProgressBar
    private var sellButton = SKSpriteNode(imageNamed: "sell_button")
    private var priceTag = SKSpriteNode(imageNamed: "price_tag")
  
    init(stockItemData: [String: AnyObject], stockItemConfiguration: [String: NSNumber], gameStateDelegate: GameStateDelegate) {
        self.gameStateDelegate = gameStateDelegate
        
        // initialize item from data
        // instead of loadValuesWithData method
        maxAmount = (stockItemConfiguration["maxAmount"]?.integerValue)!
        stockingSpeed = (stockItemConfiguration["stockingSpeed"]?.floatValue)! * TimeScale
        sellingSpeed = (stockItemConfiguration["sellingSpeed"]?.floatValue)! * TimeScale
        stockingPrice = (stockItemConfiguration["stockingPrice"]?.integerValue)!
        sellingPrice = (stockItemConfiguration["sellingPrice"]?.integerValue)!
        
        type = stockItemData["type"] as AnyObject? as! String
        amount = stockItemData["amount"] as AnyObject? as! Int
        relativeX = stockItemData["x"] as AnyObject? as! Float
        relativeY = stockItemData["y"] as AnyObject? as! Float
        
        var relativeTimerPositionX: Float? = stockItemConfiguration["timerPositionX"]?.floatValue
        if relativeTimerPositionX == nil {
            relativeTimerPositionX = Float(0.0)
        }
        var relativeTimerPositionY: Float? = stockItemConfiguration["timerPositionY"]?.floatValue
        if relativeTimerPositionY == nil {
            relativeTimerPositionY = Float(0.0)
        }
        
        flavor = stockItemData["flavor"] as AnyObject? as! String

        // Create progress bar
        if type == "cookie" {
            let baseName = String(format: "item_%@", type) + "_tray_%i"
            progressBar = DiscreteProgressBar(baseName: baseName)
            
        } else {
            let emptyImageName = NSString(format: "item_%@_empty", type)
            let fullImageName = NSString(format: "item_%@_%@", type, flavor)
            progressBar = ContinuousProgressBar(emptyImageName: emptyImageName as String, fullImageName: fullImageName as String)
        }
      
        super.init()
        setupPriceLabel()
        setupStockingTimer(relativeX: relativeTimerPositionX!, relativeY: relativeTimerPositionY!)
        
        addChild(progressBar.node)
        userInteractionEnabled = true
        sellButton.zPosition = CGFloat(ZPosition.HUDForeground.rawValue)
        
        addChild(priceTag)
        addChild(stockingTimer)
        addChild(sellButton)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupPriceLabel() {
        // Create price label tag
        let priceTagLabel = SKLabelNode(fontNamed: "TrebuchetMS-Bold")
        priceTagLabel.fontSize = 24
        priceTagLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        priceTagLabel.text = String(format: "%i$", maxAmount * stockingPrice)
        priceTagLabel.fontColor = SKColor.blackColor()
        priceTagLabel.zPosition = CGFloat(ZPosition.HUDForeground.rawValue)
        priceTag.zPosition = CGFloat(ZPosition.HUDBackground.rawValue)
        priceTag.addChild(priceTagLabel)
    }
    
    func setupStockingTimer(relativeX relativeX: Float, relativeY: Float) {
        // Create stocking Timer
        stockingTimer.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        stockingTimer.fontSize = 30
        stockingTimer.fontColor = SKColor(red: 198/255.0, green: 139/255.0, blue: 207/255.0, alpha: 1.0)
        stockingTimer.position = CGPoint(x: Int(relativeX * Float(progressBar.node.calculateAccumulatedFrame().size.width)), y: Int(relativeY * Float(progressBar.node.calculateAccumulatedFrame().size.height)))
        stockingTimer.zPosition = CGFloat(ZPosition.HUDForeground.rawValue)
    }
    
    // MARK: write dictionary for storage of stockitem
    func data() -> NSDictionary {
        let data = NSMutableDictionary()
        data["type"] = type
        data["flavor"] = flavor
        data["amount"] = amount
        data["x"] = relativeX
        data["y"] = relativeY
        return data
    }

}