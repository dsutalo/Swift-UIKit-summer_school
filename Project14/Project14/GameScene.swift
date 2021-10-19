//
//  GameScene.swift
//  Project14
//
//  Created by Domagoj Sutalo on 12.08.2021..
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var finalScore: SKLabelNode!
    var numberOfRounds = 0
    var popupTime = 0.85
    var slots = [WhackSlot]()
    var gameScore: SKLabelNode!
    var score = 0{
        didSet{
            gameScore.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        setupBackground()
        setupGameScore()
        createSlots()
    
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){ [weak self] in
            self?.createEnemy()
        }
    }
    
    func setupBackground(){
        let background = SKSpriteNode(imageNamed: "whackBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
    }
    
    func setupGameScore(){
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.fontSize = 48
        gameScore.position = CGPoint(x: 8, y: 8)
        gameScore.text = "Score: 0"
        gameScore.horizontalAlignmentMode = .left
        addChild(gameScore)
    }
    
    func createSlots(){
        for i in 0..<5 { createSlot(at: CGPoint(x: 100 + (i*170) , y: 410)) }
        for i in 0..<4 { createSlot(at: CGPoint(x: 180 + (i*170) , y: 320)) }
        for i in 0..<5 { createSlot(at: CGPoint(x: 100 + (i*170) , y: 230)) }
        for i in 0..<4 { createSlot(at: CGPoint(x: 180 + (i*170) , y: 140)) }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)

        for node in tappedNodes{
            guard let whackSlot = node.parent?.parent as? WhackSlot else {continue}
            if !whackSlot.isVisible {continue}
            if whackSlot.isHit {continue}
            whackSlot.hit()
            if node.name == "charFriend"{
                score -= 5
                run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion: false))
            } else if node.name == "charEnemy"{
                whackSlot.charNode.xScale = 0.85
                whackSlot.charNode.yScale = 0.85
                score += 1
                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
            }
        }
    }
    
    func createSlot(at position: CGPoint){
        let slot = WhackSlot()
        slot.configure(position: position)
        addChild(slot)
        slots.append(slot)
    }
    
    func createEnemy(){
        numberOfRounds += 1
        if numberOfRounds >= 20{
            for slot in slots{
                //challenge 2
                showFinalScore()
                slot.hide()
                let gameOver = SKSpriteNode(imageNamed: "gameOver")
                gameOver.position = CGPoint(x: 512, y: 384)
                gameOver.zPosition = 1
                //challenge 1
                run(SKAction.playSoundFileNamed("gameOver.caf", waitForCompletion: false))
                addChild(gameOver)
                return
            }
        }
        
        popupTime *= 0.991
        
        slots.shuffle()
        slots[0].show(hideTime: popupTime)
        
        if Int.random(in: 0...12) > 4 {slots[1].show(hideTime: popupTime)}
        if Int.random(in: 0...12) > 8 {slots[2].show(hideTime: popupTime)}
        if Int.random(in: 0...12) > 10 {slots[3].show(hideTime: popupTime)}
        if Int.random(in: 0...12) > 11 {slots[4].show(hideTime: popupTime)}
        
        let minDelay = popupTime / 2.0
        let maxDelay = popupTime * 2.0
        
        let delay = Double.random(in: minDelay...maxDelay)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay){ [weak self] in
            self?.createEnemy()
        }
    }
    func showFinalScore(){
        let finalScore = SKLabelNode(text: "Your final score is \(score)")
        finalScore.position = CGPoint(x: 512, y: 300)
        finalScore.zPosition = 1
        finalScore.alpha = 1
        finalScore.fontSize = 44
        finalScore.fontName = "Chalkduster"
        addChild(finalScore)
    }
}
