//
//  GameScene.swift
//  Project11
//
//  Created by Domagoj Sutalo on 09.08.2021..
//

import SpriteKit


class GameScene: SKScene, SKPhysicsContactDelegate{
    var scoreLabel: SKLabelNode!
    //challenge 1
    let balls = ["ballRed","ballBlue","ballCyan","ballGreen", "ballPurple","ballYellow"]
    var ballsAvailable = 5
    var numberOfPins = 0
    
    var score = 0{
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var editLabel: SKLabelNode!
    var finalResult: SKLabelNode!
    
    var editingMode: Bool = true{
        didSet{
            if editingMode {
                editLabel.text = "Done"
            } else{
                editLabel.text = "Edit"
            }
        }
    }
    
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)
        
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Done"
        editLabel.position = CGPoint(x: 80, y: 700)
        addChild(editLabel)
        
        finalResult = SKLabelNode(fontNamed: "Chalkduster")
        finalResult.text = "final"
        finalResult.position = CGPoint(x: 512, y: 700)
        finalResult.alpha = 0
        addChild(finalResult)
        
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        
        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)
        
        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        var location = touch.location(in: self)
        
        
    
        let objects = nodes(at: location)
        if objects.contains(editLabel){
            editingMode.toggle()
        } else{
            if editingMode {
                let size = CGSize(width: Int.random(in: 16...128), height: 16)
                let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: size)
                box.zRotation = CGFloat.random(in: 0...3)
                box.position = location
                
                box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
                box.physicsBody?.isDynamic = false
                box.name = "box"
                numberOfPins += 1
                addChild(box)
                
            } else{
                //challenge 3 - limit balls number to 5
                if ballsAvailable > 0{
                    //challenge 2 - force Y value so they are near the top of the screen
                    if location.y < 640{
                        location.y = 640
                    }
                    
                    //challenge 1 - use random ball color
                    let ball = SKSpriteNode(imageNamed: balls.randomElement()!)
                    ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
                    ball.physicsBody?.restitution = 0.4
                    ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0
                    ball.position = location
                    print(location.y)
                    ball.name = "ball"
                    addChild(ball)
                    ballsAvailable -= 1
                    
                }
                
            }
        }
        
        
        
    }
    
    
    
    func isBallInGame() -> Bool{
        if ballsAvailable > 0 {
            return true
        }
        return false
        
    }
    
    func makeBouncer(at position: CGPoint){
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }
    
    func makeSlot(at position: CGPoint, isGood: Bool){
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood{
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        } else{
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        
        slotBase.position = position
        slotGlow.position = position
        
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        
        
        addChild(slotBase)
        addChild(slotGlow)
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinforever = SKAction.repeatForever(spin)
        slotGlow.run(spinforever)
        
    }
    
    func collision(between ball: SKNode, object: SKNode){
        if object.name == "good"{
            destroy(ball: ball)
            score += 1
            revealFinalResult()
            
        } else if object.name == "bad" {
            destroy(ball: ball)
            score -= 1
            revealFinalResult()
            
        } else if object.name == "box"{
            destroyBox(box: object)
            numberOfPins -= 1
            revealFinalResult()
        }
        
    }
    
    func revealFinalResult(){
        if numberOfPins <= 0 && !isBallInGame(){
            finalResult.text = "Final score: \(score)"
            finalResult.alpha = 1
        
        } else if numberOfPins > 0 && !isBallInGame(){
            finalResult.text = "You lost, \(numberOfPins) pins left!"
            finalResult.alpha = 1
        }
    }
    
    func destroyBox(box: SKNode){
        box.removeFromParent()
    }
    
   
    
    func destroy(ball: SKNode) {
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticles.position = ball.position
            addChild(fireParticles)
        }
        ball.removeFromParent()
    }
    
    func didBegin (_ contact: SKPhysicsContact){
        
        guard let nodeA = contact.bodyA.node else {return}
        guard let nodeB = contact.bodyB.node else {return}
        
        if nodeA.name == "ball"{
            collision(between: nodeA, object: nodeB)
           
        } else if nodeB.name == "ball"{
            collision(between: nodeB, object: nodeA)
            
        }
    }
}
