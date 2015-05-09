//
//  Character.swift
//  Walker
//
//  Created by Morgan Wilde on 02/05/2015.
//  Copyright (c) 2015 Morgan Wilde. All rights reserved.
//

import SceneKit

struct Mask {
    static let SCENE        = 0x1 << 1
    static let FLOOR        = 0x1 << 2
    static let CHARACTER    = 0x1 << 3
    static let OBSTACLE     = 0x1 << 4
}

class Character: SCNNode  {
    
    var headDimensions = Dimensions(width: 6, height: 6, length: 6)
    var torsoDimensions = Dimensions(width: 10, height: 15, length: 6)
    var armDimensions = Dimensions(width: 3, height: 3, length: 12)
    var legDimensions = Dimensions(width: 4, height: 15, length: 4)
    
    let head, torso, armLeft, armRight, legLeft, legRight: SCNNode
    
    init(pivot: SCNMatrix4) {
        // Torso
        let torsoGeometry = SCNBox(width: 6, height: 10, length: 15, chamferRadius: 0)
        torsoGeometry.firstMaterial = Constants.redColorMaterial
        torso = SCNNode(geometry: torsoGeometry)
        
        // Head
        let headGeometry = SCNBox(width: 6, height: 6, length: 6, chamferRadius: 0)
        headGeometry.firstMaterial = Constants.blueColorMaterial
        head = SCNNode(geometry: headGeometry)
        head.position = SCNVector3(x: 0, y: 0, z: Float(torsoGeometry.length)/2 + Float(headGeometry.length)/2)
        
        // Arms
        let armGeometry = SCNBox(width: 3, height: 3, length: 12, chamferRadius: 0)
        armGeometry.firstMaterial = Constants.grayColorMaterial
        
        armLeft = SCNNode(geometry: armGeometry)
        armLeft.position = SCNVector3(x: 0, y: 0, z: Float(torsoGeometry.length)/2)
        armLeft.pivot = SCNMatrix4MakeTranslation(0, Float(torsoGeometry.height)/2 + Float(armGeometry.height)/2, Float(armGeometry.length)/2)
        armLeft.rotation = SCNVector4(x: 0, y: 1, z: 0, w: -PI/6)
        
        armRight = SCNNode(geometry: armGeometry)
        armRight.position = SCNVector3(x: 0, y: 0, z: Float(torsoGeometry.length)/2)
        armRight.pivot = SCNMatrix4MakeTranslation(0, -Float(torsoGeometry.height)/2 - Float(armGeometry.height)/2, Float(armGeometry.length)/2)
        armRight.rotation = SCNVector4(x: 0, y: 1, z: 0, w: PI/6)
        
        // Legs
        let legGeometry = SCNBox(width: 4, height: 4, length: 15, chamferRadius: 0)
        legGeometry.firstMaterial = Constants.blueColorMaterial
        
        legRight = SCNNode(geometry: legGeometry)
        legRight.position = SCNVector3(x: 0, y: Float(torsoGeometry.height)/2 - Float(legGeometry.height)/2, z: 0)
        legRight.pivot = SCNMatrix4MakeTranslation(0, 0, Float(legGeometry.length))
        legRight.rotation = SCNVector4(x: 0, y: 1, z: 0, w: -PI/12)
        
        legLeft = SCNNode(geometry: legGeometry)
        legLeft.position = SCNVector3(x: 0, y: -Float(torsoGeometry.height)/2 + Float(legGeometry.height)/2, z: 0)
        legLeft.pivot = SCNMatrix4MakeTranslation(0, 0, Float(legGeometry.length))
        legLeft.rotation = SCNVector4(x: 0, y: 1, z: 0, w: PI/12)
        
        // Call designate SCNNode constructor
        super.init()
        
        // Build the char
//        self.pivot = pivot
        addChildNode(head)
        addChildNode(torso)
        addChildNode(armLeft)
        addChildNode(armRight)
        addChildNode(legLeft)
        addChildNode(legRight)
        
        // Physics body
        physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.Dynamic, shape: SCNPhysicsShape(node: self, options: nil))
        physicsBody = .dynamicBody()
        physicsBody?.categoryBitMask = Mask.CHARACTER
        physicsBody?.collisionBitMask = Mask.FLOOR
        
        // Create and start animations
        
//        // Animation - legs
//        let legRightAnimation = SCNAction.sequence([
//            SCNAction.rotateToAxisAngle(SCNVector4(x: 0, y: 1, z: 0, w: PI/12), duration: 0.5),
//            SCNAction.rotateToAxisAngle(SCNVector4(x: 0, y: 1, z: 0, w: -PI/12), duration: 0.5)
//            ])
//        let legLeftAnimation = SCNAction.sequence([
//            SCNAction.rotateToAxisAngle(SCNVector4(x: 0, y: 1, z: 0, w: -PI/12), duration: 0.5),
//            SCNAction.rotateToAxisAngle(SCNVector4(x: 0, y: 1, z: 0, w: PI/12), duration: 0.5)
//            ])
//        legRightNode.runAction(SCNAction.repeatActionForever(legRightAnimation))
//        legLeftNode.runAction(SCNAction.repeatActionForever(legLeftAnimation))
//        
//        // Animation - arms
//        let armRightAnimation = SCNAction.sequence([
//            SCNAction.rotateToAxisAngle(SCNVector4(x: 0, y: 1, z: 0, w: -PI/6), duration: 0.5),
//            SCNAction.rotateToAxisAngle(SCNVector4(x: 0, y: 1, z: 0, w: PI/6), duration: 0.5)
//            ])
//        let armLeftAnimation = SCNAction.sequence([
//            SCNAction.rotateToAxisAngle(SCNVector4(x: 0, y: 1, z: 0, w: PI/6), duration: 0.5),
//            SCNAction.rotateToAxisAngle(SCNVector4(x: 0, y: 1, z: 0, w: -PI/6), duration: 0.5)
//            ])
//        armRightNode.runAction(SCNAction.repeatActionForever(armRightAnimation))
//        armLeftNode.runAction(SCNAction.repeatActionForever(armLeftAnimation))
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}