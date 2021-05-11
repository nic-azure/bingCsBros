//
//  Character.swift
//  bingCsBros
//
//  Created by Theresa Gundel on 4/14/21.
//

import UIKit
import SpriteKit

class Character: SKSpriteNode {
    var lives: Int!
    var hasImmunity: Bool!
    var charSpeed: CGFloat!
    var jumpCount: Int!
    var powerTimer: Int!
    var isGoingRight: Bool!
    
    init(x:Int, y:Int, img:UIImage) {
        let texture = SKTexture(image: img)
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.position = CGPoint(x: x, y: y)
        self.lives = 3
        self.hasImmunity = false
        self.charSpeed = 2.0
        self.jumpCount = 0
        self.powerTimer = 0
        self.isGoingRight = false
        //physics body should be the size of the img once we have one
        //SKPhysicsBody(circleOfRadius: self.size.width / 2)
        self.size.width = 64
        self.size.height = 75
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        //character stays upright
        self.physicsBody?.allowsRotation = false
        //next two are needed to make gravity work
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = true
        self.physicsBody?.friction = 1
        self.zPosition = 1
        self.size.width = 64
        self.size.height = 75

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func moveForward(){
        self.position.x += charSpeed
        self.isGoingRight = true
    }

    func moveBackward(){
        self.position.x -= charSpeed
        self.isGoingRight = false
    }
    
    func jump(){
        //we can change dy if we want
        if(self.jumpCount >= 2) {
            return
        }
        self.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 80.0))
        self.jumpCount += 1
    }
}
