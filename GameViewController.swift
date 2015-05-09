//
//  ViewController.swift
//  Walker
//
//  Created by Morgan Wilde on 02/05/2015.
//  Copyright (c) 2015 Morgan Wilde. All rights reserved.
//

import UIKit
import SceneKit

// Constants - numeric
let PI = Float(M_PI_2)

// Constants - materials
struct Constants {
    static let redColorMaterial = ColorMaterial(UIColor.redColor())
    static let blueColorMaterial = ColorMaterial(UIColor.blueColor())
    static let grayColorMaterial = ColorMaterial(UIColor.grayColor())
    static let lightGrayColorMaterial = ColorMaterial(UIColor.lightGrayColor())
}

func MatrixVectorProduct(matrix: SCNMatrix4, vector: SCNVector4) -> SCNVector4 {
    let x = matrix.m11 * vector.x + matrix.m12 * vector.y + matrix.m13 * vector.z + matrix.m14 + vector.w;
    let y = matrix.m21 * vector.x + matrix.m22 * vector.y + matrix.m23 * vector.z + matrix.m24 + vector.w;
    let z = matrix.m31 * vector.x + matrix.m32 * vector.y + matrix.m33 * vector.z + matrix.m34 + vector.w;
    let w = matrix.m41 * vector.x + matrix.m42 * vector.y + matrix.m43 * vector.z + matrix.m44 + vector.w;
    
    return SCNVector4(x: x, y: y, z: z, w: w)
}

class GameViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var sceneView: SCNView!
    
    // Views
    var scene = SCNScene()
    var gridNode = SCNNode()
    
    // Models
    var grid = Grid()
    
    // Properties
    var perspectiveRotationX = SCNMatrix4MakeRotation(120*PI/180, 1, 0, 0)
    var perspectiveRotationZ = SCNMatrix4MakeRotation(60*PI/180, 0, 0, 1)
    var perspectiveRotation: SCNMatrix4 {
        return SCNMatrix4Mult(perspectiveRotationX, perspectiveRotationZ)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let character = Character(pivot: perspectiveRotation)
        character.position = SCNVector3(x: 0, y: -80, z: 0)
        
        
        // Grid
        createGridViews()
        
        gridNode.addChildNode(character)
    
        
        // Obstacles
        createObstacleAtLocation(6, y: 6, height: 1) // Left wall
        createObstacleAtLocation(5, y: 6, height: 2)
        createObstacleAtLocation(4, y: 6, height: 3)
        createObstacleAtLocation(3, y: 6, height: 1)
        createObstacleAtLocation(2, y: 6, height: 2)
        createObstacleAtLocation(1, y: 6, height: 1)
        createObstacleAtLocation(0, y: 6, height: 1)
        
        createObstacleAtLocation(6, y: 5, height: 1) // Front wall
        createObstacleAtLocation(6, y: 4, height: 1)
        createObstacleAtLocation(6, y: 2, height: 1)
        createObstacleAtLocation(6, y: 1, height: 1)
        createObstacleAtLocation(6, y: 0, height: 1)
        
//        // Obstacles
//        let obstacleGeometry = SCNBox(
//            width: 1 * (cellGeometry.width + 0.5),
//            height: 6 * (cellGeometry.height + 0.5),
//            length: 2 * cellGeometry.height,
//            chamferRadius: 0.5)
//        let obstacleMaterial = SCNMaterial()
//        obstacleMaterial.diffuse.contents = UIColor.orangeColor()
//        obstacleGeometry.firstMaterial = obstacleMaterial
//        let obstacleNode = SCNNode(geometry: obstacleGeometry)
//        obstacleNode.pivot = SCNMatrix4MakeTranslation(
//            -Float(obstacleGeometry.width),
//            -Float(obstacleGeometry.height) - Float(obstacleGeometry.width)/2,
//            -Float(obstacleGeometry.length/2) - Float(cellGeometry.length)/2)
//        gridNode.addChildNode(obstacleNode)
//        
//        scene.rootNode.addChildNode(gridNode)
        
        var vector3 = scene.physicsWorld.gravity
        var vector4 = SCNVector4Make(vector3.x, vector3.y, vector3.z, 0)

        println("\(vector3.x) \(vector3.y) \(vector3.z)")
        vector4 = MatrixVectorProduct(perspectiveRotation, vector4)
        vector3 = SCNVector3Make(vector4.x, vector4.y, vector4.z)
        println("\(vector3.x) \(vector3.y) \(vector3.z)")
        scene.physicsWorld.gravity = SCNVector3Make(0, 0, -300)
        
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLightTypeAmbient
        ambientLightNode.light!.color = UIColor(white: 0.5, alpha: 1.0)
        scene.rootNode.addChildNode(ambientLightNode)
        
        let shadowLightNode = SCNNode()
        
        shadowLightNode.light = SCNLight()
        shadowLightNode.light!.type = SCNLightTypeSpot
        shadowLightNode.light!.castsShadow = true
        shadowLightNode.light!.shadowColor = UIColor(white: 0, alpha: 1.0)
        shadowLightNode.light!.spotInnerAngle = 20
        shadowLightNode.light!.spotOuterAngle = 30
        
        shadowLightNode.position = SCNVector3Make(0, 40, 40)
        shadowLightNode.rotation = SCNVector4Make(1, 0, 0, CFloat(-M_PI_4))
        
        scene.rootNode.addChildNode(shadowLightNode)
        
        // Camera
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3Make(0, 0, 50)
        cameraNode.camera?.orthographicScale = 100
        cameraNode.camera?.usesOrthographicProjection = true
        cameraNode.camera?.zFar = 400
        cameraNode.camera?.zNear = -200
        
        scene.rootNode.addChildNode(cameraNode)
        
        sceneView.scene = scene
        sceneView.allowsCameraControl = true
    }
    
    func createGridViews() {
        // Find the center
        let horizontalMiddle = grid.width / 2
        let verticalMiddle = grid.height / 2
        
        gridNode.pivot = SCNMatrix4Mult(perspectiveRotation, SCNMatrix4MakeTranslation(0, 0, 15+15/2))
        
        let cellGeometry = SCNBox(width: 16, height: 16, length: 3, chamferRadius: 0)
        let cellMaterial = SCNMaterial()
        cellMaterial.diffuse.contents = UIImage(named: "cell-background")
        cellGeometry.firstMaterial = cellMaterial
        
        for var vertical = -verticalMiddle; vertical <= verticalMiddle; vertical++ {
            for var horizontal = -horizontalMiddle; horizontal <= horizontalMiddle; horizontal++ {
                
                let x = Float(horizontal)
                let y = Float(vertical)
                
                let cellNode = SCNNode(geometry: cellGeometry)
                cellNode.position = SCNVector3(
                    x: x * Float(cellGeometry.width),
                    y: y * Float(cellGeometry.height),
                    z: 0
                )
                // Static physics body
                cellNode.physicsBody = .staticBody()
                cellNode.physicsBody?.categoryBitMask = Mask.FLOOR
                cellNode.physicsBody?.collisionBitMask = Mask.CHARACTER
                gridNode.addChildNode(cellNode)
            }
        }
        
        scene.rootNode.addChildNode(gridNode)
    }
    
    func createObstacleAtLocation(x: Float, y: Float, height: CGFloat) {
        // A single cell cube obstacle
        let length: CGFloat = 16
        let obstacleGeometry = SCNBox(
            width: length,
            height: length,
            length: length * height,
            chamferRadius: 0)
        let obstacleMaterial = SCNMaterial()
        
        let obstacleImage = UIImage(named: "obstacle-background")
        
        obstacleMaterial.diffuse.contents = obstacleImage
        obstacleGeometry.firstMaterial = obstacleMaterial
        
        // Find the center
        let horizontalMiddle = Float(grid.width) / 2
        let verticalMiddle = Float(grid.height) / 2
        
        // Find the appropriate position
        let obstaceNode = SCNNode(geometry: obstacleGeometry)
        obstaceNode.pivot = SCNMatrix4MakeTranslation(0, 0, -Float(obstacleGeometry.length)/2 - 3/2)
        obstaceNode.position = SCNVector3(
            x: (x - horizontalMiddle) * Float(length),
            y: (y - verticalMiddle) * Float(length),
            z: 0)
        
        gridNode.addChildNode(obstaceNode)
    }
    
}

