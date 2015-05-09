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
    
    let LIMB_ROTATE_DURATION = 0.5 as NSTimeInterval
    let LEG_ROTATION = PI/12
    let ARM_ROTATION = PI/6
    let headDimensions = Dimensions(width: 6, height: 6, length: 6)
    let torsoDimensions = Dimensions(width: 10, height: 15, length: 6)
    let armDimensions = Dimensions(width: 3, height: 12, length: 3)
    let legDimensions = Dimensions(width: 4, height: 15, length: 4)
    
    let head, torso, armLeft, armRight, legLeft, legRight: SCNNode
    
    override init() {
        // Torso
        let torsoGeometry = SCNBox(width: torsoDimensions.length, height: torsoDimensions.width, length: torsoDimensions.height, chamferRadius: 0)
        torsoGeometry.firstMaterial = Constants.redColorMaterial
        torso = SCNNode(geometry: torsoGeometry)
        
        // Head
        let headGeometry = SCNBox(width: headDimensions.length, height: headDimensions.width, length: headDimensions.height, chamferRadius: 0)
        headGeometry.firstMaterial = Constants.blueColorMaterial
        head = SCNNode(geometry: headGeometry)
        head.position = SCNVector3(x: 0, y: 0, z: Float(torsoGeometry.length)/2 + Float(headGeometry.length)/2)
        
        // Arms
        let armGeometry = SCNBox(width: armDimensions.length, height: armDimensions.width, length: armDimensions.height, chamferRadius: 0)
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
        let legGeometry = SCNBox(width: legDimensions.length, height: legDimensions.width, length: legDimensions.height, chamferRadius: 0)
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
        addChildNode(head)
        addChildNode(torso)
        addChildNode(armLeft)
        addChildNode(armRight)
        addChildNode(legLeft)
        addChildNode(legRight)
        
        // Physics body // ToDo iskaiciuot isskleistu ranku ilgi
        geometry = SCNBox(width: headDimensions.length + torsoDimensions.length + legDimensions.length,
            height: headDimensions.width + torsoDimensions.width + legDimensions.width,
            length: headDimensions.height + torsoDimensions.height + legDimensions.height + 9,
            chamferRadius: 0)
        geometry!.firstMaterial!.diffuse.contents = UIColor.clearColor()
        physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.Dynamic, shape: SCNPhysicsShape(geometry: geometry!, options: nil))
        physicsBody?.categoryBitMask = Mask.CHARACTER
        physicsBody?.collisionBitMask = Mask.FLOOR
        
        // Leg animations
        var rotateNeg = SCNAction.rotateToAxisAngle(SCNVector4(x: 0, y: 1, z: 0, w: -LEG_ROTATION), duration: LIMB_ROTATE_DURATION)
        var rotatePos = SCNAction.rotateToAxisAngle(SCNVector4(x: 0, y: 1, z: 0, w: LEG_ROTATION), duration: LIMB_ROTATE_DURATION)
        let legLeftAnimation = SCNAction.sequence([rotateNeg, rotatePos])
        let legRightAnimation = SCNAction.sequence([rotatePos, rotateNeg])
        
        legLeft.runAction(SCNAction.repeatActionForever(legLeftAnimation))
        legRight.runAction(SCNAction.repeatActionForever(legRightAnimation))
        
        // Arm animations
        rotateNeg = SCNAction.rotateToAxisAngle(SCNVector4(x: 0, y: 1, z: 0, w: -ARM_ROTATION), duration: LIMB_ROTATE_DURATION)
        rotatePos = SCNAction.rotateToAxisAngle(SCNVector4(x: 0, y: 1, z: 0, w: ARM_ROTATION), duration: LIMB_ROTATE_DURATION)
        let armLeftAnimation = SCNAction.sequence([rotatePos, rotateNeg])
        let armRightAnimation = SCNAction.sequence([rotateNeg, rotatePos])
        
        armLeft.runAction(SCNAction.repeatActionForever(armLeftAnimation))
        armRight.runAction(SCNAction.repeatActionForever(armRightAnimation))
        
        var wtf = self
        
        runAction(SCNAction.sequence([
            SCNAction.waitForDuration(3.123),
            SCNAction.runBlock({ (wtf) -> Void in
                self.stop()
            })]))
    }

    func move() {
        
    }
    
    func stop() {
        // Remove existing actions
        legLeft.removeAllActions()
        legRight.removeAllActions()
        armLeft.removeAllActions()
        armRight.removeAllActions()

        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.rotateTo(self.legLeft, wantedRotation: 0, fullRotation: self.LEG_ROTATION)
            self.rotateTo(self.legRight, wantedRotation: 0, fullRotation: self.LEG_ROTATION)
            self.rotateTo(self.armLeft, wantedRotation: 0, fullRotation: self.ARM_ROTATION)
            self.rotateTo(self.armRight, wantedRotation: 0, fullRotation: self.ARM_ROTATION)
        })
    }
    
    func rotateTo(node: SCNNode, wantedRotation: Float, fullRotation: Float) {
        let targetDuration = abs(node.rotation.w) * Float(LIMB_ROTATE_DURATION) / abs(fullRotation)

        let rotate = SCNAction.rotateToAxisAngle(SCNVector4(x: 0, y: 1, z: 0, w: wantedRotation), duration: NSTimeInterval(targetDuration))
        node.runAction(rotate)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
    
    
    
    
    
    
}