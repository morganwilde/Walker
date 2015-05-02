//
//  MyViewController.swift
//  Walker
//
//  Created by Tautvydas Stakėnas on 5/2/15.
//  Copyright (c) 2015 Tautvydas Stakėnas. All rights reserved.
//

import UIKit
import SceneKit

class MyViewController: ViewController {
    
    //@IBOutlet weak var sceneView: SCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Scene
        //let scene = SCNScene()
        //sceneView.backgroundColor = UIColor.lightGrayColor()
        
        // Grid
        let grid = GridView(planeWidth: 10, planeHeight: 10, planeCountX: 20, planeCountY: 6)
        let rotationX = SCNMatrix4MakeRotation(60*PI/180, 1, 0, 0)
        let rotationZ = SCNMatrix4MakeRotation(60*PI/180, 0, 0, 1)
        grid.pivot = SCNMatrix4Mult(rotationX, rotationZ)
        sceneView.scene!.rootNode.addChildNode(grid)
        
        //Walls
        for cellArray in grid.cells {
            for cell in cellArray{
                let i = arc4random_uniform(3)
                if(i > 1){
                    let wall = WallObstacle(cell: cell)
                    wall.pivot = grid.pivot
                    sceneView.scene!.rootNode.addChildNode(wall)
                }
            }
        }
       // sceneView.scene!.rootNode.addChildNode(cameraNode)
        
        // Create scene
        //sceneView.scene = scene
        //sceneView.allowsCameraControl = true
        
    }
    
}