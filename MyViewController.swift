//
//  MyViewController.swift
//  Walker
//
//  Created by Tautvydas Stakėnas on 5/2/15.
//  Copyright (c) 2015 Tautvydas Stakėnas. All rights reserved.
//

import UIKit
import SceneKit

class MyViewController: UIViewController {
    
    @IBOutlet weak var sceneView: SCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Scene
        let scene = SCNScene()
        //sceneView.backgroundColor = UIColor.lightGrayColor()
        
        // Grid
        let grid = GridView(planeWidth: 50, planeHeight: 50, planeCountX: 10, planeCountY: 10)
        scene.rootNode.addChildNode(grid)
        
        // Camera
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        
        //cameraNode.camera?.orthographicScale = 200
        cameraNode.position = SCNVector3Make(100, 200, 1000)
        //cameraNode.camera?.usesOrthographicProjection = true
        cameraNode.camera?.zFar = 2000
        
        scene.rootNode.addChildNode(cameraNode)
        
        var x = SCNMatrix4MakeRotation(60*(Float(M_2_PI))/180, 1, 0, 0)
        var z = SCNMatrix4MakeRotation(60*(Float(M_2_PI))/180, 0, 0, 1)
        grid.pivot = SCNMatrix4Mult(x, z)
        
        // Create scene
        sceneView.scene = scene
        sceneView.allowsCameraControl = true
        
    }
    
}