//
//  ViewController.swift
//  Walker
//
//  Created by Morgan Wilde on 02/05/2015.
//  Copyright (c) 2015 Morgan Wilde. All rights reserved.
//

import UIKit
import SceneKit

let PI = Float(M_PI_2)

class ViewController: UIViewController {
    
    @IBOutlet weak var sceneView: SCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = SCNScene()
        
        // Materials
        let redColorMaterial = SCNMaterial()
        redColorMaterial.diffuse.contents = UIColor.redColor()
        let blueColorMaterial = SCNMaterial()
        blueColorMaterial.diffuse.contents = UIColor.blueColor()
        let grayColorMaterial = SCNMaterial()
        grayColorMaterial.diffuse.contents = UIColor.grayColor()
        
        let characterNode = SCNNode()
        let rotationX = SCNMatrix4MakeRotation(60*PI/180, 1, 0, 0)
        let rotationZ = SCNMatrix4MakeRotation(60*PI/180, 0, 0, 1)
        characterNode.pivot = SCNMatrix4Mult(rotationX, rotationZ)
        
        // Torso
        let torsoGeometry = SCNBox(width: 6, height: 10, length: 15, chamferRadius: 0)
        torsoGeometry.firstMaterial = redColorMaterial
        let torsoNode = SCNNode(geometry: torsoGeometry)
        characterNode.addChildNode(torsoNode)
        
        // Head
        let headGeometry = SCNBox(width: 6, height: 6, length: 6, chamferRadius: 0)
        headGeometry.firstMaterial = blueColorMaterial
        let headNode = SCNNode(geometry: headGeometry)
        headNode.position = SCNVector3(x: 0, y: 0, z: Float(torsoGeometry.length)/2 + Float(headGeometry.length)/2)
        characterNode.addChildNode(headNode)
        
        // Arm right
        let armGeometry = SCNBox(width: 3, height: 3, length: 12, chamferRadius: 0)
        armGeometry.firstMaterial = grayColorMaterial
        let armRightNode = SCNNode(geometry: armGeometry)
        armRightNode.position = SCNVector3(x: 0, y: 0, z: Float(torsoGeometry.length)/2)
        armRightNode.pivot = SCNMatrix4MakeTranslation(0, -Float(torsoGeometry.height)/2 - Float(armGeometry.height)/2, Float(armGeometry.length)/2)
        armRightNode.rotation = SCNVector4(x: 0, y: 1, z: 0, w: PI/6)
        characterNode.addChildNode(armRightNode)
        
        // Arm left
        let armLeftNode = SCNNode(geometry: armGeometry)
        armLeftNode.position = SCNVector3(x: 0, y: 0, z: Float(torsoGeometry.length)/2)
        armLeftNode.pivot = SCNMatrix4MakeTranslation(0, Float(torsoGeometry.height)/2 + Float(armGeometry.height)/2, Float(armGeometry.length)/2)
        armLeftNode.rotation = SCNVector4(x: 0, y: 1, z: 0, w: -PI/6)
        characterNode.addChildNode(armLeftNode)
        
        // Leg right
        let legGeometry = SCNBox(width: 4, height: 4, length: 15, chamferRadius: 0)
        legGeometry.firstMaterial = blueColorMaterial
        let legRightNode = SCNNode(geometry: legGeometry)
        legRightNode.position = SCNVector3(x: 0, y: Float(torsoGeometry.height)/2 - Float(legGeometry.height)/2, z: 0)
        legRightNode.pivot = SCNMatrix4MakeTranslation(0, 0, Float(legGeometry.length))
        legRightNode.rotation = SCNVector4(x: 0, y: 1, z: 0, w: -PI/12)
        characterNode.addChildNode(legRightNode)
        
        // Leg left
        let legLeftNode = SCNNode(geometry: legGeometry)
        legLeftNode.position = SCNVector3(x: 0, y: -Float(torsoGeometry.height)/2 + Float(legGeometry.height)/2, z: 0)
        legLeftNode.pivot = SCNMatrix4MakeTranslation(0, 0, Float(legGeometry.length))
        legLeftNode.rotation = SCNVector4(x: 0, y: 1, z: 0, w: PI/12)
        characterNode.addChildNode(legLeftNode)
        
        scene.rootNode.addChildNode(characterNode)
        
        // Animation - legs
        let legRightAnimation = SCNAction.sequence([
            SCNAction.rotateToAxisAngle(SCNVector4(x: 0, y: 1, z: 0, w: PI/12), duration: 0.5),
            SCNAction.rotateToAxisAngle(SCNVector4(x: 0, y: 1, z: 0, w: -PI/12), duration: 0.5)
            ])
        let legLeftAnimation = SCNAction.sequence([
            SCNAction.rotateToAxisAngle(SCNVector4(x: 0, y: 1, z: 0, w: -PI/12), duration: 0.5),
            SCNAction.rotateToAxisAngle(SCNVector4(x: 0, y: 1, z: 0, w: PI/12), duration: 0.5)
            ])
        legRightNode.runAction(SCNAction.repeatActionForever(legRightAnimation))
        legLeftNode.runAction(SCNAction.repeatActionForever(legLeftAnimation))
        
        // Animation - arms
        let armRightAnimation = SCNAction.sequence([
            SCNAction.rotateToAxisAngle(SCNVector4(x: 0, y: 1, z: 0, w: -PI/6), duration: 0.5),
            SCNAction.rotateToAxisAngle(SCNVector4(x: 0, y: 1, z: 0, w: PI/6), duration: 0.5)
            ])
        let armLeftAnimation = SCNAction.sequence([
            SCNAction.rotateToAxisAngle(SCNVector4(x: 0, y: 1, z: 0, w: PI/6), duration: 0.5),
            SCNAction.rotateToAxisAngle(SCNVector4(x: 0, y: 1, z: 0, w: -PI/6), duration: 0.5)
            ])
        armRightNode.runAction(SCNAction.repeatActionForever(armRightAnimation))
        armLeftNode.runAction(SCNAction.repeatActionForever(armLeftAnimation))
        
        // Camera
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3Make(0, 0, 50)
        cameraNode.camera?.orthographicScale = 50
        cameraNode.camera?.usesOrthographicProjection = true
        
        scene.rootNode.addChildNode(cameraNode)
        
        sceneView.scene = scene
        sceneView.autoenablesDefaultLighting = true
        sceneView.allowsCameraControl = true
    }
    
}