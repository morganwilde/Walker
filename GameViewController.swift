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

class GameViewController: UIViewController, SCNPhysicsContactDelegate {
    
    // Outlets
    @IBOutlet weak var sceneView: SCNView!
    
    // Views
    var scene = SCNScene()
    var gridNode: GridNode!
    var characterNode: Character!
    
    // Models
    var grid = Grid()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Scene preferences
        let rootNode = scene.rootNode
        scene.physicsWorld.gravity = SCNVector3Make(0, 0, -10)
        scene.physicsWorld.contactDelegate = self
        
        // Grid
        gridNode = GridNode(width: 10, height: 1)
        rootNode.addChildNode(gridNode)
        
        // Character
        characterNode = Character()
        gridNode.putNodeOnCellAt(characterNode, x: 0, y: 0)
        
        // Camera
        rootNode.addChildNode(CameraNode())
    
        
        // Obstacles
//        // Left wall
//        createObstacleAtLocation(6, y: 6, height: 1)
//        createObstacleAtLocation(5, y: 6, height: 2)
//        createObstacleAtLocation(4, y: 6, height: 3)
//        createObstacleAtLocation(3, y: 6, height: 1)
//        createObstacleAtLocation(2, y: 6, height: 2)
//        createObstacleAtLocation(1, y: 6, height: 1)
//        createObstacleAtLocation(0, y: 6, height: 1)
//        // Front wall
//        createObstacleAtLocation(6, y: 5, height: 1)
//        createObstacleAtLocation(6, y: 4, height: 1)
//        createObstacleAtLocation(6, y: 2, height: 1)
//        createObstacleAtLocation(6, y: 1, height: 1)
//        createObstacleAtLocation(6, y: 0, height: 1)
        
        // Ambient light
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLightTypeAmbient
        ambientLightNode.light!.color = UIColor(white: 0.5, alpha: 1.0)
//        scene.rootNode.addChildNode(ambientLightNode)
        
        // Shadow light
        let shadowLightNode = SCNNode()
        shadowLightNode.light = SCNLight()
        shadowLightNode.light!.type = SCNLightTypeSpot
        shadowLightNode.light!.castsShadow = true
        shadowLightNode.light!.shadowColor = UIColor(white: 0, alpha: 1.0)
        shadowLightNode.light!.spotInnerAngle = 20
        shadowLightNode.light!.spotOuterAngle = 30
        shadowLightNode.position = SCNVector3Make(0, 0, 40)
        characterNode.addChildNode(shadowLightNode)

        
        // SceneView preferences
        sceneView.scene = scene
        sceneView.showsStatistics = true
        sceneView.allowsCameraControl = true
    }
    
    func createGridViews() {
        // Find the center
        let horizontalMiddle = grid.width / 2
        let verticalMiddle = grid.height / 2

        let cellGeometry = SCNBox(width: 2, height: 2, length: 2, chamferRadius: 0)
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
                cellNode.physicsBody?.categoryBitMask = Masks.FLOOR
                cellNode.physicsBody?.collisionBitMask = Masks.CHARACTER
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
        let obstacleNode = SCNNode(geometry: obstacleGeometry)
        obstacleNode.position = SCNVector3(
            x: (x - horizontalMiddle) * Float(length),
            y: (y - verticalMiddle) * Float(length),
            z: Float(grid.height) + Float(height) * 2)
        
        // Static physics body
        obstacleNode.physicsBody = .staticBody()
        obstacleNode.physicsBody?.categoryBitMask = Masks.OBSTACLE
        obstacleNode.physicsBody?.collisionBitMask = Masks.CHARACTER
        
        gridNode.addChildNode(obstacleNode)
    }
    
    func physicsWorld(world: SCNPhysicsWorld, didBeginContact contact: SCNPhysicsContact) {
        switch (contact.nodeA.physicsBody!.categoryBitMask | contact.nodeB.physicsBody!.categoryBitMask) {
        case (Masks.CHARACTER | Masks.OBSTACLE):
            // Stop character
            if let char = contact.nodeA as? Character {
                char.stop()
            } else if let char = contact.nodeB as? Character {
                char.stop()
            }
        case (Masks.CHARACTER | Masks.FLOOR):
            println("char on floor")
            // Prevent spam on default case
            break
        default:
            println("Collision between: \(contact.nodeA.physicsBody!.categoryBitMask) and \(contact.nodeB.physicsBody!.categoryBitMask)")
            break
        }
    }
    
}

