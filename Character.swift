//
//  Character.swift
//  Walker
//
//  Created by Morgan Wilde on 02/05/2015.
//  Copyright (c) 2015 Morgan Wilde. All rights reserved.
//

import SceneKit

struct Mask {
    static let SCENE        = 1
    static let FLOOR        = 2
    static let CHARACTER    = 3
    static let OBSTACLE     = 4
}

class Character: SCNNode  {
    
    let LIMB_ROTATE_DURATION = 0.5 as NSTimeInterval
    let LEG_ROTATION = PI/12
    let ARM_ROTATION = PI/6
    let SPEED = 14.5 // points / second
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
        
        // Physics body // ToDo iskaiciuot isskleistu ranku ilgi // ToDo -5 = because too fat to fit between obstacles
        geometry = SCNBox(width: headDimensions.length + torsoDimensions.length + legDimensions.length - 5,
            height: headDimensions.width + torsoDimensions.width + legDimensions.width - 5,
            length: headDimensions.height + torsoDimensions.height + legDimensions.height + 8,
            chamferRadius: 0)
        geometry!.firstMaterial!.diffuse.contents = UIColor.clearColor()
        physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.Dynamic, shape: SCNPhysicsShape(geometry: geometry!, options: nil))
        physicsBody?.categoryBitMask = Mask.CHARACTER
        physicsBody?.collisionBitMask = Mask.FLOOR | Mask.OBSTACLE
        
        // Weird physicsBody params (might need to prevent the friction)
        physicsBody?.restitution = 0
        physicsBody?.angularDamping = 100000
        physicsBody?.angularVelocity = SCNVector4Make(0, 0, 0, 0)
        physicsBody?.friction = 0
        
        
        let myself = self
        runAction(SCNAction.sequence([
            SCNAction.runBlock({ (myself) -> Void in
                self.moveBy(69, y: 0, z: 0)
            })
        ]))
    }

    // ToDo pre-create and re-use all the actions
    // ToDo if stop() action is in progress, remove and continue the movement ---- re-use rotateTo
    // Stop is called automatically when the movement is finished or the action is cancelled
    func moveBy(x: Float, y: Float, z: Float) {
        // Rotation actions
        let rotateArmNeg = SCNAction.rotateToAxisAngle(SCNVector4(x: 0, y: 1, z: 0, w: -ARM_ROTATION), duration: LIMB_ROTATE_DURATION)
        let rotateArmPos = SCNAction.rotateToAxisAngle(SCNVector4(x: 0, y: 1, z: 0, w: ARM_ROTATION), duration: LIMB_ROTATE_DURATION)
        let rotateLegNeg = SCNAction.rotateToAxisAngle(SCNVector4(x: 0, y: 1, z: 0, w: -LEG_ROTATION), duration: LIMB_ROTATE_DURATION)
        let rotateLegPos = SCNAction.rotateToAxisAngle(SCNVector4(x: 0, y: 1, z: 0, w: LEG_ROTATION), duration: LIMB_ROTATE_DURATION)
        
        // Repeating limb rotation actions
        let armLeftRotation = SCNAction.repeatActionForever(SCNAction.sequence([rotateArmPos, rotateArmNeg]))
        let armRightRotation = SCNAction.repeatActionForever(SCNAction.sequence([rotateArmNeg, rotateArmPos]))
        let legLeftRotation = SCNAction.repeatActionForever(SCNAction.sequence([rotateLegNeg, rotateLegPos]))
        let legRightRotation = SCNAction.repeatActionForever(SCNAction.sequence([rotateLegPos, rotateLegNeg]))
        
        // Distance and duration
        let target = SCNVector3Make(position.x + x, position.y + y, position.z + z)
        let distance = sqrt(pow(target.x - position.x, 2) + pow(target.y - position.y, 2) + pow(target.z - position.z, 2))
        let duration = NSTimeInterval(distance / Float(SPEED))
        println("Move distance: \(distance) in duration: \(duration)")
        
        // Character movement action
        let charMovement = SCNAction.moveByX(CGFloat(x), y: CGFloat(y), z: CGFloat(z), duration: duration)
        
        let myself = self as Character
        // Limb movement action
        let limbMovement = SCNAction.runBlock({ (myself) -> Void in
            self.armLeft.runAction(armLeftRotation)
            self.armRight.runAction(armRightRotation)
            self.legLeft.runAction(legLeftRotation)
            self.legRight.runAction(legRightRotation)
        })
        
        // Char movement action
        let groupAction = SCNAction.runBlock({ (myself) -> Void in
            // Following is a group of actions repeating action
            self.runAction(SCNAction.group([
                limbMovement,
                charMovement
                ])) {
                    self.stop()
            }
        }, queue: dispatch_get_main_queue())
        
        // Following will be run once
        runAction(groupAction)
    }
    
    // Always runs on the UI thread
    func stop() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            println("Character.stop() invoked")
            // Remove all actions (movements/rotations)
            self.removeAllActions()
            self.armLeft.removeAllActions()
            self.armRight.removeAllActions()
            self.legLeft.removeAllActions()
            self.legRight.removeAllActions()
            
            // Rotate limbs back into the default position
            self.rotateTo(self.armLeft, wantedRotation: 0, fullRotation: self.ARM_ROTATION)
            self.rotateTo(self.armRight, wantedRotation: 0, fullRotation: self.ARM_ROTATION)
            self.rotateTo(self.legLeft, wantedRotation: 0, fullRotation: self.LEG_ROTATION)
            self.rotateTo(self.legRight, wantedRotation: 0, fullRotation: self.LEG_ROTATION)
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