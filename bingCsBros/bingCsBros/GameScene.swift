//
//  GameScene.swift
//  bingCsBros
//
//  Created by Theresa Gundel on 4/12/21.
//

import SpriteKit
import GameplayKit
import CoreData

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var good:Bool = false
    var startOfLevel = DispatchTime.now()
    var level : Int = 3 //make this persistent
    var intervalsUsed : [Int] = []
    var intervalsForScoreUsed : [Int] = []
    var notOnScreen : [String] = []
    var collected : [SKNode] = []
    var score : Int = 0
    var livesHelper: Int!
    var viewCtrl: UIViewController?
    var backgroundImage = "bartle.jpeg"
    var scoreLabel: SKLabelNode!
    var healthLabel: SKLabelNode!
    var lives : Int = 3
    var mainChar: Character!
    
    var scoreboard: [NSManagedObject] = []
    var leaderboard: [NSManagedObject] = []

        
    enum collisionTypes: UInt32 {
        case player = 1
        case enemy = 2
        case obstacle = 4
        case power = 8
        case collectible = 16
        case platform = 32
    }
    
    override func didMove(to view: SKView) {
        
        scoreboard = ScoreboardDatabase.fetchScoreboard()
        leaderboard = LeaderboardDatabase.fetchLeaderboard()
        if(scoreboard.count == 0 ){
            print("SAVING SCOREBOARD 1ST TIME")
            scoreboard = ScoreboardDatabase.saveFirstScoreboard()
        }
        else{
            //reset level and score
<<<<<<< Updated upstream
            //ScoreboardDatabase.updateLevel(newLevel: 1, scoreboardToUpdate: scoreboard[0] as! Scoreboard)
            //ScoreboardDatabase.updateScore(newScore: 0, scoreboardToUpdate: scoreboard[0] as! Scoreboard)
=======
            ScoreboardDatabase.updateLevel(newLevel: 1, scoreboardToUpdate: scoreboard[0] as! Scoreboard)
            ScoreboardDatabase.updateScore(newScore: 0, scoreboardToUpdate: scoreboard[0] as! Scoreboard)
>>>>>>> Stashed changes
            score = scoreboard[0].value(forKey: "score") as! Int
            level = scoreboard[0].value(forKey: "level") as! Int
            lives = scoreboard[0].value(forKey: "lives") as! Int
        }
        
        print("Hello from didMove")
        //needed for gravity/jumping
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -5) //can change dy if we want
        //so nodes don't fall off the screen
        //this is hard coded for an iphone 11 in landscape mode with camera on right
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(origin: CGPoint(x: self.frame.minX, y: self.frame.midY-165), size: self.frame.size))
        self.physicsBody?.categoryBitMask = collisionTypes.obstacle.rawValue //ground acts as a obstacle
//        self.physicsBody?.collisionBitMask = collisionTypes.enemy.rawValue
        
        
        
        mainChar = Character(x: 0, y: 0, img: ((self.viewCtrl as! GameViewController).characterImage!))
        //mainChar = Character(x: 0, y: 0, img: UIImage(named: "Baxter")!)
        mainChar.zPosition = 1
        mainChar.name = "mainChar"
        
        //what type of object is this
        mainChar.physicsBody?.categoryBitMask = collisionTypes.player.rawValue
        //what do we want to be notified of colliding with
        mainChar.physicsBody?.contactTestBitMask = collisionTypes.enemy.rawValue | collisionTypes.power.rawValue | collisionTypes.collectible.rawValue | collisionTypes.obstacle.rawValue | collisionTypes.platform.rawValue | collisionTypes.power.rawValue
        //what do we not want to walk through
        mainChar.physicsBody?.collisionBitMask = collisionTypes.obstacle.rawValue | collisionTypes.platform.rawValue | collisionTypes.enemy.rawValue
        
        self.livesHelper = mainChar.lives
        addChild(mainChar)
        if(level == 1 ){
            backgroundImage = "bartle.jpeg"
        }
        else if(level == 2){
            backgroundImage = "g7"
        }
        else if (level == 3){
            backgroundImage = "office"
        }
        setUpLabels()
        createBackground()
    }
    
    func didBegin(_ contact: SKPhysicsContact) { //called when beginning of a collision is detected
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        if nodeA.name == "mainChar" {
            playerCollided(with: nodeB)
        } else if nodeB.name == "mainChar" {
            playerCollided(with: nodeA)
        }
    }
    
    func playerCollided(with node: SKNode){
        if node.name == "Enemy"{
            let mc = (self.childNode(withName: "mainChar") as! Character)
            let en = (node as! Enemy)
            if(mc.position.y >= en.position.y){
                //kill enemy
                en.removeFromParent()
                mc.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 50.0))
            }
            else if(mc.hasImmunity){
                en.removeFromParent()
            }
            else if(en.typeOfEnemy == "thwomp" && mc.position.y <= en.position.y){
                print("under thwomp")
                //under th3weomp
//                en.physicsBody?.isDynamic = false
//                en.physicsBody?.affectedByGravity = false
                en.upTime = true 
                mc.lives -= 1
                
                if(mc.lives <= 0){
                    NSLog("Out of lives")
                    self.view?.isPaused = true
                    self.score = makeFinalScore()
<<<<<<< Updated upstream
                    ScoreboardDatabase.updateScore(newScore: Int64(self.score), scoreboardToUpdate: scoreboard[0] as! Scoreboard)
=======
>>>>>>> Stashed changes
                    self.viewCtrl?.performSegue(withIdentifier: "gameToLose", sender: self)
                    mc.lives = 100
                    mainChar.position.x = 10000
                    //timeInterval = 0
                }
                
                self.livesHelper -= 1
                
                //TODO player is squished - jake?

            }
            else{
                mc.lives -= 1
                
                if(mc.lives <= 0){
                    NSLog("Out of lives")
                    self.view?.isPaused = true
                    self.score = makeFinalScore()
<<<<<<< Updated upstream
                    ScoreboardDatabase.updateScore(newScore: Int64(self.score), scoreboardToUpdate: scoreboard[0] as! Scoreboard)
=======
>>>>>>> Stashed changes
                    self.viewCtrl?.performSegue(withIdentifier: "gameToLose", sender: self)
                    mc.lives = 100
                    mainChar.position.x = 10000
                    //timeInterval = 0
                }
                
                self.livesHelper -= 1
                if(mc.isGoingRight){
                    mc.physicsBody?.applyImpulse(CGVector(dx: -20.0, dy: 30.0))
                }
                else{
                    //going left
                    mc.physicsBody?.applyImpulse(CGVector(dx: 20.0, dy: 30.0))

                }
            }
        }
        else if node.name == "powerItem"{
            (node as! PowerItem).characterEffect(currChar: (self.childNode(withName: "mainChar") as! Character))
            node.removeFromParent()
        }
        else if node.name == "collectible"{
            (node as! Collectable).isCollected = true
            self.collected.append(node) //keep track of ones we collected
            node.removeFromParent() //remove from screen
        }
        else if node.name == "flag"{
            //TODO: if collision when level is 3, bring to completed game viewcontroller
            self.livesHelper = 3
            self.level += 1
            self.view?.isPaused = true
            self.score = makeFinalScore()
            ScoreboardDatabase.updateLevel(newLevel: Int64(self.level), scoreboardToUpdate: scoreboard[0] as! Scoreboard)
            ScoreboardDatabase.updateScore(newScore: Int64(self.score), scoreboardToUpdate: scoreboard[0] as! Scoreboard)
            ScoreboardDatabase.updateLives(newLives: Int64(self.livesHelper!), scoreboardToUpdate: scoreboard[0] as! Scoreboard)
//            (self.viewCtrl as! GameViewController).score = self.score
//            (self.viewCtrl as! GameViewController).level = self.level
            if(level == 4 ){
                //passed level 3 : Completed the game
                //checkIfNewScoreOnLeaderboard()
                self.viewCtrl?.performSegue(withIdentifier: "gameToCompleted", sender: self)

            }
            else {
                self.viewCtrl?.performSegue(withIdentifier: "gameToWin", sender: self)
            }
            //update score and level, set lives back to 3
            
        }
        else if node.name == "Obstacle"{
            let mc = (self.childNode(withName: "mainChar") as! Character)
            if(mc.position.y > node.position.y){
                //if on top
                (self.childNode(withName: "mainChar") as! Character).jumpCount = 0
            }
        }
        else if node.name == "Platform"{
            let mc = (self.childNode(withName: "mainChar") as! Character)
            if(mc.position.y > node.position.y){
                //if on top
                (self.childNode(withName: "mainChar") as! Character).jumpCount = 0
            }
            else if(mc.position.y < node.position.y){
                //bottom
                if((node as! PlatformBox).isQuestion){
                    powerItemAppear(node: node as! PlatformBox)
                }
            }
        }
        else{
            //collide with ground
            (self.childNode(withName: "mainChar") as! Character).jumpCount = 0
        }
    }
    
    func setUpLabels(){
        //create score label
          self.scoreLabel = SKLabelNode(fontNamed: "Courier")
          self.scoreLabel.name = "scoreLabel"
          self.scoreLabel.fontSize = 20
          self.scoreLabel.fontColor = SKColor.white
        self.scoreLabel.text = String(format: "Score: %04u", self.score)
        self.scoreLabel.position = CGPoint(x: Int(self.frame.maxY) - 400, y: 130)
        self.scoreLabel.zPosition = 2
        addChild(scoreLabel)
        //same for health
          self.healthLabel = SKLabelNode(fontNamed: "Courier")
          self.healthLabel.name = "healthLabel"
          self.healthLabel.fontSize = 20
          self.healthLabel.fontColor = SKColor.white
        self.healthLabel.text = String(format: "Health: 3")
          self.healthLabel.position = CGPoint(x: Int(self.frame.minY) + 400, y: 130)
        self.healthLabel.zPosition = 2
        addChild(healthLabel)
    }
    
    func updateLabels(){
        self.scoreLabel.text = String(format: "Score: %04u", self.score)
        self.healthLabel.text = String(format: "Health: %04u", self.livesHelper)
    }
    
    func powerItemAppear(node: PlatformBox){
        let pItem = PowerItem(x: Int(node.position.x), y: Int(node.position.y) + 30, powerType: node.powerType ?? "")
        pItem.physicsBody?.categoryBitMask = collisionTypes.power.rawValue
        pItem.physicsBody?.contactTestBitMask = collisionTypes.player.rawValue
        pItem.physicsBody?.affectedByGravity = false
        pItem.zPosition = 1
        addChild(pItem)
    }
    
    
    
    
    func touchDown(atPoint pos : CGPoint) {
        //jump
        let displaySize = UIScreen.main.bounds
        if(pos.y > mainChar.position.y + 30){
            //NSLog("I'm a dinosaur and I like to jump.")
            (self.children[0] as! Character).jump()

            
        }
        //right
        if(pos.x <= mainChar.position.x){
          //  NSLog("I'm a dinosaur and I like to run right.")
            (self.children[0] as! Character).moveBackward()
            callBack_backward()

            
        }
        //left
        if(pos.x > mainChar.position.x + mainChar.size.width/2){
          //  NSLog("I'm a dinosaur and I like to run left.")
            callBack_forward()
        }
//
//        if(pos.x > -180 && pos.x < 180){
//           // NSLog("I'm a dinosaur and I like to jump.")
//            (self.children[0] as! Character).jump()
//
//
//        }
//        //right
//        if(pos.x < -180){
//          //  NSLog("I'm a dinosaur and I like to run right.")
//            (self.children[0] as! Character).moveBackward()
//            callBack_backward()
//
//
//        }
//        //left
//        if(pos.x > 180){
//          //  NSLog("I'm a dinosaur and I like to run left.")
//            callBack_forward()
//        }
    }
    
    func callBack_forward() {
        (self.children[0] as! Character).moveForward()
        if(good == true){
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.005) {
                self.callBack_forward()
            }
        }
    }
    func callBack_backward() {
        (self.children[0] as! Character).moveBackward()
        if(good == true){
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.005) {
                self.callBack_backward()
            }
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        good = true
        for t in touches {
            self.touchDown(atPoint: t.location(in: self))
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        good = false
        for t in touches {
            self.touchUp(atPoint: t.location(in: self))
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func update(_ currentTime: TimeInterval) {
        //print("Hello from update")
        var timeInterval = 0

        // Called before each frame is rendered
        //NSLog("%f", mainChar.position.x)
        if(mainChar.position.x < -400){
            NSLog("Out of screen")
            self.view?.isPaused = true
            self.score = makeFinalScore()
<<<<<<< Updated upstream
            ScoreboardDatabase.updateScore(newScore: Int64(self.score), scoreboardToUpdate: scoreboard[0] as! Scoreboard)
=======
>>>>>>> Stashed changes
            self.viewCtrl?.performSegue(withIdentifier: "gameToLose", sender: self)
            mainChar.position.x = 10000
            //timeInterval = 0
        }
        if(level == 1 ){
            timeInterval = playLevel1()
        } //end of if level  == 1
        else if(level == 2){
            timeInterval = playLevel2()
        } //end of if level == 2
        
        else if(level == 3){
            timeInterval = playLevel3()
        }
        
        if(intervalsForScoreUsed.contains(Int(timeInterval)) == false){
            self.score += 1
            intervalsForScoreUsed.append(Int(timeInterval))
        }
        

        moveBackground()
        moveNodesWithBackground()
        updateLabels()
        checkChar()
    }
    
//    func checkIfNewScoreOnLeaderboard() -> Bool{
//
//        let scoresString = leaderboard[0].value(forKey: "top5Scores") as! String
//        var scores = scoresString.components(separatedBy: ",")
//        let scoresInt =  scores.map { Int($0)!}
//        var indexOfNewScore = -1
//        for i in stride(from: scoresInt.count - 1, to: 0, by: -1) {
//            if(score > scoresInt[i] ){
//                indexOfNewScore = i
//            }
//        }
//
//        if(indexOfNewScore != -1 ){
//            print("new high score!")
//            scores.insert(String(score), at: indexOfNewScore)
//            scores.removeLast()
//            let scoreStringUpdated = (scores.map{String($0)}).joined(separator: ",")
//
//            //insert new value at i and remove last value
//            LeaderboardDatabase.updateTop5(newList: scoreStringUpdated , leaderboardToUpdate: leaderboard[0] as! Leaderboard)
//            return true
//        }
//
//        return false
//
//
//
//    }
    
    func checkChar(){
        let mc = (self.childNode(withName: "mainChar") as! Character)
        mc.powerTimer -= 1
        if(mc.powerTimer == 0){
            if(mc.charSpeed == 4.0){
                mc.charSpeed = 2.0
            }
            else if(mc.hasImmunity){
                mc.hasImmunity = false
            }
        }
    }
    
    func playLevel1() -> Int{
        backgroundImage = "bartle.jpeg"
        //declare all enemies/obstacles
        let enemy1 = Enemy(x: Int(self.frame.maxY) - 450 , y: (Int(self.frame.minX) / 4) - 30 , img: "moore", typeOfEnemy: "goomba", id: 1)
        enemy1.physicsBody?.categoryBitMask = collisionTypes.enemy.rawValue
        enemy1.physicsBody?.contactTestBitMask = collisionTypes.player.rawValue
        enemy1.physicsBody?.collisionBitMask = collisionTypes.player.rawValue
        
        let obstacle1 = Obstacles(x: Int(self.frame.maxY) - 300, y: (Int(self.frame.minX) / 4) - 30, img: "desk", typeOfObstacles: "idk?", id: 2)
        obstacle1.physicsBody?.categoryBitMask = collisionTypes.obstacle.rawValue
        
        let enemy2 = Enemy(x: Int(self.frame.maxY) - 300, y: (Int(self.frame.minX) / 4) - 30, img: "madden-1", typeOfEnemy: "goomba", id: 3)
        enemy2.physicsBody?.categoryBitMask = collisionTypes.enemy.rawValue
        enemy2.physicsBody?.contactTestBitMask = collisionTypes.player.rawValue
        enemy2.physicsBody?.collisionBitMask = collisionTypes.player.rawValue
        
        let platform1 : [SKNode] = makePlatform(x: Int(self.frame.maxY) - 300 , y: 0, numBoxes: 5, numQBoxes: 1)
        for box in platform1{
            box.physicsBody?.categoryBitMask = collisionTypes.platform.rawValue
            box.physicsBody?.contactTestBitMask = 0
            box.physicsBody?.collisionBitMask = collisionTypes.player.rawValue
            if((box as! PlatformBox).isQuestion){
                (box as! PlatformBox).powerType = "SpeedBoost"
            }
        }
        
        let obstacle2 = Obstacles(x: Int(self.frame.maxY) - 300, y: (Int(self.frame.minX) / 4) - 30, img: "chair", typeOfObstacles: "idk?", id: 4)
        obstacle2.physicsBody?.categoryBitMask = collisionTypes.obstacle.rawValue

        let enemy3 = Enemy(x: Int(self.frame.maxY) - 300, y: (Int(self.frame.minX) / 4) - 30, img: "moore", typeOfEnemy: "goomba", id: 5)
        enemy3.physicsBody?.categoryBitMask = collisionTypes.enemy.rawValue
        enemy3.physicsBody?.contactTestBitMask = collisionTypes.player.rawValue
        enemy3.physicsBody?.collisionBitMask = collisionTypes.player.rawValue
        
        let platform2 : [SKNode] = makePlatform(x: Int(self.frame.maxY) - 300 , y: 0, numBoxes: 5, numQBoxes: 0)  //come out before 3
        for box in platform2{
            box.physicsBody?.categoryBitMask = collisionTypes.platform.rawValue
            box.physicsBody?.contactTestBitMask = 0
            box.physicsBody?.collisionBitMask = collisionTypes.player.rawValue
        }
        
        let platform3 : [SKNode] = makePlatform(x: Int(self.frame.maxY) - 150 , y: Int(self.frame.maxX / 2) - 100, numBoxes: 5, numQBoxes: 1)
        for box in platform3{
            box.physicsBody?.categoryBitMask = collisionTypes.platform.rawValue
            box.physicsBody?.contactTestBitMask = 0
            box.physicsBody?.collisionBitMask = collisionTypes.player.rawValue
            if((box as! PlatformBox).isQuestion){
                (box as! PlatformBox).powerType = "Immunity"
            }
        }
        
        let collectible1 = Collectable(x: Int(self.frame.maxY) - 105, y: Int(self.frame.maxX / 2) - 100 + 25, img: "stackOverflowLogo")
        collectible1.physicsBody?.categoryBitMask = collisionTypes.collectible.rawValue
        collectible1.physicsBody?.contactTestBitMask = collisionTypes.player.rawValue
        collectible1.physicsBody?.collisionBitMask = 0
        
        let obstacle3 = Obstacles(x: Int(self.frame.maxY) - 300, y: (Int(self.frame.minX) / 4) - 30, img: "desk", typeOfObstacles: "idk?", id: 6)
        obstacle3.physicsBody?.categoryBitMask = collisionTypes.obstacle.rawValue

        
        let platform4 : [SKNode] = makePlatform(x: Int(self.frame.maxY) - 300 , y: 0, numBoxes: 3, numQBoxes: 0)
        for box in platform4{
            box.physicsBody?.categoryBitMask = collisionTypes.platform.rawValue
            box.physicsBody?.contactTestBitMask = 0
            box.physicsBody?.collisionBitMask = collisionTypes.player.rawValue
        }
        
        let enemy4 = Enemy(x: Int(self.frame.maxY) - 300, y: (Int(self.frame.minX) / 4) - 30, img: "madden-1", typeOfEnemy: "goomba", id: 7)
        enemy4.physicsBody?.categoryBitMask = collisionTypes.enemy.rawValue
        enemy4.physicsBody?.contactTestBitMask = collisionTypes.player.rawValue
        enemy4.physicsBody?.collisionBitMask = collisionTypes.player.rawValue
        
        let platform5 : [SKNode] = makePlatform(x: Int(self.frame.maxY) - 300 , y: Int(self.frame.maxX / 2) - 100, numBoxes: 4, numQBoxes: 0) //come out ebfore 6
        for box in platform5{
            box.physicsBody?.categoryBitMask = collisionTypes.platform.rawValue
            box.physicsBody?.contactTestBitMask = 0
            box.physicsBody?.collisionBitMask = collisionTypes.player.rawValue
        }
        
        let platform6 : [SKNode] = makePlatform(x: Int(self.frame.maxY) - 150 , y: 0, numBoxes: 4, numQBoxes: 0)
        for box in platform6{
            box.physicsBody?.categoryBitMask = collisionTypes.platform.rawValue
            box.physicsBody?.contactTestBitMask = 0
            box.physicsBody?.collisionBitMask = collisionTypes.player.rawValue
        }
        
        let collectible2 = Collectable(x: Int(self.frame.maxY) - 255, y: Int(self.frame.maxX / 2) - 100 + 25, img: "stackOverflowLogo")
        collectible2.physicsBody?.categoryBitMask = collisionTypes.collectible.rawValue
        collectible2.physicsBody?.contactTestBitMask = collisionTypes.player.rawValue
        collectible2.physicsBody?.collisionBitMask = 0
        
        
        
        
        
        
        let endFlag = Obstacles(x: Int(self.frame.maxY) - 300, y: (Int(self.frame.minX) / 4) - 30, img: "endFlag", typeOfObstacles: "idk?", id: 8)
        endFlag.physicsBody?.categoryBitMask = collisionTypes.obstacle.rawValue
        endFlag.physicsBody?.contactTestBitMask = collisionTypes.player.rawValue
        endFlag.physicsBody?.collisionBitMask = collisionTypes.player.rawValue
        
        endFlag.name = "flag"
        endFlag.size.width = 300
        endFlag.size.height = self.frame.maxY / 4
        //todo:
        //add collectibles
        
        let now = DispatchTime.now()
        let nanoTime = now.uptimeNanoseconds - startOfLevel.uptimeNanoseconds // Difference in nano seconds
        let timeInterval = Double(nanoTime) / 1_000_000_000
        if(Int(timeInterval) == 1 && intervalsUsed.contains(Int(timeInterval)) == false ){
            intervalsUsed.append(Int(timeInterval))
            enemy1.zPosition = 1
            addChild(enemy1)
     //       addChild(endFlag)
            //self.nodesToMove.append(enemy1.debugDescription)
    
            //moveEnemiesBackAndForth()
        }
        if(Int(timeInterval) == 10 && intervalsUsed.contains(Int(timeInterval)) == false){
            intervalsUsed.append(Int(timeInterval))
            obstacle1.zPosition = 1
            addChild(obstacle1)
           
            
        }
        if(Int(timeInterval) == 17 && intervalsUsed.contains(Int(timeInterval)) == false){
            intervalsUsed.append(Int(timeInterval))
            self.notOnScreen.append(enemy1.description)
            removeEnemy()
            addChild(enemy2)
        }
        
        if(Int(timeInterval) == 24 && intervalsUsed.contains(Int(timeInterval)) == false){
            intervalsUsed.append(Int(timeInterval))
            self.notOnScreen.append(obstacle1.description)
            removeObstacle()
           // platform1 = makePlatform(x: 0 , y: 0, numBoxes: 5, numQBoxes: 1)
            for node in platform1{
                addChild(node)
            }
            
        }
        
        if(Int(timeInterval) == 31 && intervalsUsed.contains(Int(timeInterval)) == false){
            intervalsUsed.append(Int(timeInterval))
            self.notOnScreen.append(enemy2.description)
            removeEnemy()
            addChild(obstacle2)
        }
        
        if(Int(timeInterval) == 38 && intervalsUsed.contains(Int(timeInterval)) == false){
            intervalsUsed.append(Int(timeInterval))
            //add enemy and 2 platforms
            for node in platform1{
                self.notOnScreen.append(node.description)
            }
            removePlatform()
            
            
            self.notOnScreen.append(obstacle2.description)
            removeObstacle()
            
            addChild(enemy3)
            for node in platform2{
                addChild(node)
            }
            
            for node in platform3{
                addChild(node)
            }
            addChild(collectible1)
        }
        
        if(Int(timeInterval) == 45 && intervalsUsed.contains(Int(timeInterval)) == false){
            intervalsUsed.append(Int(timeInterval))
            for node in platform2{
                self.notOnScreen.append(node.description)
            }
            removePlatform()
            addChild(obstacle3)
        }
        
        if(Int(timeInterval) == 52 && intervalsUsed.contains(Int(timeInterval)) == false){
            intervalsUsed.append(Int(timeInterval))
            for node in platform3{
                self.notOnScreen.append(node.description)
            }
            removePlatform()
            self.notOnScreen.append(collectible1.description)
            removeCollectable()
            self.notOnScreen.append(enemy3.description)
            removeEnemy()
            for node in platform4{
                addChild(node)
            }
            
        }
        
        if(Int(timeInterval) == 59 && intervalsUsed.contains(Int(timeInterval)) == false){
            intervalsUsed.append(Int(timeInterval))
            self.notOnScreen.append(obstacle3.description)
            removeObstacle()
            addChild(enemy4)
        }
        
        if(Int(timeInterval) == 66 && intervalsUsed.contains(Int(timeInterval)) == false){
            intervalsUsed.append(Int(timeInterval))
            for node in platform4{
                self.notOnScreen.append(node.description)
            }
            removePlatform()
            for node in platform5{
                addChild(node)
            }
            for node in platform6{
                addChild(node)
            }
            addChild(collectible2)
            //TODO: add collectible on top of platform 5
        }
        
        
        if(Int(timeInterval) == 72 && intervalsUsed.contains(Int(timeInterval)) == false){
            intervalsUsed.append(Int(timeInterval))
            for node in platform5{
                self.notOnScreen.append(node.description)
            }
            removePlatform()
            self.notOnScreen.append(enemy4.description)
            removeEnemy()
            self.notOnScreen.append(collectible2.description)
            removeCollectable()
            //TODO: add ending flag
        }
        
        
        if(Int(timeInterval) == 79 && intervalsUsed.contains(Int(timeInterval)) == false){
            intervalsUsed.append(Int(timeInterval))
            for node in platform6{
                self.notOnScreen.append(node.description)
            }
            removePlatform()
            //add flag
            addChild(endFlag)
        }
        //when show end of level: self.notOnScreen.removeAll() and intervalsUsed.removeAll()
     return Int(timeInterval)
    }
    
    func playLevel2() -> Int {
        backgroundImage = "g7"
        //declare all enemies/obstacles
        let enemy1 = Enemy(x: Int(self.frame.maxY) - 450 , y: (Int(self.frame.minX) / 4) - 30 , img: "moore", typeOfEnemy: "goomba", id: 1)
        enemy1.physicsBody?.categoryBitMask = collisionTypes.enemy.rawValue
        enemy1.physicsBody?.contactTestBitMask = collisionTypes.player.rawValue
        enemy1.physicsBody?.collisionBitMask = collisionTypes.player.rawValue
        
        
        let platform1 : [SKNode] = makePlatform(x: Int(self.frame.maxY) - 300 , y: -50, numBoxes: 6, numQBoxes: 0)
        for box in platform1{
            box.physicsBody?.categoryBitMask = collisionTypes.platform.rawValue
            box.physicsBody?.contactTestBitMask = 0
            box.physicsBody?.collisionBitMask = collisionTypes.player.rawValue
        }
        
        let obstacle1 = Obstacles(x: Int(self.frame.maxY) - 300, y: (Int(self.frame.minX) / 4) - 30, img: "desk", typeOfObstacles: "idk?", id: 2)
        obstacle1.physicsBody?.categoryBitMask = collisionTypes.obstacle.rawValue
        
        let enemy2 = Enemy(x: Int(self.frame.maxY) - 450 , y: (Int(self.frame.minX) / 4) + 100, img: "lander", typeOfEnemy: "fly", id: 3)
        enemy2.physicsBody?.categoryBitMask = collisionTypes.enemy.rawValue
        enemy2.physicsBody?.contactTestBitMask = collisionTypes.player.rawValue
        enemy2.physicsBody?.collisionBitMask = collisionTypes.player.rawValue
        
        let platform2 : [SKNode] = makePlatform(x: Int(self.frame.maxY) - 300 , y: -25, numBoxes: 5, numQBoxes: 0)
        for box in platform2{
            box.physicsBody?.categoryBitMask = collisionTypes.platform.rawValue
            box.physicsBody?.contactTestBitMask = 0
            box.physicsBody?.collisionBitMask = collisionTypes.player.rawValue
        }
        
        let collectible1 = Collectable(x: Int(self.frame.maxY) - 255, y: 0, img: "stackOverflowLogo")
        collectible1.physicsBody?.categoryBitMask = collisionTypes.collectible.rawValue
        collectible1.physicsBody?.contactTestBitMask = collisionTypes.player.rawValue
        collectible1.physicsBody?.collisionBitMask = 0
        
        let obstacle2 = Obstacles(x: Int(self.frame.maxY) - 300, y: (Int(self.frame.minX) / 4) - 30, img: "desk", typeOfObstacles: "idk?", id: 2)
        obstacle2.physicsBody?.categoryBitMask = collisionTypes.obstacle.rawValue
        
        let platform3 : [SKNode] = makePlatform(x: Int(self.frame.maxY) - 300 , y: -50, numBoxes: 5, numQBoxes: 0)
        for box in platform3{
            box.physicsBody?.categoryBitMask = collisionTypes.platform.rawValue
            box.physicsBody?.contactTestBitMask = 0
            box.physicsBody?.collisionBitMask = collisionTypes.player.rawValue
        }
        
        let enemy3 = Enemy(x: Int(self.frame.maxY) - 260 , y: (Int(self.frame.minX) / 4) - 30 , img: "moore", typeOfEnemy: "goomba", id: 3)
        enemy3.physicsBody?.categoryBitMask = collisionTypes.enemy.rawValue
        enemy3.physicsBody?.contactTestBitMask = collisionTypes.player.rawValue
        enemy3.physicsBody?.collisionBitMask = collisionTypes.player.rawValue
        
        
        let platform4 : [SKNode] = makePlatform(x: Int(self.frame.maxY) - 150 , y: Int(self.frame.maxX / 2) - 150, numBoxes: 5, numQBoxes: 0)
        for box in platform4{
            box.physicsBody?.categoryBitMask = collisionTypes.platform.rawValue
            box.physicsBody?.contactTestBitMask = 0
            box.physicsBody?.collisionBitMask = collisionTypes.player.rawValue
        }
        
        let enemy4 = Enemy(x: Int(self.frame.maxY) - 200 , y: Int(self.frame.maxX / 2) - 125, img: "head", typeOfEnemy: "fly", id: 4)
        enemy4.physicsBody?.categoryBitMask = collisionTypes.enemy.rawValue
        enemy4.physicsBody?.contactTestBitMask = collisionTypes.player.rawValue
        enemy4.physicsBody?.collisionBitMask = collisionTypes.player.rawValue
        
        let platform5 : [SKNode] = makePlatform(x: Int(self.frame.maxY) - 150 , y: -75, numBoxes: 7, numQBoxes: 1)
        for box in platform5{
            box.physicsBody?.categoryBitMask = collisionTypes.platform.rawValue
            box.physicsBody?.contactTestBitMask = 0
            box.physicsBody?.collisionBitMask = collisionTypes.player.rawValue
            if((box as! PlatformBox).isQuestion){
                (box as! PlatformBox).powerType = "Immunity"
            }
        }
        
        
        let enemy5 = Enemy(x: Int(self.frame.maxY) - 115 , y: -25, img: "madden-1", typeOfEnemy: "goomba", id: 5)
        enemy5.physicsBody?.categoryBitMask = collisionTypes.enemy.rawValue
        enemy5.physicsBody?.contactTestBitMask = collisionTypes.player.rawValue
        enemy5.physicsBody?.collisionBitMask = collisionTypes.player.rawValue
        
        
        //middle platform
        let platform6 : [SKNode] = makePlatform(x: Int(self.frame.maxY) - 150 , y: -25, numBoxes: 6, numQBoxes: 0)
        for box in platform6{
            box.physicsBody?.categoryBitMask = collisionTypes.platform.rawValue
            box.physicsBody?.contactTestBitMask = 0
            box.physicsBody?.collisionBitMask = collisionTypes.player.rawValue
        }
        
        //flying above platform6
        let enemy6 = Enemy(x: Int(self.frame.maxY) - 98 , y: (Int(self.frame.minX) / 4) + 190, img: "lander", typeOfEnemy: "fly", id: 6)
        enemy6.physicsBody?.categoryBitMask = collisionTypes.enemy.rawValue
        enemy6.physicsBody?.contactTestBitMask = collisionTypes.player.rawValue
        enemy6.physicsBody?.collisionBitMask = collisionTypes.player.rawValue
        
        
        //below playform6
        let enemy7 = Enemy(x: Int(self.frame.maxY) - 98 , y: (Int(self.frame.minX) / 4) - 30, img: "moore", typeOfEnemy: "goomba", id: 7)
        enemy7.physicsBody?.categoryBitMask = collisionTypes.enemy.rawValue
        enemy7.physicsBody?.contactTestBitMask = collisionTypes.player.rawValue
        enemy7.physicsBody?.collisionBitMask = collisionTypes.player.rawValue
        
        let obstacle3 = Obstacles(x: Int(self.frame.maxY) - 300, y: (Int(self.frame.minX) / 4) - 30, img: "desk", typeOfObstacles: "idk?", id: 3)
        obstacle3.physicsBody?.categoryBitMask = collisionTypes.obstacle.rawValue
        
        //collectable on playform 7
        let platform7 : [SKNode] = makePlatform(x: Int(self.frame.maxY) - 300 , y: Int(self.frame.maxX / 2) - 150, numBoxes: 4, numQBoxes: 0) //come out ebfore 6
        for box in platform7{
            box.physicsBody?.categoryBitMask = collisionTypes.platform.rawValue
            box.physicsBody?.contactTestBitMask = 0
            box.physicsBody?.collisionBitMask = collisionTypes.player.rawValue
        }
        
        let platform8 : [SKNode] = makePlatform(x: Int(self.frame.maxY) - 150 , y: -50, numBoxes: 4, numQBoxes: 0)
        for box in platform8{
            box.physicsBody?.categoryBitMask = collisionTypes.platform.rawValue
            box.physicsBody?.contactTestBitMask = 0
            box.physicsBody?.collisionBitMask = collisionTypes.player.rawValue
        }
        
        //collectable on platform7
        let collectible2 = Collectable(x: Int(self.frame.maxY) - 255, y: Int(self.frame.maxX / 2) - 120, img: "stackOverflowLogo")
        collectible2.physicsBody?.categoryBitMask = collisionTypes.collectible.rawValue
        collectible2.physicsBody?.contactTestBitMask = collisionTypes.player.rawValue
        collectible2.physicsBody?.collisionBitMask = 0
        
        let enemy8 = Enemy(x: Int(self.frame.maxY) - 98 , y:  (Int(self.frame.minX) / 4) + 10 , img: "head", typeOfEnemy: "fly", id: 8)
        enemy8.physicsBody?.categoryBitMask = collisionTypes.enemy.rawValue
        enemy8.physicsBody?.contactTestBitMask = collisionTypes.player.rawValue
        enemy8.physicsBody?.collisionBitMask = collisionTypes.player.rawValue
        
<<<<<<< Updated upstream
        let obstacle4 = Obstacles(x: Int(self.frame.maxY) - 300, y: (Int(self.frame.minX) / 4) - 30, img: "desk", typeOfObstacles: "idk?", id: 4)
=======
        let obstacle4 = Obstacles(x: Int(self.frame.maxY) - 300, y: (Int(self.frame.minX) / 4) - 30, img: "banana", typeOfObstacles: "idk?", id: 4)
>>>>>>> Stashed changes
        obstacle4.physicsBody?.categoryBitMask = collisionTypes.obstacle.rawValue
        
        
        let endFlag = Obstacles(x: Int(self.frame.maxY) - 300, y: (Int(self.frame.minX) / 4) - 30, img: "endFlag", typeOfObstacles: "idk?", id: 8)
        endFlag.physicsBody?.categoryBitMask = collisionTypes.obstacle.rawValue
        endFlag.physicsBody?.contactTestBitMask = collisionTypes.player.rawValue
        endFlag.physicsBody?.collisionBitMask = collisionTypes.player.rawValue
        
        endFlag.name = "flag"
        endFlag.size.width = 300
        endFlag.size.height = self.frame.maxY / 4
        
        
        let now = DispatchTime.now()
        let nanoTime = now.uptimeNanoseconds - startOfLevel.uptimeNanoseconds // Difference in nano seconds
        let timeInterval = Double(nanoTime) / 1_000_000_000
        if(Int(timeInterval) == 1 && intervalsUsed.contains(Int(timeInterval)) == false ){
            intervalsUsed.append(Int(timeInterval))
            enemy1.zPosition = 1
            addChild(enemy1)
            
<<<<<<< Updated upstream
           // addChild(endFlag)
=======
            addChild(endFlag)
>>>>>>> Stashed changes
            
            //delete from
            
            

        }
        if(Int(timeInterval) == 10 && intervalsUsed.contains(Int(timeInterval)) == false){
            intervalsUsed.append(Int(timeInterval))
                for node in platform1{
                    addChild(node)
                }
           
        }
        
        if(Int(timeInterval) == 17 && intervalsUsed.contains(Int(timeInterval)) == false){
            intervalsUsed.append(Int(timeInterval))
            self.notOnScreen.append(enemy1.description)
            removeEnemy()
            addChild(obstacle1)
        }
        
        if(Int(timeInterval) == 24 && intervalsUsed.contains(Int(timeInterval)) == false){
            intervalsUsed.append(Int(timeInterval))
            for node in platform1{
                self.notOnScreen.append(node.description)
            }
            removePlatform()
            addChild(enemy2)
        }
        
        
        if(Int(timeInterval) == 31 && intervalsUsed.contains(Int(timeInterval)) == false){
            intervalsUsed.append(Int(timeInterval))
            for node in platform2{
                addChild(node)
            }
            addChild(collectible1)
            self.notOnScreen.append(obstacle1.description)
            removeObstacle()
        }
        
        if(Int(timeInterval) == 38 && intervalsUsed.contains(Int(timeInterval)) == false){
            intervalsUsed.append(Int(timeInterval))
            addChild(obstacle2)
            self.notOnScreen.append(enemy2.description)
            removeEnemy()
        }
        
        if(Int(timeInterval) == 45 && intervalsUsed.contains(Int(timeInterval)) == false){
            intervalsUsed.append(Int(timeInterval))
            for node in platform2{
                self.notOnScreen.append(node.description)
            }
            removePlatform()
            for node in platform3{
                addChild(node)
            }
            for node in platform4{
                addChild(node)
            }
            addChild(enemy3)
        }
        
        if(Int(timeInterval) == 52 && intervalsUsed.contains(Int(timeInterval)) == false){
            intervalsUsed.append(Int(timeInterval))
            addChild(enemy4)
            self.notOnScreen.append(obstacle2.description)
            removeObstacle()

        }
        
        if(Int(timeInterval) == 59 && intervalsUsed.contains(Int(timeInterval)) == false){
            intervalsUsed.append(Int(timeInterval))
            for node in platform5{
                addChild(node)
            }
            addChild(enemy5)
            for node in platform3{
                self.notOnScreen.append(node.description)
            }
            for node in platform4{
                self.notOnScreen.append(node.description)
            }
            removePlatform()
            self.notOnScreen.append(enemy3.description)
            removeEnemy()

        }
        
        if(Int(timeInterval) == 66 && intervalsUsed.contains(Int(timeInterval)) == false){
            intervalsUsed.append(Int(timeInterval))
            addChild(enemy6)
            addChild(enemy7)
            for node in platform6{
                addChild(node)
            }
            
            self.notOnScreen.append(enemy4.description)
            removeEnemy()

        }

        
        
        if(Int(timeInterval) == 73 && intervalsUsed.contains(Int(timeInterval)) == false){
            intervalsUsed.append(Int(timeInterval))
            
            addChild(obstacle3)
            for node in platform5{
                self.notOnScreen.append(node.description)
            }
            
            self.notOnScreen.append(enemy5.description)
            removeEnemy()
            removePlatform()

        }
        
        if(Int(timeInterval) == 80 && intervalsUsed.contains(Int(timeInterval)) == false){
            intervalsUsed.append(Int(timeInterval))
            
            for node in platform6{
                self.notOnScreen.append(node.description)
            }
            
            self.notOnScreen.append(enemy6.description)
            self.notOnScreen.append(enemy7.description)
            
            removeEnemy()
            removePlatform()
            
            for node in platform7{
                addChild(node)
            }
            for node in platform8{
                addChild(node)
            }
            addChild(collectible2)

        }
        
        if(Int(timeInterval) == 87 && intervalsUsed.contains(Int(timeInterval)) == false){
            intervalsUsed.append(Int(timeInterval))
            
            self.notOnScreen.append(obstacle3.description)
            removeObstacle()
            addChild(enemy8)
        }
        
        if(Int(timeInterval) == 94 && intervalsUsed.contains(Int(timeInterval)) == false){
            intervalsUsed.append(Int(timeInterval))
            
            for node in platform7{
                self.notOnScreen.append(node.description)
            }
            for node in platform8{
                self.notOnScreen.append(node.description)
            }
            removePlatform()
            addChild(obstacle4)
        }
        
        if(Int(timeInterval) == 101 && intervalsUsed.contains(Int(timeInterval)) == false){
            intervalsUsed.append(Int(timeInterval))
            
            self.notOnScreen.append(enemy8.description)
            addChild(endFlag)
        }
        
      return Int(timeInterval)
    }
    
    
    
    func playLevel3() -> Int {
        backgroundImage = "g7" //TODO: change this
        //declare all enemies/obstacles
        let enemy1 = Enemy(x: Int(self.frame.maxY) - 450 , y: (Int(self.frame.minX) / 4) - 30 , img: "madden-1", typeOfEnemy: "goomba", id: 1)
        enemy1.physicsBody?.categoryBitMask = collisionTypes.enemy.rawValue
        enemy1.physicsBody?.contactTestBitMask = collisionTypes.player.rawValue
        enemy1.physicsBody?.collisionBitMask = collisionTypes.player.rawValue
        
        let platform1 : [SKNode] = makePlatform(x: Int(self.frame.maxY) - 300 , y: 0, numBoxes: 5, numQBoxes: 0)
        for box in platform1{
            box.physicsBody?.categoryBitMask = collisionTypes.platform.rawValue
            box.physicsBody?.contactTestBitMask = 0
            box.physicsBody?.collisionBitMask = collisionTypes.player.rawValue
        }
        
        let enemy2 = Enemy(x: Int(self.frame.maxY) - 300  , y:  50 , img: "head", typeOfEnemy: "fly", id: 2)
        enemy2.physicsBody?.categoryBitMask = collisionTypes.enemy.rawValue
        enemy2.physicsBody?.contactTestBitMask = collisionTypes.player.rawValue
        enemy2.physicsBody?.collisionBitMask = collisionTypes.player.rawValue
      
       
        let platform2 : [SKNode] = makePlatform(x: Int(self.frame.maxY) - 300 , y: 50, numBoxes: 5, numQBoxes: 1)
        for box in platform2{
            box.physicsBody?.categoryBitMask = collisionTypes.platform.rawValue
            box.physicsBody?.contactTestBitMask = 0
            box.physicsBody?.collisionBitMask = collisionTypes.player.rawValue
            if((box as! PlatformBox).isQuestion){
                (box as! PlatformBox).powerType = "Immunity"
            }
        }
        
        let obstacle1 = Obstacles(x: Int(self.frame.maxY) - 300, y: (Int(self.frame.minX) / 4) - 30, img: "desk", typeOfObstacles: "idk?", id: 3)
        obstacle1.physicsBody?.categoryBitMask = collisionTypes.obstacle.rawValue
        
        let enemy3 = Enemy(x: Int(self.frame.maxY) - 300  , y:  100 , img: "weinschenk", typeOfEnemy: "thwomp", id: 3)
        enemy3.physicsBody?.categoryBitMask = collisionTypes.enemy.rawValue
        enemy3.physicsBody?.contactTestBitMask = collisionTypes.player.rawValue
        enemy3.physicsBody?.collisionBitMask = collisionTypes.player.rawValue | collisionTypes.obstacle.rawValue
        
        
        let obstacle2 = Obstacles(x: Int(self.frame.maxY) - 300, y: (Int(self.frame.minX) / 4) - 30, img: "chair", typeOfObstacles: "idk?", id: 3)
        obstacle2.physicsBody?.categoryBitMask = collisionTypes.obstacle.rawValue
        
        
        
        //collectable on playform 7
        let platform3 : [SKNode] = makePlatform(x: Int(self.frame.maxY) - 300 , y: -50 , numBoxes: 4, numQBoxes: 0) //come out ebfore 6
        for box in platform3{
            box.physicsBody?.categoryBitMask = collisionTypes.platform.rawValue
            box.physicsBody?.contactTestBitMask = 0
            box.physicsBody?.collisionBitMask = collisionTypes.player.rawValue
        }
        
        let platform4 : [SKNode] = makePlatform(x: Int(self.frame.maxY) - 150 , y: Int(self.frame.maxX / 2) - 150, numBoxes: 4, numQBoxes: 0)
        for box in platform4{
            box.physicsBody?.categoryBitMask = collisionTypes.platform.rawValue
            box.physicsBody?.contactTestBitMask = 0
            box.physicsBody?.collisionBitMask = collisionTypes.player.rawValue
        }
        
        
        //collectable on platform4
        let collectible1 = Collectable(x: Int(self.frame.maxY) - 105, y: Int(self.frame.maxX / 2) - 120, img: "stackOverflowLogo")
        collectible1.physicsBody?.categoryBitMask = collisionTypes.collectible.rawValue
        collectible1.physicsBody?.contactTestBitMask = collisionTypes.player.rawValue
        collectible1.physicsBody?.collisionBitMask = 0
        
        
        let enemy4 = Enemy(x: Int(self.frame.maxY) - 300 , y:  Int(self.frame.maxX / 2) - 150 , img: "lander", typeOfEnemy: "fly", id: 4)
        enemy4.physicsBody?.categoryBitMask = collisionTypes.enemy.rawValue
        enemy4.physicsBody?.contactTestBitMask = collisionTypes.player.rawValue
        enemy4.physicsBody?.collisionBitMask = collisionTypes.player.rawValue
        
        let enemy5 = Enemy(x: Int(self.frame.maxY) - 300 , y: (Int(self.frame.minX) / 4) - 30 , img: "moore", typeOfEnemy: "goomba", id: 5)
        enemy5.physicsBody?.categoryBitMask = collisionTypes.enemy.rawValue
        enemy5.physicsBody?.contactTestBitMask = collisionTypes.player.rawValue
        enemy5.physicsBody?.collisionBitMask = collisionTypes.player.rawValue
        
        
        let obstacle3 = Obstacles(x: Int(self.frame.maxY) - 300, y: (Int(self.frame.minX) / 4) - 30, img: "desk", typeOfObstacles: "idk?", id: 3)
        obstacle3.physicsBody?.categoryBitMask = collisionTypes.obstacle.rawValue
        
        let platform5 : [SKNode] = makePlatform(x: Int(self.frame.maxY) - 300 , y: -50, numBoxes: 4, numQBoxes: 1)
        for box in platform5{
            box.physicsBody?.categoryBitMask = collisionTypes.platform.rawValue
            box.physicsBody?.contactTestBitMask = 0
            box.physicsBody?.collisionBitMask = collisionTypes.player.rawValue
            if((box as! PlatformBox).isQuestion){
                (box as! PlatformBox).powerType = "SpeedBoost"
            }
        }
        
        let enemy6 = Enemy(x: Int(self.frame.maxY) - 300  , y:  100 , img: "umrigar", typeOfEnemy: "thwomp", id: 6)
        enemy6.physicsBody?.categoryBitMask = collisionTypes.enemy.rawValue
        enemy6.physicsBody?.contactTestBitMask = collisionTypes.player.rawValue
        enemy6.physicsBody?.collisionBitMask = collisionTypes.player.rawValue | collisionTypes.obstacle.rawValue
        
        
       
        //platform with goomba underneath and obstacle on platform
        
        let platform6 : [SKNode] = makePlatform(x: Int(self.frame.maxY) - 300 , y: -50, numBoxes: 8, numQBoxes: 0)
        for box in platform6{
            box.physicsBody?.categoryBitMask = collisionTypes.platform.rawValue
            box.physicsBody?.contactTestBitMask = 0
            box.physicsBody?.collisionBitMask = collisionTypes.player.rawValue
        }
        
        //below platform
        let enemy7 = Enemy(x: Int(self.frame.maxY) - 235 , y: (Int(self.frame.minX) / 4) - 30 , img: "madden-1", typeOfEnemy: "goomba", id: 7)
        enemy7.physicsBody?.categoryBitMask = collisionTypes.enemy.rawValue
        enemy7.physicsBody?.contactTestBitMask = collisionTypes.player.rawValue
        enemy7.physicsBody?.collisionBitMask = collisionTypes.player.rawValue
        
            //on platform
        
        let obstacle4 = Obstacles(x: Int(self.frame.maxY) - 240, y: -50 + 30, img: "desk", typeOfObstacles: "idk?", id: 4)
        obstacle4.physicsBody?.categoryBitMask = collisionTypes.obstacle.rawValue
        
        
        
        //obstacle before flying enemy to jump on
        let obstacle5 = Obstacles(x: Int(self.frame.maxY) - 300, y: (Int(self.frame.minX) / 4) - 30, img: "chair", typeOfObstacles: "idk?", id: 5)
        obstacle5.physicsBody?.categoryBitMask = collisionTypes.obstacle.rawValue
        
        let enemy8 = Enemy(x: Int(self.frame.maxY) - 300 , y: (Int(self.frame.minX) / 4) + 190, img: "head", typeOfEnemy: "fly", id: 8)
        enemy8.physicsBody?.categoryBitMask = collisionTypes.enemy.rawValue
        enemy8.physicsBody?.contactTestBitMask = collisionTypes.player.rawValue
        enemy8.physicsBody?.collisionBitMask = collisionTypes.player.rawValue
        
        
        let platform7 : [SKNode] = makePlatform(x: Int(self.frame.maxY) - 150 , y:  50, numBoxes: 4, numQBoxes: 0)
        for box in platform7{
            box.physicsBody?.categoryBitMask = collisionTypes.platform.rawValue
            box.physicsBody?.contactTestBitMask = 0
            box.physicsBody?.collisionBitMask = collisionTypes.player.rawValue
        }
        
        
        //collectable on platform4
        let collectible2 = Collectable(x: Int(self.frame.maxY) - 105, y: 80, img: "stackOverflowLogo")
        collectible2.physicsBody?.categoryBitMask = collisionTypes.collectible.rawValue
        collectible2.physicsBody?.contactTestBitMask = collisionTypes.player.rawValue
        collectible2.physicsBody?.collisionBitMask = 0
        
        
        let enemy9 = Enemy(x: Int(self.frame.maxY) - 300 , y:  Int(self.frame.maxX / 2) - 125 , img: "lander", typeOfEnemy: "fly", id: 4)
        enemy9.physicsBody?.categoryBitMask = collisionTypes.enemy.rawValue
        enemy9.physicsBody?.contactTestBitMask = collisionTypes.player.rawValue
        enemy9.physicsBody?.collisionBitMask = collisionTypes.player.rawValue
        
        
        let endFlag = Obstacles(x: Int(self.frame.maxY) - 300, y: (Int(self.frame.minX) / 4) - 30, img: "endFlag", typeOfObstacles: "idk?", id: 8)
        endFlag.physicsBody?.categoryBitMask = collisionTypes.obstacle.rawValue
        endFlag.physicsBody?.contactTestBitMask = collisionTypes.player.rawValue
        endFlag.physicsBody?.collisionBitMask = collisionTypes.player.rawValue
        
        
        endFlag.name = "flag"
        endFlag.size.width = 300
        endFlag.size.height = self.frame.maxY / 4
        
        
        let now = DispatchTime.now()
        let nanoTime = now.uptimeNanoseconds - startOfLevel.uptimeNanoseconds // Difference in nano seconds
        let timeInterval = Double(nanoTime) / 1_000_000_000
        if(Int(timeInterval) == 1 && intervalsUsed.contains(Int(timeInterval)) == false ){
            intervalsUsed.append(Int(timeInterval))
            enemy1.zPosition = 1
            addChild(enemy1)
            
<<<<<<< Updated upstream
            //addChild(endFlag)
=======
            addChild(endFlag)
>>>>>>> Stashed changes
        
        }
        if(Int(timeInterval) == 7 && intervalsUsed.contains(Int(timeInterval)) == false){
            intervalsUsed.append(Int(timeInterval))
            for node in platform1{
                addChild(node)
            }
           
        }
        
        if(Int(timeInterval) == 10 && intervalsUsed.contains(Int(timeInterval)) == false){
            intervalsUsed.append(Int(timeInterval))
            addChild(enemy2)
        }
    
        
        
        
        if(Int(timeInterval) == 17 && intervalsUsed.contains(Int(timeInterval)) == false){
            intervalsUsed.append(Int(timeInterval))
            
            self.notOnScreen.append(enemy1.description)
            removeEnemy()
            
            for node in platform2{
                addChild(node)
            }
            
            
        }
        
        if(Int(timeInterval) == 24 && intervalsUsed.contains(Int(timeInterval)) == false){
            intervalsUsed.append(Int(timeInterval))
            
            addChild(obstacle1)
            
            self.notOnScreen.append(enemy2.description)
            removeEnemy()
            for node in platform2{
                self.notOnScreen.append(node.description)
            }
            removePlatform()
            
        }
        
        
        if(Int(timeInterval) == 27 && intervalsUsed.contains(Int(timeInterval)) == false){
            intervalsUsed.append(Int(timeInterval))
           
            addChild(enemy3)
           
            
        }
        
        if(Int(timeInterval) == 29 && intervalsUsed.contains(Int(timeInterval)) == false){
            intervalsUsed.append(Int(timeInterval))
           
            addChild(obstacle2)
            for node in platform2{
                self.notOnScreen.append(node.description)
            }
            removePlatform()
            
            
        }
        
        if(Int(timeInterval) == 38 && intervalsUsed.contains(Int(timeInterval)) == false){
            intervalsUsed.append(Int(timeInterval))
            
            for node in platform3{
                addChild(node)
            }
            for node in platform4{
                addChild(node)
            }
            addChild(collectible1)
            self.notOnScreen.append(enemy3.description)
            removeEnemy()
            self.notOnScreen.append(obstacle1.description)
            removeObstacle()
            
            
            
        }
        
        if(Int(timeInterval) == 44 && intervalsUsed.contains(Int(timeInterval)) == false){
            intervalsUsed.append(Int(timeInterval))
            
            addChild(enemy4)
            self.notOnScreen.append(obstacle2.description)
            removeObstacle()
            
        }
        
        if(Int(timeInterval) == 49 && intervalsUsed.contains(Int(timeInterval)) == false){
            intervalsUsed.append(Int(timeInterval))
            
            addChild(enemy5)
            
            
        }
        
        if(Int(timeInterval) == 53 && intervalsUsed.contains(Int(timeInterval)) == false){
            intervalsUsed.append(Int(timeInterval))
            
            addChild(obstacle3)
            
            for node in platform3{
                self.notOnScreen.append(node.description)
            }
            for node in platform4{
                self.notOnScreen.append(node.description)
            }
            removePlatform()
            self.notOnScreen.append(collectible1.description)
            
            

        }
        
        if(Int(timeInterval) == 56 && intervalsUsed.contains(Int(timeInterval)) == false){
            intervalsUsed.append(Int(timeInterval))
           
            for node in platform5{
                addChild(node)
            }
        }

        
        
        if(Int(timeInterval) == 60 && intervalsUsed.contains(Int(timeInterval)) == false){
            intervalsUsed.append(Int(timeInterval))
            
            addChild(enemy6)
            self.notOnScreen.append(enemy4.description)
            removeEnemy()
          
        }
        
        if(Int(timeInterval) == 65 && intervalsUsed.contains(Int(timeInterval)) == false){
            intervalsUsed.append(Int(timeInterval))
            
            addChild(enemy7)
            addChild(obstacle4)
            for node in platform6{
                addChild(node)
            }
            
            self.notOnScreen.append(enemy5.description)
            removeEnemy()
          
        }
        
        if(Int(timeInterval) == 72 && intervalsUsed.contains(Int(timeInterval)) == false){
            intervalsUsed.append(Int(timeInterval))
                       
           self.notOnScreen.append(obstacle3.description)
           removeObstacle()
           addChild(obstacle5)
    
        }
        
        if(Int(timeInterval) == 74 && intervalsUsed.contains(Int(timeInterval)) == false){
            intervalsUsed.append(Int(timeInterval))
            
           addChild(enemy8)
            
        }
        
        if(Int(timeInterval) == 79 && intervalsUsed.contains(Int(timeInterval)) == false){
            intervalsUsed.append(Int(timeInterval))
            for node in platform5{
                self.notOnScreen.append(node.description)
            }
            removePlatform()
            
            self.notOnScreen.append(enemy6.description)
            removeEnemy()
            
            for node in platform7{
                addChild(node)
            }
            addChild(collectible2)
            
        }
        
        if(Int(timeInterval) == 84 && intervalsUsed.contains(Int(timeInterval)) == false){
            intervalsUsed.append(Int(timeInterval))
            
            self.notOnScreen.append(enemy7.description)
            removeEnemy()
            self.notOnScreen.append(obstacle5.description)
            removeObstacle()
            for node in platform6{
                self.notOnScreen.append(node.description)
            }
            removePlatform()
            
           addChild(enemy9)
           
        }
        
        
        if(Int(timeInterval) == 88 && intervalsUsed.contains(Int(timeInterval)) == false){
            intervalsUsed.append(Int(timeInterval))
            
            
            self.notOnScreen.append(obstacle5.description)
            removeObstacle()
            
           addChild(endFlag)
           
        }
        
      return Int(timeInterval)
    }
    
    func removeEnemy(){
        self.enumerateChildNodes(withName: "Enemy", using: ({
            (node,error) in
            if(self.notOnScreen.contains(node.description)){
                self.notOnScreen.remove(at: self.notOnScreen.index(of: node.description)!)
                node.removeFromParent()
            }
        }) )
    }
    
    func removeObstacle(){
        self.enumerateChildNodes(withName: "Obstacle", using: ({
            (node,error) in
            if(self.notOnScreen.contains(node.description)){
                self.notOnScreen.remove(at: self.notOnScreen.index(of: node.description)!)
                node.removeFromParent()
            }
        }) )
    }
    
    func removeCollectable(){
        self.enumerateChildNodes(withName: "collectible", using: ({
            (node,error) in
            if(self.notOnScreen.contains(node.description)){
                self.notOnScreen.remove(at: self.notOnScreen.index(of: node.description)!)
                node.removeFromParent()
            }
        }) )
    }
    
    func removePlatform(){
        self.enumerateChildNodes(withName: "Platform", using: ({
            (node,error) in
        //    print("remove platform")
         //   print("list: " + self.notOnScreen.description)
            if(self.notOnScreen.contains(node.description)){
         //       print("removing box")
                self.notOnScreen.remove(at: self.notOnScreen.index(of: node.description)!)
                node.removeFromParent()
            }
        }) )
    }
    
    
    func createBackground(){
        for i in 0...3 {
            let background = SKSpriteNode(imageNamed: backgroundImage)
            background.name = "Background"
            background.size = CGSize(width: (self.scene?.size.width)!, height: (self.scene?.size.height)!)
            background.anchorPoint =  CGPoint(x: 0.5, y: 0.5)
           background.position = CGPoint(x: CGFloat(i)*background.size.width, y: 0)
            background.zPosition = 0
            self.addChild((background))
        }
    }
    
    func moveBackground(){
        self.enumerateChildNodes(withName: "Background", using: ({
            (node,error) in

            node.position.x -= 2

            if node.position.x < -((self.scene?.size.width)!){
                node.position.x += (self.scene?.size.width)! * 3
            }
        }) )
    }
    
    func moveNodesWithBackground(){
        self.enumerateChildNodes(withName: "Enemy", using: ({
            (node,error) in
            (node as! Enemy).idleMovement()
        }) )
        
        self.enumerateChildNodes(withName: "Obstacle", using: ({
            (node,error) in
            node.position.x -= 1
        }) )
        
        self.enumerateChildNodes(withName: "Platform", using: ({
            (node,error) in
            node.position.x -= 1
        }) )
        
        self.enumerateChildNodes(withName: "collectible", using: ({
            (node,error) in
            node.position.x -= 1
        }) )
        
        self.enumerateChildNodes(withName: "flag", using: ({
            (node,error) in
            node.position.x -= 1
        }) )
        
        self.enumerateChildNodes(withName: "powerItem", using: ({
            (node,error) in
            node.position.x -= 1
        }) )
        
    }

    func makePlatform(x:Int, y:Int, numBoxes:Int, numQBoxes:Int) -> [SKNode] {
        let img_width = 20
        var platformBoxes : [SKNode] = []
        for i in 0...numBoxes {
            let x_coord = x + (i*img_width)
           // print("x-coord: " + String(x_coord))
            let platBox = PlatformBox(x:x_coord,y:y,isQ:false)
            //self.addChild(platBox)
            platformBoxes.append(platBox)
        }
        let q_x_coord = x + ((numBoxes+1)*img_width)
        let questionBox = PlatformBox(x:q_x_coord,y:y,isQ:true)
        //self.addChild(questionBox)
        if numQBoxes != 0 {
            platformBoxes.append(questionBox)
        }
       // print("PLATFORM BOXES: " + platformBoxes.description)
        return platformBoxes
    }
    func makeFinalScore() -> Int {
        return self.score + (self.collected.count * 50)
    }
}
